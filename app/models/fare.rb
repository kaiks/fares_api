class Fare < ApplicationRecord
  CURRENCIES = %w(USD EUR)
  enum container_type: [:twenty_feet, :forty_feet]
  validates :currency, inclusion: { in: CURRENCIES }
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validate :valid_to_cannot_be_greater_than_valid_from,
           :no_price_information_lost?
  validates_presence_of :valid_from, :container_type, :source, :destination

  scope :page, ->(page_number) { offset(PAGE_SIZE * page_number) }

  scope :price_from, ->(price_value) { where('price >= ?', price_value.to_f) }
  scope :price_to, ->(price_value) { where('price <= ?', price_value.to_f) }

  def self.by_period(date_from, date_to)
    date_to = Date.parse(date_to) rescue MAX_DATE_STRING
    date_from = Date.parse(date_from) rescue MIN_DATE_STRING
    where('(valid_from, valid_to) OVERLAPS (?, ?)', date_from, date_to)
  end

  private

  def valid_to_cannot_be_greater_than_valid_from
    if valid_to.present? && valid_from.present? && valid_to < valid_from
      errors.add(:valid_to, "can't be before valid_from")
    end
  end


  # ensures 12.434 values are not accepted.
  # Format validator doesn't work with BigDecimal
  def no_price_information_lost?
    return true unless price_changed?
    begin
      return true if BigDecimal(price_before_type_cast, 8) == price
    rescue ArgumentError, TypeError
    end
    errors.add(:price, 'invalid format')
  end
end
