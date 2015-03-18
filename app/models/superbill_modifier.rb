class SuperbillModifier < ActiveRecord::Base
  belongs_to :superbill
  belongs_to :modifier
end
