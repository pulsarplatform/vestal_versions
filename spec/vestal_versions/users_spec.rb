require 'spec_helper'

describe VestalVersions::Users do
  let(:updated_by){ User.create(:name => 'Steve Jobs') }
  let(:user){ User.create(:name => 'Steve Richert') }

  it 'defaults to nil' do
    user.update(:first_name => 'Stephen')
    expect(user.versions.last.user).to be_nil
  end

  it 'accepts and returns an ActiveRecord user' do
    user.update(:first_name => 'Stephen', :updated_by => updated_by)
    expect(user.versions.last.user).to eq(updated_by)
  end

  it 'accepts and returns a string user name' do
    user.update(:first_name => 'Stephen', :updated_by => updated_by.name)
    expect(user.versions.last.user).to eq(updated_by.name)
  end
end
