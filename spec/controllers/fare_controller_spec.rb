require 'rails_helper'

RSpec.describe FaresController, type: :controller do
  let(:valid_attributes) do
    { 'price' => 1.0, 'currency' => 'EUR', 'container_type' => 'twenty_feet',
      'source' => 'Paris', 'destination' => 'Marseille',
      'valid_from' => '2017-07-28', 'valid_to' => '2017-07-29' }
  end
  let(:invalid_attributes) do
    { 'price' => 2.0 }
  end

  before do
    @fares = []
    20.times do |i|
      @fares.push(Fare.create(valid_attributes.merge(price: i)))
    end
  end

  describe 'GET #index' do
    it 'responds successfully with an HTTP 200 status code' do
      get :index
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'loads first batch of @fares' do
      get :index
      expect(assigns(:fares)).to match_array(@fares.first(PAGE_SIZE))
    end

    it 'loads second batch of @fares when page 2' do
      get :index, params: { page: 2 }
      expect(assigns(:fares)).to match_array(@fares[PAGE_SIZE..2*PAGE_SIZE-1])
    end

    context 'filters' do
      it 'filters min price' do
        get :index, params: { price_from: '12' }
        expect(assigns(:fares).first).to eq @fares[12]
      end
      it 'filters max price' do
        get :index, params: { price_to: '3' }
        expect(assigns(:fares).count).to eq 4
      end
      it 'filters valid_to' do
        get :index, params: { by_period: {to: Date.today-1} }
        expect(assigns(:fares).first).to eq @fares.first
      end
      it 'filters valid_from' do
        byebug
        get :index, params: { by_period: {from: Date.today-1} }
        expect(assigns(:fares).first).to eq nil
      end
    end
  end

  describe 'POST #create' do
    it 'creates fare with all the params' do
      post :create, params: { fare: valid_attributes }
      expect(response).to have_http_status(201)
      expect(Fare.count).to eq 21
    end
  end

  describe 'PUT #update' do
    it 'updates a fare' do
      fare = @fares.first
      put :update, params: { fare: { price: 123.45 }, id: fare.id }
      expect(response).to have_http_status(200)
      fare.reload
      expect(fare.price).to eq 123.45
    end

    it 'doesnt update unpermitted parameters' do
      fare = @fares.first
      before_created_at = fare.created_at
      put :update, params: { fare: { created_at: DateTime.now }, id: fare.id }
      expect(response).to have_http_status(200)
      fare.reload
      expect(fare.created_at).to eq before_created_at
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes a fare' do
      fare = @fares.first
      delete :destroy, params: { id: fare.id }
      expect(response).to have_http_status(204)
      expect(Fare.find_by(id: fare.id)).to eq nil
    end
  end
end
