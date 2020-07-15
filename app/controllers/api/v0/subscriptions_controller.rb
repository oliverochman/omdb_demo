class Api::V0::SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  def create
    payment_status = perform_stripe_payment

    if payment_status == true 
      current_user.update_attribute(:subscriber, true)
      render json: { paid: true, message: "Successfull payment, you are now a subscriber" }
    else 
      binding.pry
    end
  end

  private 

  def perform_stripe_payment
    customer = Stripe::Customer.create(
      email: current_user.email,
      source: params[:stripeToken],
      description: 'Movie Selector'
    )

    charge = Stripe::Charge.create(
      customer: customer.id,
      amount: 29,
      currency: 'sek'
    )

    charge
  end
end
