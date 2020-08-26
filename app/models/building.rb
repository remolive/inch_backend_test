class Building < ApplicationRecord
  include VersionableConcern

  ATTR_VERSIONED = %w[manager_name].freeze
end
