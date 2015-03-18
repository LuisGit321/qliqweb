require 'spec_helper'
describe PhysicianGroup do

  before(:each) do
    @physician_group = Factory.build(:valid_prospective_physician_group)
  end

  # - Validations -
  it { should validate_presence_of :name            }
  it { should validate_presence_of :address         }
  it { should validate_presence_of :city            }
  it { should validate_presence_of :state           }
  it { should validate_presence_of :zip             }
  it { should validate_presence_of :phone           }
  it { should validate_presence_of :admin_email     }
  it { should validate_presence_of :admin_password  }
  it { should validate_numericality_of :providers   }
  it {
    should validate_format_of( :zip ).
    not_with( 'abcd' ).
    with_message( /Invalid/ )
  }
  it { should validate_format_of( :zip ).with( '12345' )      }
  it { should validate_format_of( :zip ).with( '1234-5678' )  }
  it {
    should validate_format_of( :phone ).
    not_with( '1234567896317' ).
    with_message( /Invalid phone/ )
  }
  it { should validate_format_of( :phone ).with( '555-745-0498' )   }
  it {
    should validate_format_of( :fax ).
    not_with( '1234567896317' ).
    with_message( /Invalid fax/ )
  }
  it { should validate_format_of( :fax ).with( '555-745-0498' )     }
  it "should be invalid with alphanumeric providers " do
    @physician_group.providers = 'as4'
    @physician_group.should_not be_valid
  end
  it "should be invalid with float providers " do
    @physician_group.providers = 5.1
    @physician_group.should_not be_valid
  end

  # - Relationships -
  it { should have_many :billing_batches                                }
  it { should have_many :physicians                                     }
  it { should have_many :billing_prefs                                  }
  it { should have_many( :billing_agencies ).through( :billing_prefs )  }
  it { should have_many( :referral_physicians ).through( :physicians )  }
  it { should have_many( :group_facilities ).through( :physicians )     }
  it { should have_one( :billing_agency ).through( :billing_pref )      }
  it { should have_one :billing_info                                    }
  it { should have_one :line_item                                       }
  it { should have_one :user                                            }
  it { should belong_to :print                                          }



end
