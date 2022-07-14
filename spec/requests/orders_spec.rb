# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Orders', type: :request do
  describe 'GET /index' do
    it 'returns http success' do
      get '/orders'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /update' do
    it 'returns http success' do
      order = Order.create!
      patch "/orders/#{order.id}"
      expect(response).to have_http_status(:found)
    end

    it 'order completed' do
      order = Order.create!
      patch "/orders/#{order.id}"
      expect(order.reload.completed).to eq(true)
    end
  end
end
