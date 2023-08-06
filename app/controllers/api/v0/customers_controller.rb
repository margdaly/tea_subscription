class Api::V0::CustomersController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, with: :render_error_response

  def show
    customer = Customer.find(params[:id])
    render json: CustomerSerializer.new(customer), status: 200
  end

  private

  def render_error_response(exception)
    render json: ErrorSerializer.serialize(exception, 404), status: 404
  end
end