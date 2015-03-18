require 'spec_helper'

describe Encounter do
  
  before(:each) do
    @physician = Factory.create(:physician_functional)
    @patient =   @physician.patients.first
    @encounter = Factory.build(:encounter, :patient_id => @patient.id, :physician_id => @physician.id)
  end
  after(:each) do
    @encounter.should_not be_valid
  end

  it "date of service should be in future" do
    @encounter.date_of_service = Date.today + 1.day
  end

  context "encounter should not created" do
    it "without date of service" do
      @encounter.date_of_service = ''
    end

    it "without physician" do
      @encounter.physician_id = ''
    end
  end
end
