require 'spec_helper'

describe SearchesController do

  context "JSON requests" do

    describe "POST 'npi'" do

      before do
        post :npi, :npi => '1234567890', :format => :json
      end

      it { should respond_with( :success ) }
      it { should assign_to( :result ).with_kind_of( Hash ) }
      it "should render a valid JSON object" do
        data = ActiveSupport::JSON.decode response.body
        data.should be_kind_of Hash
      end

    end

  end

end
