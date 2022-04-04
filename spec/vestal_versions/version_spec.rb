require 'spec_helper'

describe VestalVersions::Versions do
  let(:user){ User.create(:name => 'Stephen Richert') }

  before do
    user.update_attribute(:name, 'Steve Jobs')
    user.update_attribute(:last_name, 'Richert')
    @first_version, @last_version = user.versions.first, user.versions.last
  end

  it 'is comparable to another version based on version number' do
    expect(@first_version).to eq(@first_version)
    expect(@last_version).to eq(@last_version)
    expect(@first_version).not_to eq(@last_version)
    expect(@last_version).not_to eq(@first_version)
    expect(@first_version).to be < @last_version
    expect(@last_version).to be > @first_version
    expect(@first_version).to be <= @last_version
    expect(@last_version).to be >= @first_version
  end

  it "is not equal a separate model's version with the same number" do
    other = User.create(:name => 'Stephen Richert')
    other.update_attribute(:name, 'Steve Jobs')
    other.update_attribute(:last_name, 'Richert')
    first_version, last_version = other.versions.first, other.versions.last

    expect(@first_version).not_to eq(first_version)
    expect(@last_version).not_to eq(last_version)
  end

  it 'defaults to ordering by number when finding through association' do
    numbers = user.versions.map(&:number)
    expect(numbers.sort).to eq(numbers)
  end

  it 'returns true for the "initial?" method when the version number is 1' do
    version = user.versions.build(:number => 1)
    expect(version.number).to eq(1)
    expect(version).to be_initial
  end
  
  it "sreturn the version number if it is not a revert" do
    expect(user.version).to eq(user.versions.last.original_number)
  end

  it "return the reverted_version if it is a revert" do
    user.revert_to!(1)
    expect(user.versions.last.original_number).to eq(1)
  end

  it "return the original version if it is a double revert" do
    user.revert_to!(2)
    version = user.version
    user.update(:last_name => 'Gates')
    user.revert_to!(version)
    expect(user.versions.last.original_number).to eq(2)
  end
  
end
