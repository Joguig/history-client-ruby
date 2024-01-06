module History
  # Represents the different contraints available when querying the History Service for audits
  class SearchParams < StrictHash
    def self.attributes
      [:action, :user_type, :user_id, :resource_type, :resource_id, :attribute, :old_value, :new_value,
       :created_at_lt, :created_at_lte, :created_at_gt, :created_at_gte, :page, :per_page]
    end
  end
end
