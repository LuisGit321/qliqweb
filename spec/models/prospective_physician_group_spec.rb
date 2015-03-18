require 'spec_helper'
describe ProspectivePhysicianGroup do
  before(:each) do
    @prospective_physician_group = Factory.build(:valid_prospective_physician_group)
  end

  it "should succeed creating a new :valid_prospective_physician_group from the Factory" do
    @prospective_physician_group.save
    ProspectivePhysicianGroup.exists?(@physician_group).should be_true
  end

  it "should be invalid  with invalid_prospective_physician_group factory" do
    Factory.build(:invalid_prospective_physician_group).should be_invalid
  end

  it "should be valid  with 12345-4567 formatted zip " do
    @prospective_physician_group.zip = '12345-4567'
    @prospective_physician_group.should be_valid
  end
  it "should be invalid  with invalid zip " do
    @prospective_physician_group.zip = '123445'
    @prospective_physician_group.should_not be_valid
  end
  it "should be invalid  with alphabetic characters in zip " do
    @prospective_physician_group.zip = '12s45'
    @prospective_physician_group.should_not be_valid
  end

  it "should be invalid  with invalid phone " do
    @prospective_physician_group.phone = '123434534435234523' #should be 10 digit or format with 111-111-1111
    @prospective_physician_group.should_not be_valid
  end
  it "should valid  with  111-111-1111 format phone " do
    @prospective_physician_group.phone = '111-111-1111'
    @prospective_physician_group.should be_valid
  end
  it "should be invalid  with invalid fax " do
    @prospective_physician_group.phone = '123434534' #should be 10 digit or format with 111-111-1111
    @prospective_physician_group.should_not be_valid
  end
  it "should valid  with  111-111-1111 format fax " do
    @prospective_physician_group.phone = '111-111-1111'
    @prospective_physician_group.should be_valid
  end

  it "should invalid with  alphanumeric providers " do
    @prospective_physician_group.providers = 'as4'
    @prospective_physician_group.should_not be_valid
  end
  it "should invalid with  float providers " do
    @prospective_physician_group.providers = 5.1
    @prospective_physician_group.should_not be_valid
  end


end