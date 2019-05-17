class Review < ApplicationRecord
  belongs_to :cocktail
  validates :content, presence: true, allow_blank: false
  validates :rating, presence: true, allow_blank: false,
                     numericality: { only_integer: true },
                     inclusion: { in: [*0..5] }
end
