require 'spec_helper'

describe PatientsController, "Physician" do
  before(:each) do
    @physician = Factory.create(:physician_functional)
    @patient = @physician.patients.first
    @user = @physician.user
    @user.confirm!
    sign_in @user
    get :edit, :id => @patient.id
    response.should be_success
  end

  context "should be able to update patient" do
    it "floor" do
      put :update,
          :id => @patient.id,
          :patient => { :hospital_episodes_attributes => { "0" => { :floor => "25", :id => @patient.id }}},
          :format => 'JS'
      p = Patient.find(@patient)
      p.hospital_episodes.first.floor.should == 25  
    end

    it "room" do
      put :update,
          :id => @patient.id,
          :patient => { :hospital_episodes_attributes => { "0" => { :room => "25", :id => @patient.id }}},
           :format => 'JS'
      p = Patient.find(@patient)
      p.hospital_episodes.first.room.should == 25  
    end

    it "first name" do
      put :update,
          :id => @patient.id,
          :patient => { :first_name => 'firstname1'},
          :format => 'JS'
      p = Patient.find(@patient)
      p.first_name.should == 'firstname1'
    end

    it "middle name" do
      put :update,
          :id => @patient.id,
          :patient => { :middle_name => 'middlename1'},
          :format => 'JS'
      p = Patient.find(@patient)
      p.middle_name.should == 'middlename1'
    end

    it "last name" do
      put :update,
          :id => @patient.id,
          :patient => { :last_name => 'lastname1'},
          :format => 'JS'
      p = Patient.find(@patient)
      p.last_name.should == 'lastname1'
    end

    it "date of birth" do
      date = Date.today - 1.day
      date1 = date.strftime('%Y/%m/%d')
      put :update,
          :id => @patient.id,
          :patient => { :date_of_birth => date1},
          :format => 'JS'
      p = Patient.find(@patient)
      p.date_of_birth.strftime('%Y/%m/%d').should == date1
    end

    it "business phone" do
      put :update,
          :id => @patient.id,
          :patient => { :phone => '123-123-1234'},
          :format => 'JS'
      p = Patient.find(@patient)
      p.phone.should == '123-123-1234'
    end

    it "email" do
      put :update,
          :id => @patient.id,
          :patient => { :email => 'patient1@gmail.com'},
          :format => 'JS'
      p = Patient.find(@patient)
      p.email.should == 'patient1@gmail.com'
    end

    it "insurance" do
      put :update,
          :id => @patient.id,
          :patient => { :insurance => 'Self-pay'},
          :format => 'JS'
      p = Patient.find(@patient)
      p.insurance.should == 'Self-pay'
    end
  end

  context "should not be able to update patient" do
    it "if first name is blank" do
      put :update,
          :id => @patient.id,
          :patient => { :first_name => ''},
          :format => 'JS'
      p = Patient.find(@patient)
      p.first_name.should == @patient.first_name
    end

    it "if last name is blank" do
      put :update,
          :id => @patient.id,
          :patient => { :first_name => ''},
          :format => 'JS'
      p = Patient.find(@patient)
      p.last_name.should == @patient.last_name
    end

    it "if date of birth is blank" do
      put :update,
          :id => @patient.id,
          :patient => { :first_name => ''},
          :format => 'JS'
      p = Patient.find(@patient)
      p.date_of_birth.should == @patient.date_of_birth
    end
  end
end
