class AttributeVersion < ApplicationRecord
  belongs_to :versionable, polymorphic: true
end
