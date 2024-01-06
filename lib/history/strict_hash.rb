module History
  class StrictHash < Hash
    def self.attributes
      []
    end

    def initialize(options = {})
      self.class.attributes.each do |k|
        self[k] = options[k.to_sym] if options.has_key?(k.to_sym)
      end
    end

    def validate_key!(k)
      raise "#{k} is not a valid key" unless self.class.attributes.include?(k.to_sym)
    end

    def [](k)
      validate_key!(k)
      super(k.to_sym)
    end

    def []=(k, v)
      validate_key!(k)
      super(k.to_sym, v)
    end
  end
end
