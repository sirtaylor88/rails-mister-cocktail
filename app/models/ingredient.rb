class Ingredient < ApplicationRecord
  before_destroy :check_for_dose?
  has_many :doses
  has_many :cocktails, through: :doses
  validates :name, presence: true, uniqueness: true, allow_blank: false

  def check_for_dose?
    doses.nil?
  end
end
