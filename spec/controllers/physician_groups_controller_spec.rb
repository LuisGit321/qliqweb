require 'spec_helper'

describe PhysicianGroupsController do
  context "Super Admin should be able to" do
    before(:each) do
      @bill_agency = Factory(:valid_agency)
      @user = Factory.create(:super_user)
      @request.env['devise.mapping'] = :super_user
      @user.confirm!
      sign_in @user
    end

    it "should get index of physician group" do
      get :index
      response.should be_success
    end

    it "create physician group with all the details mentioned" do
      post :create, :physician_group => {:name => "test_phy_grp", :city => "pune", :address => "pune", :zip => "11111", :fax => "123-123-1234", :phone => "123-123-1234", :state => "AA",
                    :billing_pref_attributes => {:billing_agency_id => @bill_agency.id}}
      phy_grp = PhysicianGroup.find_by_name("test_phy_grp")
      phy_grp.name.should_not == nil
      billpref = phy_grp.billing_pref
      billpref.should_not == nil
    end

    it "update a physician group" do
      physician = Factory.create(:physician_group)
      put :update, :id => physician.id, 
                   :physician_group => {:name => "Changed name"}
      phygrp = PhysicianGroup.find_by_name("Changed name")
      phygrp.should_not == nil
      phygrp.name.should == "Changed name"
    end

    it "update physician group billing agency" do
      physician = Factory.create(:physician_group)
      bill_agency = BillingAgency.create(:name => "update_bill", :phone => "123-123-1234")
      put :update, :id => physician.id, 
                   :physician_group => {:name => "Changed name",
                   :billing_pref_attributes => {:billing_agency_id => bill_agency.id}}
      phygrp = PhysicianGroup.find_by_name("Changed name")
      phygrp.should_not == nil
      phygrp.name.should == "Changed name"
      phygrp.billing_pref.billing_agency_id.should == bill_agency.id
    end

    it "should delete a physician group" do
      physician = Factory.create(:physician_group)
      delete :destroy, :id => physician.id
      PhysicianGroup.find_by_name("Test Physician group 1").should == nil
    end
  end

=begin
  context "Physician Group User [Group Admin] should only update and change agency of Physician Group" do
    before(:each) do
      group_admin_physician = Factory.create(:physician_group_admin)
      @request.env['devise.mapping'] = :physician_group_admin
      @user = group_admin_physician.user
      @user.confirm!
      sign_in @user
    end

    it "should not get index of physician group" do
      get :index
      response.should_not be_success
    end
    
    it "should update a physician group" do
      put :update, :id => @user.resource.physician_group.id, :physician_group => {:name => "Changed name", :fax => "332211"}
      answer = PhysicianGroup.find_by_name("Changed name")
      answer.name.should == "Changed name"
    end

    it "should not create physician group" do
      post :create, :physician_group => {:name => "Group Group"}
      PhysicianGroup.find_by_name("Group Group").should == nil
    end

    it "should not delete a physician group" do
      delete :destroy, :id => @user.resource.physician_group.id
      PhysicianGroup.find(@user.resource.physician_group.id).should_not == nil
    end

    it "should change billing agency of physician group" do
      agency2 = Factory.create(:group_billing_agency2)
      post :change_agency, :physician_group => { :billing_agency_id => agency2.id }
      @user.resource.physician_group.billing_pref.billing_agency.id.should == agency2.id
    end
  end

  context "Physician Admin User [Physician Admin] not able to CRUD Physician Group" do
    before(:each) do
      physician_admin = Factory.create(:physician_admin)
      @request.env['devise.mapping'] = :physician_admin
      @user = physician_admin.user
      @user.confirm!
      sign_in @user
    end

    it "should not update a physician group" do
      physician = Factory.create(:user_physician_group)
      put :update, :id => @user.resource.physician_group.id, :physician_group => {:name => "Change my name", :fax => "332211"}
      PhysicianGroup.find_by_name("Change my name").should == nil
    end

    it "should not get index of physician group" do
      get :index
      response.should_not be_success
    end

    it "should not create physician group" do
      post :create, :physician_group => {:name => "Abc"}
      PhysicianGroup.find_by_name("Abc").should == nil
    end

    it "should not delete a physician group" do
      delete :destroy, :id => @user.resource.physician_group.id
      PhysicianGroup.find(@user.resource.physician_group.id).should_not == nil
    end
  end

  context "Physician Functional User [Physician Functional] not able to CRUD Physician Group" do
    before(:each) do
      physician_functional = Factory.create(:physician_functional)
      @request.env['devise.mapping'] = :physician_functional
      @user = physician_functional.user
      @user.confirm!
      sign_in @user
    end

    it "should not update a physician group" do
      put :update, :id => @user.resource.physician_group.id, :physician_group => {:name => "name is changed", :fax => "332211"}
      PhysicianGroup.find_by_name("name is changed").should == nil
    end

    it "should not get index of physician group" do
      get :index
      response.should_not be_success
    end

    it "should not create physician group" do
      post :create, :physician_group => {:name => "Functional group"}
      PhysicianGroup.find_by_name("functional group").should == nil
    end

    it "should not delete a physician group" do
      delete :destroy, :id => @user.resource.physician_group.id
      PhysicianGroup.find(@user.resource.physician_group.id).should_not == nil
    end

  end
  
  context "Billing Admin User [Billing Admin] not able to CRUD Physician Group" do

    before(:each) do
      billing_agency = Factory.create(:group_billing_agency)
      @request.env['devise.mapping'] = :group_billing_agency
      @user = billing_agency.user
      @user.confirm!
      sign_in @user
    end
    it "should not create physician group" do
      post :create, :physician_group => {:name => "Billing Group"}
      PhysicianGroup.find_by_name("Billing Group").should == nil
    end
  end
=end
end
