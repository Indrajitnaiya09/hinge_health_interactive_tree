# frozen_string_literal: true

module CustomErrorHandler
  class ParentNotFoundError < StandardError
    attr_reader :status, :message

    def initialize(message)
      @message = message
      @status = :not_found
    end
  end

  class InvalidRootError < StandardError
    attr_reader :status, :message

    def initialize(message = 'Root index not found')
      @message = message
      @status = :not_found
    end
  end

  class DataTypeError < StandardError
    attr_reader :status, :message

    def initialize(message = 'Type not supported')
      @message = message
      @status = :bad_request
    end
  end

  class ParamMissingError < StandardError
    attr_reader :status, :message

    def initialize(message = 'Invalid param missing error')
      @message = message
      @status = :bad_request
    end
  end
end
