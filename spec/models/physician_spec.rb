require 'spec_helper'

describe Physician do
  before(:each) do
    @physician = Factory.build(:physician_functional)    
  end

  context "should not be created if " do
    it "name is blank" do
      @physician.name = ''
      @physician.should_not be_valid
    end

    it "user email is blank" do
      @physician.save
      @user = @physician.user 
      @physician.user.email = ''
      @physician.should_not be_blank
    end

    it "preferred super bill is nil" do
      @physician.save
      @physician_superbill = @physician.physician_superbills.first
      @physician_superbill.preferred = nil
      @physician_superbill.save
      @phy = @physician_superbill.physician
      @phy.should_not be_valid
    end
  end
end
