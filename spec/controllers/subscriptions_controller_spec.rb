require 'spec_helper'

describe SubscriptionsController do

  before :all do
    @states = []
    5.times { @states << Factory( :state ) }
  end

  describe "GET 'new" do

    before do
      get :new
    end

    it { should respond_with( :success ) }
    it { should render_with_layout( :home ) }
    it {
      should assign_to( :subscriber ).
      with_kind_of( ProspectiveSubscriber )
    }
    it {
      should assign_to( :physician_group ).
      with_kind_of( PhysicianGroup )
    }
    it {
      should assign_to( :states ).
      with( @states )
    }

  end

  describe "POST 'create_group'" do

    before do
      @physician_group = Factory( :physician_group )
      post  :create_group, :physician_group => @physician_group.attributes,
            :format => :json
    end

    it { should respond_with( :success ) }
    it { should assign_to( :physician_group ).with_kind_of( PhysicianGroup ) }
    it "should create a new PhysicianGroup record" do
      change( PhysicianGroup, :count ).by( 1 )
    end

  end

end
