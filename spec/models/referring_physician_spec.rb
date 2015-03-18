require 'spec_helper'

describe "Physician" do
  before(:each) do
    @referring_physician = Factory.build(:referring_physician)
  end
  after(:each) do
    @referring_physician.should_not be_valid
  end

  context "should not be referred" do
    it "if name is blank" do
      @referring_physician.name = ''
    end

    it "if fax as blank" do
      @referring_physician.fax = ''
    end

    it "if email format is invalid" do
      @referring_physician.email = 'referphy@@gmail.com'
    end

    it "if business phone is invalid( e.g alphanumeric)" do
      @referring_physician.phone = '4794324asdf'
    end

    it "if zipcode lenth is greater than 5 digits" do
      @referring_physician.zip = '411050'
    end

    it "if zipcode is invalid( e.g alphanumeric)" do
      @referring_physician.zip = '4as050'
    end
  end
end
