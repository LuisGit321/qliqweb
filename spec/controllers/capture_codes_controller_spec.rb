require 'spec_helper'

module CaptureCodeHelper
  def get_capture_code
    @physician = Factory.create(:physician_functional)
    @user = @physician.user
    @patient = @physician.patients.last
    @superbill = @physician.superbills.last
    @superbill_cpt = @superbill.superbill_cpts.last
    @superbill_icd = @superbill_cpt.superbill_icds.last
    @icd = @superbill_icd.icd
    @user.confirm!
    sign_in @user
  end
end

describe CaptureCodesController, "Physician" do

  include CaptureCodeHelper 

  before(:each) do
    get_capture_code
    @dos = Date.today
  end

  after(:each) do
    patient = Patient.find(@patient)
    patient_encounter = patient.encounters.last
    patient_encounter.patient_id.should == @patient.id
    patient_encounter.date_of_service.should == @dos
    patient_encounter.physician_id.should == @physician.id
    encounter_cpt = patient.encounters.last.encounter_cpts.last
    encounter_cpt.superbill_cpt_id.should == @superbill_cpt.id
  end

  context "should be able to create" do
    it "capture code (both cpts & icds) for a patient" do
      post :create,
           :icd_id_0 => @icd.description,
           :encounter => {:patient_id => @patient.id,
                          :physician_id => @physician.id,
                          :date_of_service => @dos,
                          :encounter_icds_attributes => {"0"=>{"primary_diagnosis"=>"1", "icd_id"=>"#{@icd.id}"}},
                          :encounter_cpts_attributes =>{"#{@superbill_cpt.id}"=>{"superbill_cpt_id"=>"#{@superbill_cpt.id}"}}
                         }     
    end

    it "capture code with cpts for a patient" do
      dos = Date.today
      post :create,
           :encounter => {:patient_id => @patient.id,
                          :physician_id => @physician.id,
                          :date_of_service => @dos,
                          :encounter_cpts_attributes =>{"#{@superbill_cpt.id}"=>{"superbill_cpt_id"=>"#{@superbill_cpt.id}"}}
                         }
    end
  end
end

describe CaptureCodesController, "Physician" do

  include CaptureCodeHelper 

  before(:each) do
    get_capture_code
    @dos = Date.today
    post :create,
           :icd_id_0 => @icd.description,
           :encounter => {:patient_id => @patient.id,
                          :physician_id => @physician.id,
                          :date_of_service => @dos,
                          :encounter_icds_attributes => {"0"=>{"primary_diagnosis"=>"1", "icd_id"=>"#{@icd.id}"}},
                          :encounter_cpts_attributes =>{"#{@superbill_cpt.id}"=>{"superbill_cpt_id"=>"#{@superbill_cpt.id}"}}
                         }
  end

  context "should be able to update" do
    it "cpts for a patient" do
      @superbill_cpt1 = Factory.create(:superbill_cpts, :superbill_id => @superbill.id)
      patient = Patient.find(@patient)
      patient_encounter = patient.encounters.last
      put :update,
          :id => patient_encounter.id,
          :encounter => {:patient_id => @patient.id,
                          :physician_id => @physician.id,
                          :date_of_service => @dos,
                          :encounter_icds_attributes => {"0"=>{"primary_diagnosis"=>"1", "icd_id"=>"#{@icd.id}"}},
                          :encounter_cpts_attributes =>{"#{@superbill_cpt1.id}"=>{"superbill_cpt_id"=>"#{@superbill_cpt1.id}"}}
                         }
      patient = Patient.find(@patient)
      encounter_cpt = patient.encounters.last.encounter_cpts.last
      encounter_cpt.superbill_cpt_id.should == @superbill_cpt1.id
    end
    it "icds for a patient" do
      superbill_icd1 = Factory.create(:superbill_icds, :icd_id => Icd.first.id, :superbill_cpt_id => @superbill_cpt.id)
      @icd1 = superbill_icd1.icd
      patient = Patient.find(@patient)
      patient_encounter = patient.encounters.last
      put :update,
           :id => patient_encounter.id,
           :icd_id_0 => @icd1.description,
           :encounter => {:patient_id => @patient.id,
                          :physician_id => @physician.id,
                          :date_of_service => @dos,
                          :encounter_icds_attributes => {"0"=>{"primary_diagnosis"=>"1", "icd_id"=>"#{@icd1.id}"}},
                          :encounter_cpts_attributes =>{"#{@superbill_cpt.id}"=>{"superbill_cpt_id"=>"#{@superbill_cpt.id}"}}
                         }     
      patient = Patient.find(@patient)
      icd = patient.encounters.last.encounter_cpts.last.superbill_cpt.superbill_icds.last.icd
      icd.description.should == @icd1.description
    end
  end
end
