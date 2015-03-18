require 'spec_helper'
describe Order do
  before(:each) do
    @order = Factory.build(:valid_credit_card)
  end

  it "should  be valid with valid_credit_card factory" do
    @order.should be_valid
  end

  it "should be invalid  with invalid_order factory" do
    Factory.build(:invalid_credit_card).should be_invalid
  end

  it "should be valid  with visa card and 16 digit card number" do
    @order.card_type = 'visa'
    @order.card_number = '4242424242424242'
    @order.should be_valid
  end

 it "should be invalid  with visa card and other than 16 digit card number" do
    @order.card_type = 'visa'
    @order.card_number = '424242424242424'
    @order.should be_invalid
  end

it "should be valid  with american_express card and  15 digit card number" do
    @order.card_type = 'american_express'
    @order.card_number = '370000000000002'
    @order.should be_valid
  end



end