require 'spec_helper'

describe Token do
  it "should swap two tokens" do
    @token_1 = stub_model(Token, :turn_order => 1)
    @token_2 = stub_model(Token, :turn_order => 2)

    @token_1.swap_with(@token_2)

    @token_1.turn_order.should be 2
    @token_2.turn_order.should be 1
  end
end