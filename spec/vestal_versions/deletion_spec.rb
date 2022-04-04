require 'spec_helper'

describe VestalVersions::Deletion do
  let(:name){ 'Steve Richert' }
  subject{ DeletedUser.create(:first_name => 'Steve', :last_name => 'Richert') }

  context "a deleted version's changes" do

    before do
      subject.update_attribute(:last_name, 'Jobs')
    end

    it "removes the original record" do
      subject.destroy

      expect(DeletedUser.find_by_id(subject.id)).to be_nil
    end

    it "creates another version record" do
      expect{ subject.destroy }.to change{ VestalVersions::Version.count }.by(1)
    end

    it "creates a version with a tag 'deleted'" do
      subject.destroy
      expect(VestalVersions::Version.last.tag).to eq('deleted')
    end

  end

  context "deleted versions" do
    let(:last_version){ VestalVersions::Version.last }
    before do
      subject.update_attribute(:last_name, 'Jobs')
      subject.destroy
    end

    context "restoring a record with a bang" do
      it "is able to restore the user record" do
        last_version.restore!

        expect(last_version.versioned).to eq(subject)
      end

      it "removes the last versioned entry" do
        expect{
          last_version.restore!
        }.to change{ VestalVersions::Version.count }.by(-1)
      end

      it "works properly even if it's not on the proper version" do
        another_version = VestalVersions::Version.where(
          :versioned_id   => last_version.versioned_id,
          :versioned_type => last_version.versioned_type
        ).first

        expect(another_version).not_to eq(last_version)

        expect(another_version.restore!).to eq(subject)
      end

      it "restores even if the schema has changed" do
        new_mods = last_version.modifications.merge(:old_column => 'old')
        last_version.update(:modifications => new_mods)

        expect(last_version.restore).to eq(subject)
      end
    end

    context "restoring a record without a save" do
      it "does not save the DeletedUser when restoring" do
        expect(last_version.restore).to be_new_record
      end

      it "restores the user object properly" do
        expect(last_version.restore).to eq(subject)
      end

      it "does not decrement the versions table" do
        expect{
          last_version.restore
        }.to change{ VestalVersions::Version.count }.by(0)
      end
    end
  end

end
