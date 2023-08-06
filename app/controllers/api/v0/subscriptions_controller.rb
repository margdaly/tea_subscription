class Api::V0::SubscriptionsController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid, with: :render_error_response
  rescue_from ActiveRecord::RecordNotFound, with: :render_error_response

  def create
    subscription = Subscription.create!(create_params)
    render json: SubscriptionSerializer.new(subscription), status: 201
  end

  def update
    # require 'pry'; binding.pry
    subscription = Subscription.find_by!(update_params)
    subscription.update!(status: false)
    render json: SubscriptionSerializer.new(subscription), status: 200
  end

  private

  def create_params
    params.permit(:customer_id, :tea_id, :frequency)
  end

  def update_params
    params.permit(:customer_id, :tea_id)
  end

  def render_error_response(exception)
    render json: ErrorSerializer.serialize(exception, 404), status: 404
  end
end