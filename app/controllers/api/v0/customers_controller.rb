class Api::V0::CustomersController < ApplicationController

  def show
    customer = Customer.find(params[:id])
    render json: CustomerSerializer.new(customer), status: 200
  end
end