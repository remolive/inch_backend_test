require 'rails_helper'

RSpec.describe Building, type: :model do
  let(:file) { file_fixture('buildings.csv') }
  let(:manager_names) { ['Martin Faure', 'Martin Faure'] }
  let(:manager_names_updated) { ['Hugo Faure', 'Hugo Faure'] }

  describe '#import_from_csv' do
    it 'creates buildings if reference does not exists' do
      expect { Building.import_from_csv(file) }.to change { Building.count }.from(0).to(2)
      expect(Building.pluck(:reference)).to eq(%w[1 2])
    end

    context 'when updating Buildings' do
      it 'updates if reference exists' do
        update_file = file_fixture('buildings_update.csv')
        Building.import_from_csv(file)
        expect(Building.pluck(:manager_name)).to eq(manager_names)
        expect { Building.import_from_csv(update_file) }.not_to change { Building.count }
        expect(Building.pluck(:manager_name)).to eq(manager_names_updated)
      end

      it 'does not update versioned attributes if value existed' do
        Building.import_from_csv(file)
        Building.all.each { |building| building.update(manager_name: manager_names_updated[0]) }
        Building.import_from_csv(file)
        expect(Building.pluck(:manager_name)).to eq(manager_names_updated)
      end
    end
  end

  describe '#update' do
    it 'update versioned attributes even if value existed' do
      building = Building.create(manager_name: manager_names[0])
      building.update(manager_name: manager_names_updated[0])
      expect {
        building.update(manager_name: manager_names[0])
      }.to change(building, :manager_name).from(manager_names_updated[0]).to(manager_names[0])
    end
  end
end
