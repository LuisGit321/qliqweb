require 'spec_helper'
describe 'BillingAgency' do
  context "should be created if " do
    it "all the details are entered and user object should be created" do
      ba = Factory(:valid_agency)
      ba.should be_valid
      ba.user.should_not == nil
    end
    it "name,phone and email is entered" do
      ba_npe = Factory.create(:valid_name_phone_email_agency)
      ba_npe.should_not == nil
      ba_npe.user.should_not == nil
    end
  end

  context "should not be created and user should not be created if " do
    it "name is blank" do
      name_nil_agency = Factory.build(:name_nil_agency)
      name_nil_agency.save
      name_nil_agency.should_not be_valid
      name_nil_agency.user.should == nil
    end

    it "name is already taken" do
      name = Factory(:valid_agency)
      name_nil_agency = Factory.build(:name_nil_agency)
      name_nil_agency.name = name.name
      name_nil_agency.save
      name_nil_agency.should_not be_valid
      name_nil_agency.user.should == nil
    end

    it "name contains blank spaces" do
      name_space_blank_agency = Factory.build(:name_space_blank_agency)
      name_space_blank_agency.save
      name_space_blank_agency.should_not be_valid
      name_space_blank_agency.user.should == nil
    end

    it "phone is blank" do
      phone_nil_agency = Factory.build(:phone_nil_agency)
      phone_nil_agency.save
      phone_nil_agency.should_not be_valid
      phone_nil_agency.user.should == nil
    end

    it "phone contains alphanumerals characters" do
      phone_nil_agency = Factory.build(:phone_nil_agency)
      phone_nil_agency.phone = "123wwww"
      phone_nil_agency.save
      phone_nil_agency.should_not be_valid
      phone_nil_agency.user.should == nil
    end
  end
end



