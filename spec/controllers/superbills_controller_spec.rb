require 'spec_helper'

describe SuperbillsController do
    before(:each) do
      @bill_agency = Factory(:valid_agency)
      @agency_user = @bill_agency.user
      @request.env['devise.mapping'] = :valid_agency
      @agency_user.confirm!
      sign_in @agency_user
      @cpt_grp = CptGroup.first
      @cpt = Cpt.first
      @icd = Icd.first
      @tme = Time.now.to_i
    end
  context "Billing Agency should create Superbills if" do
    it "name and speciality is mentioned only and entry should not be entered in cpd and icd" do
      post :create, :superbill =>{:name => "test_superbill", :specialty_id => "1"}
      sb = Superbill.find_by_name("test_superbill")
      sb.should_not == nil
      sb.superbill_cpts.should_not ==nil
      sb.superbill_icds.should_not ==nil
    end

    it "name,speciality and state is mentioned and entry should be displayed in cpd and icd" do
      post :create, :superbill =>{:name => "test_superbill_state", :specialty_id => "1", :state_id => "1"}
      sb1 = Superbill.find_by_name("test_superbill_state")  
      sb1.should_not == nil
      sb1.superbill_cpts.should_not ==nil
      sb1.superbill_icds.should_not ==nil
    end

    it "name,speciality,state and cpd group is mentioned and entry in cpt group should not be entered" do
#      get :add, {:id => @cpt_grp.id, :type => 1}
      post :create, :superbill =>{:name => "test_superbill_state", :specialty_id => "1", :state_id => "1"}
      sb1 = Superbill.find_by_name("test_superbill_state")  
      sb1.should_not == nil
      sb1.superbill_cpts.should == []
      sb1.superbill_icds.should == []
    end

    it "name,speciality,state,cpd group and cpt is mentioned and entry in cpt group should be entered and no entry should be in icd" do
      post :create, :superbill =>{:name => "test_cpt", :specialty_id => "1", :state_id =>"1"},
        :cpt_attributes => {"#{@cpt_grp.id}" => {:cpts =>{"#{@tme}" => { :cpt_id => "#{@cpt.id}"}}}}
      superbill = Superbill.find_by_name("test_cpt")
      superbill.should_not == nil
      superbill.superbill_cpts.should_not == nil
      superbill.superbill_cpts.first.superbill_id.should == superbill.id
      superbill.superbill_cpts.first.cpt_group_id.should == @cpt_grp.id
      superbill.superbill_cpts.first.cpt_id.should == @cpt.id
      superbill.superbill_icds.should == []
    end

    it "name,speciality,state,cpd group,cpt and icd code is mentioned and entry in cpd and icd should be entered" do
      post :create, :superbill =>{:name => "test_cpt_icd", :specialty_id => "1", :state_id =>"1"},
        :cpt_attributes => {"#{@cpt_grp.id}" => {:cpts =>{"#{@tme}"=> {:icds =>{"#{@tme}"=>{:icd_id => "#{@icd.id}"}}, :cpt_id => "#{@cpt.id}"}}}}
      superbill = Superbill.find_by_name("test_cpt_icd")
      superbill.should_not == nil
      superbill.superbill_cpts.should_not == nil
      superbill.superbill_cpts.first.superbill_id.should == superbill.id
      superbill.superbill_cpts.first.cpt_group_id.should == @cpt_grp.id
      superbill.superbill_cpts.first.cpt_id.should == @cpt.id
      superbill.superbill_icds.should_not == nil
      superbill.superbill_icds.first.icd_id.should == @icd.id
      superbill.superbill_icds.first.superbill_cpt_id.should == superbill.superbill_cpts.first.id
    end

    it "different entries of cpd and icd are entered for different cpt groups and entries of those shouold be displayed in cpd and icd" do
      cpt_grp2 = CptGroup.find(2)
      icd2 = Icd.find(2)
      cpt2 = Cpt.find(2)
      post :create, :superbill =>{:name => "test_cpt_2_icd_2", :specialty_id => "1", :state_id =>"1"},
                    :cpt_attributes => {"#{@cpt_grp.id}" => {:cpts =>{"#{@tme}"=> {:icds =>{"#{@tme}"=>{:icd_id => "#{@icd.id}"}}, :cpt_id => "#{@cpt.id}"}}}, 
                    "#{cpt_grp2.id}" =>{:cpts =>{"#{@tme}"=>{:icds => {"#{@tme}"=>{:icd_id =>"#{icd2.id}"}}, :cpt_id => "#{cpt2.id}"}}}}
      superbill = Superbill.find_by_name("test_cpt_2_icd_2")
      superbill.should_not == nil
      superbill.superbill_cpts.should_not == nil
      superbill.superbill_cpts.size.should == 2
      superbill.superbill_icds.should_not == nil
      superbill.superbill_icds.size.should == 2
    end

    it "multiple entries of cpts should be entered for one cptgroup and those entries should get updated in cpt and no entry should be mntioned in icd" do
      cpt2 = Cpt.find(2)
      tme2 = Time.now.to_s
      post :create, :superbill =>{:name => "test_2cpt_grp1", :specialty_id => "1", :state_id =>"1"},
                    :cpt_attributes => {"#{@cpt_grp.id}" => {:cpts =>{"#{@tme}"=> {:cpt_id => "#{@cpt.id}"}, "#{tme2}" => {:cpt_id => "#{cpt2.id}"}}}}
      superbill = Superbill.find_by_name("test_2cpt_grp1")
      superbill.should_not == nil
      superbill.superbill_cpts.should_not == nil
      superbill.superbill_cpts.size.should == 2
      superbill.superbill_icds.should == []
    end

    it "multiple enteries of icd can be mentioned under one cpd and those should be updated in icd and cpd" do
      icd2 = Icd.find(2)
      tme = Time.now.to_s
      post :create, :superbill =>{:name => "test_cpt_icd_2", :specialty_id => "1", :state_id =>"1"},
                    :cpt_attributes => {"#{@cpt_grp.id}" => {:cpts =>{"#{@tme}"=> {:icds =>{"#{@tme}"=>{:icd_id => "#{@icd.id}"},
                    "#{tme}" => {:icd_id => "#{icd2.id}"}}, :cpt_id => "#{@cpt.id}"}}}} 
      superbill = Superbill.find_by_name("test_cpt_icd_2")
      superbill.should_not == nil
      superbill.superbill_cpts.should_not == nil
      superbill.superbill_cpts.size.should == 1
      superbill.superbill_icds.should_not == nil
      superbill.superbill_icds.size.should == 2
    end
  end

  context "Billing Agency user should able to update super bill entries by" do
    it "adding a new cpd and icd and cpd and icd table entries should be entered" do
      super_bill = Factory(:super_bill_name_speciality)
      put :update, :superbill =>{:name => "updated_superbill"},
                    :id => "#{super_bill.id}",
                    :cpt_attributes => {"#{@cpt_grp.id}" => {:cpts =>{"#{@tme}"=> {:icds =>{"#{@tme}"=>{:icd_id => "#{@icd.id}"}}, :cpt_id => "#{@cpt.id}"}}}} 
      super_bill2 = Superbill.find_by_name("updated_superbill")
      super_bill2.id.should == super_bill.id
      super_bill2.superbill_cpts.should_not == nil
      super_bill2.superbill_cpts.size.should == 2 
      super_bill2.superbill_icds.should_not == nil
      super_bill2.superbill_icds.size.should == 2
    end

    it "removing cpd and icd entries and cpd and icd table should get updated" do
      super_bill = Factory(:super_bill_name_speciality)
      put :update, :superbill =>{:name => "updated_superbill"},
                   :id => "#{super_bill.id}",
                   :cpt_attributes => {"#{super_bill.superbill_cpts.first.cpt_group_id}" => {:cpts =>{"#{@tme}"=> {:icds =>{"#{@tme}"=>{:icd_id => "#{super_bill.superbill_icds.first.icd_id}"}}, :_delete => "1", :cpt_id => "#{super_bill.superbill_cpts.first.cpt_id}"}}}} 
      super_bill2 = Superbill.find_by_name("updated_superbill")
      super_bill2.id.should == super_bill.id
      super_bill2.superbill_cpts.should == []
      super_bill2.superbill_icds.should == []
    end
  end

  context "Billing Agency user should not be able to" do
    it "create superbill if cpd enteries are same for the same cpt group and entry in cpt should not be entered" do
      post :create, :superbill =>{:name => "test_2cpt_grp1", :specialty_id => "1", :state_id =>"1"},
                    :cpt_attributes => {"#{@cpt_grp.id}" => {:cpts =>{"#{@tme}" => { :cpt_id => "#{@cpt.id}"}, "#{@tme}" => {:cpt_id => "#{@cpt.id}"}}}}
      superbill = Superbill.find_by_name("test_2cpt_grp1")
      superbill.superbill_cpts.should == []
    end

    it "update superbill if same cpd entry is added for the same cpt group" do
      super_bill = Factory(:super_bill_name_speciality)
      put :update, :superbill =>{:name => "updated_superbill"},
                   :id => "#{super_bill.id}",
                   :cpt_attributes => {"#{super_bill.superbill_cpts.first.cpt_group_id}" => {:cpts =>{"#{@tme}"=> { :cpt_id => "#{super_bill.superbill_cpts.first.cpt_id}"}, "#{@tme}" => {:cpt_id => "#{super_bill.superbill_cpts.first.cpt_id}"}}}} 
      superbill = Superbill.find_by_name("updated_superbill")
      superbill.superbill_cpts.should == []
    end
  end
