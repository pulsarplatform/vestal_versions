require 'spec_helper'

describe VestalVersions::VersionTagging do
  let(:user){ User.create(:name => 'Steve Richert') }

  before do
    user.update_attribute(:last_name, 'Jobs')
  end

  context 'an untagged version' do
    it "updates the version record's tag column" do
      tag_name = 'TAG'
      last_version = user.versions.last

      expect(last_version.tag).not_to eq(tag_name)
      user.tag_version(tag_name)
      expect(last_version.reload.tag).to eq(tag_name)
    end

    it 'creates a version record for an initial version' do
      user.revert_to(1)
      expect(user.versions.at(1)).to be_nil

      user.tag_version('TAG')
      expect(user.versions.at(1)).not_to be_nil
    end
  end

  context 'A tagged version' do
    subject{ user.versions.last }

    before do
      user.tag_version('TAG')
    end

    it { is_expected.to be_tagged }
  end

end
