class RawDocument < ActiveRecord::Base
  serialize :identity, Hash
  serialize :keys, Array
  serialize :payload_schema, Array
end
