require 'faraday'
require 'faraday_middleware'
require 'faraday/detailed_logger'

# Contains support for writing audits to the History API
module History
  class Client
    OPEN_TIMEOUT = 2
    READ_TIMEOUT = 10
    TOTAL_TIMEOUT = OPEN_TIMEOUT + READ_TIMEOUT

    AUDITS_PATH = '/v1/audits'
    CONTENT_TYPE_JSON = 'application/json'
    MAX_RETRY = 5

    attr_accessor :debug_logging, :endpoint, :connection

    def initialize(options = {})
      @endpoint = options['endpoint']
      @debug_logging = !!options['debug_logging']

      init_connection(options)
    end

    # Sets & caches the Faraday connection for writing and searching audits
    def init_connection(options = {})
      if options['connection']
        @connection = options['connection']
        return
      end

      url = [@endpoint, AUDITS_PATH].join

      @connection = Faraday.new(url: url) do |faraday|
        faraday.request :json
        faraday.adapter Faraday.default_adapter
        faraday.response :json, :content_type => /\bjson$/
        faraday.response :detailed_logger if debug_logging
      end

      @connection.options.merge!(
        timeout: TOTAL_TIMEOUT,
        open_timeout: OPEN_TIMEOUT
      )
    end

    # Sets audit uuid if not present. Makes POST to history create endpoint.
    # Returns response if the request was successful, otherwise throws
    # an error
    def add(audit)
      raise ArgumentError.new('Audit record is invalid') if audit.nil?

      audit.set_uuid! if audit[:uuid].to_s.empty?
      raise ArgumentError.new('Audit record is invalid') if !audit.valid?

      try = 1
      begin
        response = @connection.post do |request|
          request.headers['Accept'] = CONTENT_TYPE_JSON
          request.headers['Content-Type'] = CONTENT_TYPE_JSON
          request.body = audit.to_json
        end
      rescue Exception => e
        raise e if try == MAX_RETRY

        back_off(try)
        try += 1
        retry
      end

      response
    end

    # Takes a SearchParams object as an argument and issues a request to the History Service search endpoint
    # Returns audits matching the supplied SearchParams and pagination info in a QueryResult object if the
    # request was successful, otherwise throws an error
    def search(params)
      response = @connection.get do |request|
        request.headers['Accept'] = CONTENT_TYPE_JSON
        request.headers['Content-Type'] = CONTENT_TYPE_JSON
        request.params = request.params.merge(params.to_hash)
      end

      History::QueryResult.from_hash(response.body)
    end

    private

    # We could back off exponentially, but for now it's hardcoded to 0.5s
    def back_off(try)
      sleep 0.5
    end
  end
end
