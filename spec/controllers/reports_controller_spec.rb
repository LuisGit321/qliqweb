require 'spec_helper'

describe ReportsController, "Physician" do

  before(:each) do
    @physician  = Factory.create(:physician_functional)
    @user = @physician.user
    @user.confirm!
    @start_date = Date.today.strftime('%Y/%m/%d')
    @end_date = Date.today.strftime('%Y/%m/%d')
  end

  context "should not be able" do
    it "generate report without login" do
      post :create, :report => {"start_date" => @start_date, 
                                "end_date" => @end_date, 
                                "physician_id" => @physician.id},
                    :commit_id => "html"
      response.should_not be_success
      response.should redirect_to('http://test.host/')
      flash[:error].should == 'Please login to continue'
    end
  end

  context "should be able to" do
    before(:each) do
      @patient = @physician.patients.first
      @superbill = @physician.superbills.first
      @superbill_cpt = @superbill.superbill_cpts.first
      @encounter = Factory.create(:encounter, :physician_id => @physician.id, :patient_id => @patient.id)
      @encounter_cpt = Factory.create(:encounter_cpt, :encounter_id=>@encounter.id, :superbill_cpt_id=>@superbill_cpt.id)
      @encounter_icd = Factory.create(:encounter_icd, :encounter_id=>@encounter.id, :icd_id=>Icd.last.id, :primary_diagnosis=>1)
      sign_in @user
    end

    it "generate report after login for a patient" do
      post :create, :report => {"start_date" => @start_date, 
                                "end_date" => @end_date, 
                                "physician_id" => @physician.id},
                    :commit_id => "html"
      @hash = @controller.get_hash(DateTime.now.to_date, DateTime.now.to_date)
      icd =  @hash[@patient.id][DateTime.now.to_date.strftime('%Y/%m/%d')][Icd.last.id]
      cpt = @hash[@patient.id][DateTime.now.to_date.strftime('%Y/%m/%d')][Cpt.last.id]
      icd[:code].should == @encounter_icd.icd.code
      icd[:description].should == @encounter_icd.icd.description
      cpt[:code].should ==  @encounter_cpt.superbill_cpt.cpt.code 
      cpt[:description].should == @encounter_cpt.superbill_cpt.cpt.description 
    end
  end
end
