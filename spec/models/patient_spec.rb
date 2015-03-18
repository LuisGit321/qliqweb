require 'spec_helper'

describe "Physician" do

  before(:each) do
    @patient = Factory.build(:patient)
  end

  after(:each) do
    @patient.should_not be_valid
  end

  context "should not be able add a patient without" do

    it "first name" do
      @patient.first_name = ''
    end

    it "last name" do
      @patient.last_name = ''
    end

    it "date of birth" do
      @patient.date_of_birth = ''
    end
  end
end

describe "Patient" do

  before(:each) do
    @patient = Factory.build(:patient)
  end

  it "should be saved if data is valid" do
    @patient.save
    ret = Patient.exists?(@patient)
    ret.should == true
  end
  
  it "date of birth should not be greater than current date" do
    dob = DateTime.now + 1.day
    @patient.date_of_birth = dob.strftime('%Y-%m-%d')
    @patient.should_not be_valid
  end

  context "should not saved if" do

    it "email is in improper format e.g(patient@@@@gmail.com)" do
      @patient.email = 'patient@@@@gmail.com'
      @patient.should_not be_valid
    end

    it "phone number is in improper format e.g(983defghi)" do
      @patient.phone = '983defghi'
      @patient.should_not be_valid
    end
  end
end
