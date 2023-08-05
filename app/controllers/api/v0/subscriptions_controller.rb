class Api::V0::SubscriptionsController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid, with: :render_error_response
  rescue_from ActiveRecord::RecordNotFound, with: :render_error_response

  def create
    subscription = Subscription.create!(subscription_params)
    render json: SubscriptionSerializer.new(subscription), status: 201
  end

  private

  def subscription_params
    params.permit(:customer_id, :tea_id, :frequency)
  end

  def render_error_response(exception)
    render json: ErrorSerializer.serialize(exception, 404), status: 404
  end
end