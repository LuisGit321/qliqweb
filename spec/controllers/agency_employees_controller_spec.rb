require 'spec_helper'

#REQUEST_SOURCE = "http://test.host/agency/employees"

describe AgencyEmployeesController do
  context "Billing Admin should be able to" do
    before(:each) do
      @bill_agency = Factory(:valid_agency)
      @agency_user = @bill_agency.user
      @request.env['devise.mapping'] = :valid_agency
      @agency_user.confirm!
      sign_in @agency_user
      
    end

    it "new agency employee and its associated user should be created with a post request" do
      post :create, :agency_employee => {:city => "pune", :address => "baner", :name => "testemployee", :zip => "22111", :employee_number => "1", :phone => "23455551", :state => "AK",
                    :user_attributes => {:email => "employee@employee.com"}}
      emp = AgencyEmployee.find_by_name("testemployee")
      emp.should_not == nil
      emp.user.should_not == nil
    end

    it "update new employee details with a post request" do
      emp = Factory.create(:agency_employee)
      emp_user = emp.user
      request.env["HTTP_REFERER"] = "http://test.host/agency/employees"
      post :update, :id => emp.id, 
                    :agency_employee =>{:name => "updated_name", 
                    :user_attributes =>{:id => emp_user.id}}
      emp = AgencyEmployee.find_by_name("updated_name")
      emp.should_not == nil
    end

    it "disable agency employee" do
      emp = Factory.create(:agency_employee)
      post :destroy, :id => emp.id
      loc_emp = AgencyEmployee.find(emp.id)
      loc_emp.user.locked_at.should_not == nil
    end
    
    it "enable agency employee if it is initially disabled" do
      emp = Factory.create(:agency_employee)
      emp.user.confirm!
      emp.user.lock_access!
      emp.user.locked_at.should_not == nil
      post :destroy, :id => emp.id
      loc_emp = AgencyEmployee.find(emp.id)
      loc_emp.user.locked_at.should == nil
    end
  end

  context "Agency employee should be able to" do
    before(:each) do
      @agency_emp = Factory(:agency_employee)
      @agency_emp_user = @agency_emp.user
      @request.env['devise.mapping'] = :agency_employee
      @agency_emp_user.confirm!
      sign_in @agency_emp_user
 #   request.env["HTTP_REFERER"] = REQUEST_SOURCE
    end
    it "update his profile" do
      post :update, :id => @agency_emp.id, 
                    :agency_employee =>{:name => "updated_name", 
                    :user_attributes =>{:id => @agency_emp_user.id}}
      emp = AgencyEmployee.find_by_name("updated_name")
      emp.should_not == nil
      emp.user.should_not == nil
    end
  end

  context "Agency employee should not be able to" do
    before(:each) do
      @agency_emp = Factory(:agency_employee)
      @agency_emp_user = @agency_emp.user
      @request.env['devise.mapping'] = :agency_employee
      @agency_emp_user.confirm!
      sign_in @agency_emp_user
    end

    it "create employees" do
      post :create, :agency_employee => {:city => "pune", :address => "baner", :name => "testemployee", :zip => "22111", :employee_number => "1", :phone => "23455551", :state => "AK",
        :user_attributes => {:email => "employee@employee.com"}}
      emp = AgencyEmployee.find_by_name("testemployee")
      emp.should == nil
    end
  end
end
