require 'spec_helper'

describe Admin::HomeController do
  context "Super Admin should be able to reset the password" do
    before(:each) do
      @user = Factory.create(:super_user)
      @request.env['devise.mapping'] = :super_user
      @user.confirm!
      sign_in @user
    end
    it "of billing agency user" do
      ba = Factory(:valid_agency)
      ba_user = ba.user
      post :reset_password, :id => ba_user.id,
                            :user => {:password => "test123", :password_confirmation => "test123"},
                            :format => 'JS'
      #response.should be_success
      flash[:notice].should == 'Password is successfully changed.'
    end
  end
end
