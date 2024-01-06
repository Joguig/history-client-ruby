require 'json'
require 'uuidtools'

# Contains logic for representing an Audit, which is shared by both the history-search and history-add ruby clients
module History
  class Audit < StrictHash
    # this is a pre-generated v4 UUID used by both history clients as the default namespace for v5 UUIDs generated
    # for audit records
    NAMESPACE_UUID = UUIDTools::UUID.parse('d45db28b-34ed-4738-8f7a-db2a993feadb')

    def self.attributes
      [:uuid, :action, :user_type, :user_id, :resource_type,
       :resource_id, :description, :created_at, :expiry, :expired_at, :changes]
    end

    def set_uuid!
      self[:uuid] = UUIDTools::UUID.sha1_create(NAMESPACE_UUID, uuid_name).to_s
    end

    def valid?
      return false if self.values_at(:uuid, :action, :user_type, :user_id).any?(&:nil?)

      self[:changes].to_a.each do |c|
        return false if !c.valid?
      end

      return true
    end

    def as_json(options = {})
      super.merge(
        "uuid" => self["uuid"].to_s,
        "action" => self["action"].to_s,
        "user_type" => self["user_type"].to_s,
        "user_id" => self["user_id"].to_s,
        "resource_type" => self["resource_type"].to_s,
        "resource_id" => self["resource_id"].to_s,
        "description" => self["description"].to_s,
        "created_at" => self["created_at"].to_s,
        "expiry" => self["expiry"].to_i,
      )
    end

    private

    # varying portion of the audit record used to generate a well-distributed v5 UUID
    def uuid_name
      self.values_at(:action, :user_type, :user_id, :resource_type, :resource_id, :description, :created_at, :expiry).join
    end
  end
end
