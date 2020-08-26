module VersionableConcern
  extend ActiveSupport::Concern
  include ImportableConcern

  included do
    has_many :attribute_versions, as: :versionable, dependent: :destroy
    before_save :apply_import_attr_rules, if: -> { imported? }
    after_save :save_attr_version
  end

  def apply_import_attr_rules
    self.class::ATTR_VERSIONED.each do |attr_name|
      if eval("#{attr_name}_changed?")
        occurrences = eval("attribute_versions.where(attr_name: attr_name, attr_value: #{attr_name})")
        eval("restore_#{attr_name}!") if occurrences.exists?
      end
    end
  end

  def save_attr_version
    self.class::ATTR_VERSIONED.each do |attr_name|
      occurrences = eval("attribute_versions.where(attr_name: attr_name, attr_value: #{attr_name})")
      unless occurrences.exists?
        eval("attribute_versions.create(attr_name: attr_name, attr_value: #{attr_name})")
      end
    end
  end
end