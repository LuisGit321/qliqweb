require 'spec_helper'

REQUEST_SOURCE = "http://test.host/billing/agencies"

describe BillingAgenciesController do
  context "Super Admin should be able to if" do
    before(:each) do
      @user = Factory.create(:super_user)
      @request.env['devise.mapping'] = :super_user
      @user.confirm!
      sign_in @user
      request.env["HTTP_REFERER"] = REQUEST_SOURCE
    end
    it "create billing Agency if all the details are mentioned with a post request and its associated User should also get created" do
      post :create, :billing_agency => {:city => "pune", :address => "baner", :name => "testphygrp", :zip => "111111", :fax => "123-123-1234", :phone => "123-123-1234", :state => "Maharashtra",
                    :user_attributes => {:email => "testphy@testphy.com"}}
      ba = BillingAgency.find_by_name("testphygrp")
      ba.should_not == nil
      ba.user.email.should == "testphy@testphy.com"
    end

    it "update Billing Agency if all the detials are mentioned with a Put request and user should not get updated" do
      ba = Factory(:valid_agency)
      ba_user = ba.user
      post :update, {:billing_agency => {:name => "changed_name",
                    :user_attributes =>{:id => ba_user.id, :email => ba_user.email}},
                    :id => ba.id}
      bill_agency = BillingAgency.find_by_name("changed_name")
      bill_agency.should_not == nil
    end

    it "update Billing Agency email with a Put request and Billing Agency User email should get updated" do
      ba = Factory(:valid_agency)
      ba_user = ba.user
      post :update, {:billing_agency => {:name => "changed_name",
                    :user_attributes =>{:id => ba_user.id, :email => "update@update.com" }},
                    :id => ba.id}
      bill_agency = BillingAgency.find_by_name("changed_name")
      bill_agency.should_not == nil
      bill_agency.user.email.should == "update@update.com"
    end

    it "delete a billing Agency User with a delete request" do
      ba = Factory(:valid_agency)
      ba_user = ba.user
      delete :destroy, :id => ba.id
      bill_agency = BillingAgency.find_by_name("Test_Physician_group")
      bill_agency.should == nil
    end
  end
end
