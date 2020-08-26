class Person < ApplicationRecord
  include VersionableConcern

  ATTR_VERSIONED = %w[email home_phone_number mobile_phone_number address].freeze
end
