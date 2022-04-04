require 'spec_helper'

describe VestalVersions::Versioned do
  it 'respond to the "versioned?" method' do
    expect(ActiveRecord::Base).to respond_to(:versioned?)
    expect(User).to respond_to(:versioned?)
  end

  it 'return true for the "versioned?" method if the model is versioned' do
    expect(User).to be_versioned
  end

  it 'return false for the "versioned?" method if the model is not versioned' do
    expect(ActiveRecord::Base).not_to be_versioned
  end
end
