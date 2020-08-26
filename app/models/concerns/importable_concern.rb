module ImportableConcern
  require 'csv'

  extend ActiveSupport::Concern

  included do
    attr_accessor :imported
  end

  class_methods do
    def import_from_csv(csv)
      CSV.foreach(csv, headers: true) do |row|
        existing_record = find_by(reference: row['reference'])
        params = row.to_h.slice(*column_names)
        if existing_record.nil?
          create(params)
        else
          existing_record.imported = true
          existing_record.update(params)
        end
      end
    end
  end

  def imported
    @imported ||= false
  end

  def imported?
    imported
  end
end