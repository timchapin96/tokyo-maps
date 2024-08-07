class Ward < ApplicationRecord
  validates :name, presence: true, uniqueness: true, format: {with: /\A[a-zA-Z]+\z/, message: "Can only contain letters"}
  validates :name, length: {in: 2...11}

  # validates :summary, presence: true, allow_blank: false, length: {maximum: 500}
  # validate :is_string?

  validates :one_ldk_avg_rent, presence: true, numericality: { only_integer: true, greater_than: 0}
  validates :two_ldk_avg_rent, presence: true, numericality: { only_integer: true, greater_than: 0}
  validates :three_ldk_avg_rent, presence: true, numericality: { only_integer: true, greater_than: 0}

  validates :safety_rating, presence: true, allow_blank: false, numericality: { greater_than_or_equal_to: 0.0, less_than_or_equal_to: 1.0}

  # validates :population, presence: true, numericality: { only_integer: true, less_than_or_equal_to: 50000000, greater_than: 0}

  validates :pet_percentage, presence: true, numericality: { greater_than_or_equal_to: 0.0, less_than_or_equal_to: 1.0}

  def is_string?
    errors.add(:summary, "must be a string") unless summary.is_a?(String)
    errors.add(:name, "must be a string") unless name.is_a?(String)
  end
end
