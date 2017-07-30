require 'rails_helper'

RSpec.describe Fare, type: :model do
  before do
    @fare = Fare.new(currency: 'EUR', price: 1.00, container_type: :twenty_feet,
                     destination: 'Marseille', source: 'Paris',
                     valid_from: Date.today - 1, valid_to: Date.today)
  end
  it 'is valid with all the correct field values' do
    expect(@fare).to be_valid
  end

  context 'price' do
    it 'cant be negative' do
      @fare.price = -1
      expect(@fare).not_to be_valid
    end
    it 'can be zero' do
      @fare.price = 0
      expect(@fare).to be_valid
    end
    it 'cant be nil' do
      @fare.price = nil
      expect(@fare).not_to be_valid
    end
    it 'cant have more than 2 decimal digits' do
      @fare.price = 'abc'
      expect(@fare).not_to be_valid
    end
    it 'is valid with two decimal digits' do
      @fare.price = 13.37
      expect(@fare).to be_valid
    end
    it 'can have one decimal digit' do
      @fare.price = 3.1
      expect(@fare).to be_valid
    end
    it 'cant be a string' do
      @fare.price = 'blabla'
      expect(@fare).not_to be_valid
    end
  end

  context 'currency' do
    it 'can be USD' do
      @fare.currency = 'EUR'
      expect(@fare).to be_valid
    end
    it 'cant be other' do
      @fare.currency = 'PLN'
      expect(@fare).not_to be_valid
    end
    it 'cant be empty' do
      @fare.currency = nil
      expect(@fare).not_to be_valid
    end
  end

  context 'dates' do
    it 'valid_from cant be after valid_to' do
      @fare.valid_from = @fare.valid_to + 1
      expect(@fare).not_to be_valid
    end
    describe 'valid_from' do
      it 'cant be nil' do
        @fare.valid_from = nil
        expect(@fare).not_to be_valid
      end
    end
  end

  context 'container_type' do
    it 'can be twenty_feet' do
      @fare.container_type = :twenty_feet
      expect(@fare).to be_valid
    end
    it 'can be forty_feet' do
      @fare.container_type = :forty_feet
      expect(@fare).to be_valid
    end
    it 'cant be any other value' do
      expect{ @fare.container_type = :sixty_feet }.to raise_error ArgumentError
    end
    it 'cant be nil' do
      @fare.container_type = nil
      expect(@fare).not_to be_valid
    end
  end
end
