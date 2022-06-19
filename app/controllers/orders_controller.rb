# frozen_string_literal: true

class OrdersController < ApplicationController
  def index
    @orders = Order.open
  end

  def update
    order = Order.find(params[:id])
    order.update(completed: true)
    redirect_to action: :index
  end
end
