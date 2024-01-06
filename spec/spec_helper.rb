# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

if ENV['CI'] == 'true'
  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

require 'history_client'

# Fakes a faraday client
class FakeFaraday
  def initialize(response)
    @response = response
  end

  def options
    {}
  end

  def get
    @response
  end

  def post
    @response
  end
end

# Fakes a faraday success response
class FakeSuccessResponse
  def success?
    true
  end

  def status
    200
  end

  def body
    {}
  end
end

# Fakes a faraday forbidden response
class FakeForbiddenResponse
  def success?
    false
  end

  def status
    403
  end

  def body
    {}
  end
end

# Fakes a faraday error response
class FakeErrorResponse
  def success?
    false
  end

  def status
    500
  end

  def body
    {}
  end
end
