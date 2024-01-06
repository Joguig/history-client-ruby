module History
  # Contains a list of audits returned from the query sent to the History Service, as well as pagination information
  class QueryResult
    attr_accessor :audits, :total_pages

    def self.from_hash(hash)
      result = QueryResult.new()

      result.audits = hash['audits']
      result.total_pages = hash['total_pages']

      result
    end

    def empty?
      audits.empty? && total_pages == 0
    end
  end
end
