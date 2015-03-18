require 'spec_helper'

describe Superbill do
  context "should be created if" do
    it "all the details are provided" do
      su = Factory.create(:super_bill_name_speciality_state)
      su.should be_valid
      su1 = Superbill.find_by_name("test_superbill_state")
      su1.should_not == nil
    end

    it "state is not mentioned" do
      su = Factory.create(:super_bill_name_speciality)
      su.should be_valid
      su1 = Superbill.find_by_name("testing_superbill")
      su1.should_not == nil
    end
  end
  context "should not be created if" do
    it "name is already taken" do
      su = Factory.create(:super_bill_name_speciality)
      su1 = Superbill.create(:name => "test_superbill", :specialty_id => 1)
      su1.save
      su1.should_not be_valid
    end

    it "name is blank" do
      su1 = Superbill.create(:specialty_id => 1)
      su1.save
      su1.should_not be_valid
    end

    it "speciality is not selected" do
      su1 = Superbill.create(:name => "test11")
      su1.save
      su1.should_not be_valid
    end
  end
end
