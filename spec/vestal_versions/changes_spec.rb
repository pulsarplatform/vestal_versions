require 'spec_helper'

describe VestalVersions::Changes do
  context "a version's changes" do
    let(:user){ User.create(:name => 'Steve Richert') }
    subject{ user.versions.last.changes }

    before do
      user.update_attribute(:last_name, 'Jobs')
    end

    it { is_expected.to be_a(Hash) }
    it { is_expected.not_to be_empty }

    it 'has string keys' do
      subject.keys.each{ |key| expect(key).to be_a(String) }
    end

    it 'has two-element array values' do
      subject.values.each do |key|
        expect(key).to be_a(Array)
        expect(key.size).to eq(2)
      end
    end

    it 'has unique-element values' do
      subject.values.each{ |v| expect(v.uniq).to eq(v) }
    end

    it "equals the model's changes" do
      user.first_name = 'Stephen'
      model_changes = user.changes
      user.save
      changes = user.versions.last.changes

      expect(model_changes).to eq(changes)
    end
  end

  context 'a hash of changes' do
    let(:changes){ {'first_name' => ['Steve', 'Stephen']} }
    let(:other){ {'first_name' => ['Catie', 'Catherine']} }

    it 'properly appends other changes' do
      expected = {'first_name' => ['Steve', 'Catherine']}

      expect(changes.append_changes(other)).to eq(expected)

      changes.append_changes!(other)
      expect(changes).to eq(expected)
    end

    it 'properly prepends other changes' do
      expected = {'first_name' => ['Catie', 'Stephen']}

      expect(changes.prepend_changes(other)).to eq(expected)

      changes.prepend_changes!(other)
      expect(changes).to eq(expected)
    end

    it 'is reversible' do
      expected = {'first_name' => ['Stephen', 'Steve']}

      expect(changes.reverse_changes).to eq(expected)

      changes.reverse_changes!
      expect(changes).to eq(expected)
    end
  end

  context 'the changes between two versions' do
    let(:name){ 'Steve Richert' }
    let(:user){ User.create(:name => name) }          # 1
    let(:version){ user.version }

    before do
      user.update_attribute(:last_name, 'Jobs')       # 2
      user.update_attribute(:first_name, 'Stephen')   # 3
      user.update_attribute(:last_name, 'Richert')    # 4
      user.update_attribute(:name, name)              # 5
    end

    it 'is a hash' do
      1.upto(version) do |i|
        1.upto(version) do |j|
          expect(user.changes_between(i, j)).to be_a(Hash)
        end
      end
    end

    it 'has string keys' do
      1.upto(version) do |i|
        1.upto(version) do |j|
          user.changes_between(i, j).keys.each{ |key| expect(key).to be_a(String) }
        end
      end
    end

    it 'has two-element arrays with unique values' do
      1.upto(version) do |i|
        1.upto(version) do |j|
          user.changes_between(i, j).values.each do |value|
            expect(value).to be_a(Array)
            expect(value.size).to eq(2)
            expect(value.uniq).to eq(value)
          end
        end
      end
    end

    it 'is empty between identical versions' do
      expect(user.changes_between(1, version)).to be_empty
      expect(user.changes_between(version, 1)).to be_empty
    end

    it 'is should reverse with direction' do
      1.upto(version) do |i|
        i.upto(version) do |j|
          up    = user.changes_between(i, j)
          down  = user.changes_between(j, i)
          expect(up).to eq(down.reverse_changes)
        end
      end
    end

    it 'is empty with invalid arguments' do
      1.upto(version) do |i|
        expect(user.changes_between(i, nil)).to be_blank
        expect(user.changes_between(nil, i)).to be_blank
      end
    end
  end
end
