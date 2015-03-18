require 'spec_helper'

REQUEST_SOURCE = "http://test.host/activities"

module PhysicianHelper

  def get_physician
    @physician = Factory.create(:physician_functional)
    @billing_pref = @physician.billing_pref
    @physician_pref = @physician.physician_pref
    @user = @physician.user
    @user.confirm!
    @superbill = @physician.superbills.first
    @physican_superbill = Factory.create(:physician_superbills, :physician_id => @physician.id, :preferred => nil)
  end

end

describe PhysiciansController, "physician:" do

  include PhysicianHelper

  before(:each) do
    get_physician
  end

  it "should be redirect to home page if user editing profile without login" do
    get :edit, :id => @physician.id
    response.should redirect_to("http://test.host/")
  end
end

describe PhysiciansController, "physician:" do

  include PhysicianHelper

  before(:each) do
    get_physician
    sign_in @user
    request.env["HTTP_REFERER"] = REQUEST_SOURCE
    get :edit, :id => @physician.id
    response.should be_success
  end

  after(:each) do
    flash[:notice] = "Physician was successfully updated."
  end

  context "should be able to" do
    it "edit profile" do
      get :edit, :id => @physician.id
      response.should be_success
    end

    context "update" do
      it "name" do
        put :update, 
          :id => @physician.id, 
          :physician => {:name => "physician2"}, 
          :superbill => @superbill.id 
        @phy = Physician.find(@physician)
        @phy.name.should == 'physician2'
      end

      it "npi" do
        put :update, 
          :id => @physician.id, 
          :physician => {:npi => 123456}, 
          :superbill => @superbill.id
        @phy = Physician.find(@physician)
        @phy.npi.should == '123456'
      end

      it "business phone" do
        put :update, 
          :id => @physician.id, 
          :physician => {:phone => '123-123-1234'}, 
          :superbill => @superbill.id
        @phy = Physician.find(@physician)
        @phy.phone.should == '123-123-1234'
      end

      it "fax" do
        put :update, 
          :id => @physician.id, 
          :physician => {:fax => "123-123-1234"}, 
          :superbill => @superbill.id
        @phy = Physician.find(@physician)
        @phy.fax.should == '123-123-1234'
      end

      it "specialty" do
        put :update, 
          :id => @physician.id, 
          :physician => {:specialty=>"Podiatry"},
          :superbill => @superbill.id
        @phy = Physician.find(@physician)
        @phy.specialty.should == "Podiatry"
      end

      it "preferred super bill" do
        superbill = Superbill.find(4)
        put :update, 
            :id => @physician.id, 
            :superbill => superbill.id
        @phy = Physician.find(@physician)
        @phy.superbills.first.name.should == 'Cardiology Template'
      end

      it "superbill2" do
        superbill2 = Superbill.find(4)
        put :update, 
          :id => @physician.id, 
          :superbill2 => superbill2.id
        @phy = Physician.find(@physician)
        @phy.superbills.last.name.should == 'Cardiology Template'
      end

      it "billing agency" do
        billing_pref = BillingPref.last
        put :update, 
          :id => @physician.id, 
          :physician => {:billing_pref_attributes => {:id => billing_pref.id,
                                                      :billing_agency_id => billing_pref.billing_agency_id
                                                     }
                         }
        @phy = Physician.find(@physician)
        @phy.billing_pref.billing_agency.name.should == billing_pref.billing_agency.name
      end

      it "no of billing days" do
        put :update, 
          :superbill => @superbill.id,
          :id => @physician.id,
          :physician => {:physician_pref_attributes => {:number_of_days_to_bill => 20} }
        @physician.reload
        @physician.physician_pref.number_of_days_to_bill.should == 20
      end

      it "fax to primary" do
        put :update, 
          :superbill => @superbill.id,
          :id => @physician.id,
          :physician => {:physician_pref_attributes => {:fax_to_primary => "1"} }
        @physician.reload
        @physician.physician_pref.fax_to_primary.should == 1
      end

      it "subscribe to web" do
        put :update, 
          :id => @physician.id,
          :physician => {:subscribe_to_web => "1"}
        @phy = Physician.find(@physician)
        @phy.subscribe_to_web.should == 1
      end

      it "subscribe to iphone" do
        put :update, 
          :id => @physician.id,
          :physician => {:subscribe_to_iphone => "1"}
        @phy = Physician.find(@physician)
        @phy.subscribe_to_iphone.should == 1
      end
    end
  end
end

describe PhysiciansController, "physician:" do 
  include PhysicianHelper

  before(:each) do
    get_physician
  end

  context "should not be able to update"  do
    it "email address" do
      put :update, 
        :id => @physician.id,
        :physician => {:user_attributes => { :id => @user.id, 
                                             :email => 'physicial_functional@yahoo.com' 
                                          }
                      }
      u = User.find(@user)
      u.email.should == @user.email
    end
  end
end
