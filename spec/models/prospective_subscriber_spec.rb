require 'spec_helper'

describe ProspectiveSubscriber do

  # - Relationships -
  context 'Relationships' do
    it { have_one :physician_group }
    it { have_one :billing_address }
  end

  # - Validations -
  context 'Validations' do
    it { should validate_presence_of :email }
    it {
      should validate_format_of( :email ).
      not_with( 'thisisnot@anemail' )
    }
    it {
      should validate_format_of( :email ).
      with( 'homer@thesimpsons.com' )
    }
    it {
      should ensure_length_of( :password ).
      is_at_least( 6 ).
      is_at_most( 40 )
    }
  end

end
