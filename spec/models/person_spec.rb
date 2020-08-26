require 'rails_helper'

RSpec.describe Person, type: :model do
  let(:file) { file_fixture('peoples.csv') }
  let(:emails) { ['h.dupont@gmail.com', 'j.durand@gmail.com'] }
  let(:emails_updated) { ['p.dupont@gmail.com', 'm.durand@gmail.com'] }

  it 'uses pre-defined versioned attributes' do
    expect(Person::ATTR_VERSIONED).to eq(%w[email home_phone_number mobile_phone_number address])

    params = {
      firstname: 'test',
      email: 'test@example.com',
      home_phone_number: '0122334455',
      mobile_phone_number: '0122334455',
      address: '10 rue du Temple',
    }
    versioned_attributes = [
      ['email', 'test@example.com'],
      ['home_phone_number', '0122334455'],
      ['mobile_phone_number', '0122334455'],
      ['address', '10 rue du Temple']
    ]
    expect { Person.create(params) }.to change { AttributeVersion.count }.from(0).to(4)
    expect(AttributeVersion.pluck(:attr_name, :attr_value)).to eq(versioned_attributes)
  end

  describe '#import_from_csv' do
    it 'creates Persons if reference does not exists' do
      expect { Person.import_from_csv(file) }.to change { Person.count }.from(0).to(2)
      expect(Person.pluck(:reference)).to eq(%w[1 2])
    end

    it 'ignores non-existing columns' do
      file = file_fixture('non_existing_column.csv')
      expect { Person.import_from_csv(file) }.to change { Person.count }.from(0).to(2)
      expect(Person.pluck(:reference)).to eq(%w[1 2])
    end

    context 'when updating Persons' do
      it 'updates if reference exists' do
        update_file = file_fixture('peoples_update.csv')
        Person.import_from_csv(file)
        expect(Person.pluck(:email)).to eq(emails)
        expect { Person.import_from_csv(update_file) }.not_to change { Person.count }
        expect(Person.pluck(:email)).to eq(emails_updated)
      end

      it 'does not update versioned attributes if value existed' do
        firstnames = %w[Henri Jean]
        firstnames_updated = %w[Patrick Martin]

        persons = Person.import_from_csv(file)
        persons.each_with_index do |person, index|
          person.update(email: emails_updated[index], firstname: firstnames_updated[index])
        end

        expect(Person.pluck(:email) + Person.pluck(:firstname)).to eq(emails_updated + firstnames_updated)

        Person.import_from_csv(file)
        expect(Person.pluck(:email) + Person.pluck(:firstname)).to eq(emails_updated + firstnames)
      end
    end
  end

  describe '#update' do
    it 'update versioned attributes even if value existed' do
      person = Person.create(email: emails[0])
      person.update(email: emails_updated[0])
      expect {
        person.update(email: emails[0])
      }.to change(person, :email).from(emails_updated[0]).to(emails[0])
    end
  end
end
