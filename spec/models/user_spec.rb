require 'spec_helper'

describe User do
  #this before block is executed before each test
  before(:each) do
    @user = {
      :email => "lorem.m@gmail.com",
      :password => "password",
      :password_confirmation => "password"
    }
  end
  

  it "should have an email address" do
    user = User.new(@user.merge(:email => nil))
    user.should_not be_valid
  end
  

  it "should have a valid email" do
    user = User.new(@user.merge(:email => "lorem.ipsum"))
    user.should_not be_valid
  end
  
  it "should have password" do
    user = User.new(@user.merge(:password => nil))
    user.should_not be_valid
  end

  it "should have a non nil password confirmation" do
    user = User.new(@user.merge({ :password_confirmation => nil, :password => nil}))
    user.should_not be_valid
  end
  
  it "should have a matching password confirmation" do
    user = User.new(@user.merge(:password_confirmation => "nil"))
    user.should_not be_valid
  end
  
  it "should have password with at least 6 characters" do
    user = User.new(@user.merge({ :password_confirmation => '12345', :password => '12345'}))
    user.should_not be_valid
  end

end