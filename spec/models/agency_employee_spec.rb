require 'spec_helper'

describe AgencyEmployee do
  context "should get created if" do
    it "if all the details are entered" do
      ba = Factory(:agency_employee)
      ba.should be_valid
    end

    it "only name and email is entered" do
      ba = Factory(:agency_employee)
      ba.should be_valid
    end
  end

  context "should not be created if" do
    it "name is blank" do
      ba = Factory(:agency_employee_name_email)
      ba.name = ""
      ba.save
      ba.should_not be_valid
    end

    it "email is blank" do
      ba = Factory(:agency_employee_name)
      ba_user = ba.user
      ba_user.email = ""
      ba_user.save
      ba.should_not be_valid
    end

    it "name is already taken" do
      ba = Factory(:agency_employee_name)
      ba1 = AgencyEmployee.new 
      ba1.name = ba.name
      ba1.save
      ba1.should_not be_valid
    end

    it "email is already taken" do
      ba = Factory(:agency_employee_name)
      ba1 = AgencyEmployee.create(:name => "test123")
      ba1_user = ba1.build_user
      ba1_user.email = ba.user.email
      ba1_user.save
      ba1.save
      ba1.should_not be_valid
    end

    it "email is in wrong format" do
      ba1 = AgencyEmployee.create(:name => "test123")
      ba1_user = ba1.build_user
      ba1_user.email = "aaaa"
      ba1_user.save
      ba1.save
      ba1.should_not be_valid
    end

    it "zip contains alphanumeral characters" do
      ba = Factory.build(:agency_employee)
      ba.zip = "11aaaa"
      ba.save
      ba.should_not be_valid
    end

    it "buisness phone contains alphanumeral characters" do
      ba = Factory.build(:agency_employee)
      ba.phone = "1212asasa"
      ba.save
      ba.should_not be_valid
    end

    it "buisness phone contains numbers more then 15" do
      ba = Factory.build(:agency_employee)
      ba.zip = "1111111111111111111"
      ba.save
      ba.should_not be_valid
    end
  end
end
