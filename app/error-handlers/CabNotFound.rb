class CabNotFound < StandardError
    attr_accessor :message, :options
    def initialize(message=self.class.to_s, options={})
      @message = message
      @options = options
    end
  end