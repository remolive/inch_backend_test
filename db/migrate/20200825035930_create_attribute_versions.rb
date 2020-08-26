class CreateAttributeVersions < ActiveRecord::Migration[6.0]
  def change
    create_table :attribute_versions do |t|
      t.string :attr_name
      t.string :attr_value
      t.references :versionable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