end

describe SuperbillsController do
  context "Agency employee should be able to" do
    before(:each) do
      @agency_emp = Factory(:agency_employee)
      @agency_emp_user = @agency_emp.user
      @request.env['devise.mapping'] = :agency_employee
      @agency_emp_user.confirm!
      sign_in @agency_emp_user
      @cpt_grp = CptGroup.first
      @cpt = Cpt.first
      @icd = Icd.first
      @tme = Time.now.to_i
    end
    it "create super agency" do
      post :create, :superbill =>{:name => "test_superbill", :specialty_id => "1"}
      sb = Superbill.find_by_name("test_superbill")
      sb.should_not == nil
      sb.superbill_cpts.should_not ==nil
      sb.superbill_icds.should_not ==nil
    end
    
    it "update super agency" do
      super_bill = Factory(:super_bill_name_speciality_agency_emp)
      put :update, :superbill =>{:name => "updated_superbill"},
                    :id => "#{super_bill.id}",
                    :cpt_attributes => {"#{@cpt_grp.id}" => {:cpts =>{"#{@tme}"=> {:icds =>{"#{@tme}"=>{:icd_id => "#{@icd.id}"}}, :cpt_id => "#{@cpt.id}"}}}} 
      super_bill2 = Superbill.find_by_name("updated_superbill")
      super_bill2.id.should == super_bill.id
      super_bill2.superbill_cpts.should_not == nil
      super_bill2.superbill_cpts.size.should == 2 
      super_bill2.superbill_icds.should_not == nil
      super_bill2.superbill_icds.size.should == 2
    end
  end
end
