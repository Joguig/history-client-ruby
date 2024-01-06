module History
  class ChangeSet < StrictHash
    def self.attributes
      [:attribute, :old_value, :new_value]
    end

    def valid?
      return false if self[:attribute].nil?

      return true
    end

    def as_json(options = {})
      super.merge(
        "attribute" => self["attribute"].to_s,
        "old_value" => self["old_value"].to_s,
        "new_value" => self["new_value"].to_s,
      )
    end
  end
end
