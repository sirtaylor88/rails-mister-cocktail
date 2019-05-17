class Cocktail < ApplicationRecord
  has_many :doses, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :ingredients, through: :doses
  validates :name, presence: true, uniqueness: true, allow_blank: false
end
