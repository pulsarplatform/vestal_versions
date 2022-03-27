require 'spec_helper'

describe VestalVersions::Versions do
  subject{ User.new }
  let(:times){ {} }
  let(:names){
    ['Steve Richert', 'Stephen Richert', 'Stephen Jobs', 'Steve Jobs']
  }

  before do
    time = names.size.hours.ago

    names.each do |name|
      subject.update_attribute(:name, name)
      subject.tag_version(subject.version.to_s)
      time += 1.hour

      subject.versions.last.update_attribute(:created_at, time)
      times[subject.version] = time
    end
  end

  it 'is searchable between two valid version values' do
    times.keys.each do |number|
      times.values.each do |time|
        expect(subject.versions.between(number, number)).to be_a(Array)
        expect(subject.versions.between(number, time)).to be_a(Array)
        expect(subject.versions.between(time, number)).to be_a(Array)
        expect(subject.versions.between(time, time)).to be_a(Array)
        expect(subject.versions.between(number, number)).not_to be_empty
        expect(subject.versions.between(number, time)).not_to be_empty
        expect(subject.versions.between(time, number)).not_to be_empty
        expect(subject.versions.between(time, time)).not_to be_empty
      end
    end
  end

  it 'returns an empty array when searching between a valid and an invalid version value' do
    times.each do |number, time|
      expect(subject.versions.between(number, nil)).to eq([])
      expect(subject.versions.between(time, nil)).to eq([])
      expect(subject.versions.between(nil, number)).to eq([])
      expect(subject.versions.between(nil, time)).to eq([])
    end
  end

  it 'returns an empty array when searching between two invalid version values' do
    expect(subject.versions.between(nil, nil)).to eq([])
  end

  it 'is searchable before a valid version value' do
    times.sort.each_with_index do |(number, time), i|
      expect(subject.versions.before(number).size).to eq(i)
      expect(subject.versions.before(time).size).to eq(i)
    end
  end

  it 'returns an empty array when searching before an invalid version value' do
    expect(subject.versions.before(nil)).to eq([])
  end

  it 'is searchable after a valid version value' do
    times.sort.reverse.each_with_index do |(number, time), i|
      expect(subject.versions.after(number).size).to eq(i)
      expect(subject.versions.after(time).size).to eq(i)
    end
  end

  it 'returns an empty array when searching after an invalid version value' do
    expect(subject.versions.after(nil)).to eq([])
  end

  it 'is fetchable by version number' do
    times.keys.each do |number|
      expect(subject.versions.at(number)).to be_a(VestalVersions::Version)
      expect(subject.versions.at(number).number).to eq(number)
    end
  end

  it 'is fetchable by tag' do
    times.keys.map{|n| [n, n.to_s] }.each do |number, tag|
      expect(subject.versions.at(tag)).to be_a(VestalVersions::Version)
      expect(subject.versions.at(tag).number).to eq(number)
    end
  end

  it "is fetchable by the exact time of a version's creation" do
    times.each do |number, time|
      expect(subject.versions.at(time)).to be_a(VestalVersions::Version)
      expect(subject.versions.at(time).number).to eq(number)
    end
  end

  it "is fetchable by any time after the model's creation" do
    times.each do |number, time|
      expect(subject.versions.at(time + 30.minutes)).to be_a(VestalVersions::Version)
      expect(subject.versions.at(time + 30.minutes).number).to eq(number)
    end
  end

  it "returns nil when fetching a time before the model's creation" do
    creation = times.values.min
    expect(subject.versions.at(creation - 1.second)).to be_nil
  end

  it 'is fetchable by an association extension method' do
    expect(subject.versions.at(:first)).to be_a(VestalVersions::Version)
    expect(subject.versions.at(:last)).to be_a(VestalVersions::Version)
    expect(subject.versions.at(:first).number).to eq(times.keys.min)
    expect(subject.versions.at(:last).number).to eq(times.keys.max)
  end

  it 'is fetchable by a version object' do
    times.keys.each do |number|
      version = subject.versions.at(number)

      expect(subject.versions.at(version)).to be_a(VestalVersions::Version)
      expect(subject.versions.at(version).number).to eq(number)
    end
  end

  it 'returns nil when fetching an invalid version value' do
    expect(subject.versions.at(nil)).to be_nil
  end

  it 'provides a version number for any given numeric version value' do
    times.keys.each do |number|
      expect(subject.versions.number_at(number)).to be_a(Integer)
      expect(subject.versions.number_at(number + 0.5)).to be_a(Integer)
      expect(subject.versions.number_at(number)).to eq(subject.versions.number_at(number + 0.5))
    end
  end

  it 'provides a version number for a valid tag' do
    times.keys.map{|n| [n, n.to_s] }.each do |number, tag|
      expect(subject.versions.number_at(tag)).to be_a(Integer)
      expect(subject.versions.number_at(tag)).to eq(number)
    end
  end

  it 'returns nil when providing a version number for an invalid tag' do
    expect(subject.versions.number_at('INVALID')).to be_nil
  end

  it 'provides a version number of a version corresponding to an association extension method' do
    expect(subject.versions.at(:first)).to be_a(VestalVersions::Version)
    expect(subject.versions.at(:last)).to be_a(VestalVersions::Version)
    expect(subject.versions.number_at(:first)).to eq(times.keys.min)
    expect(subject.versions.number_at(:last)).to eq(times.keys.max)
  end

  it 'returns nil when providing a version number for an invalid association extension method' do
    expect(subject.versions.number_at(:INVALID)).to be_nil
  end

  it "provides a version number for any time after the model's creation" do
    times.each do |number, time|
      expect(subject.versions.number_at(time + 30.minutes)).to be_a(Integer)
      expect(subject.versions.number_at(time + 30.minutes)).to eq(number)
    end
  end

  it "provides a version number of 1 for a time before the model's creation" do
    creation = times.values.min
    expect(subject.versions.number_at(creation - 1.second)).to eq(1)
  end

  it 'provides a version number for a given version object' do
    times.keys.each do |number|
      version = subject.versions.at(number)

      expect(subject.versions.number_at(version)).to eq(number)
    end
  end

end
