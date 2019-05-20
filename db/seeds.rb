# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Review.destroy_all
Cocktail.destroy_all
Dose.destroy_all
Ingredient.destroy_all

require 'open-uri'
require 'json'
require 'nokogiri'
require 'faker'
=begin

response = open('https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list').read

doc = JSON.parse(response)
doc['drinks'].map { |drink| drink['strIngredient1'] }.each do |name|
  Ingredient.create!(name: name)
end

Cocktail.create!(name: "Mojito")
Cocktail.create!(name: "White Russia")
Cocktail.create!(name: "Salty Dog")

Dose.create!(cocktail_id: 1, description: "6 cl", ingredient_id: 2)
Dose.create!(cocktail_id: 1, description: "2 cl", ingredient_id: 9)
Dose.create!(cocktail_id: 1, description: "4 cl", ingredient_id: 3)

=end
base_url = 'https://www.thecocktaildb.com/browse.php?s='

response = open('https://raw.githubusercontent.com/maltyeva/iba-cocktails/master/recipes.json').read
cocktails = JSON.parse(response)
cocktails.each_with_index do |cocktail, cocktail_index|
  cocktail_db = Cocktail.new(name: cocktail['name'], preparation: cocktail['preparation'])
  doc = Nokogiri::HTML(open("#{base_url}#{cocktail['name'].downcase.tr(' ', '+')}").read)
  cocktail_db.image_url = doc.search('.col-sm-3 a img').first.attribute('src').value unless doc.search('.col-sm-3 a img').empty?
  cocktail_db.save

  [*3..5].sample.times do
    content = Faker::Lorem.paragraph_by_chars([*56..256].sample, false)
    content += Faker::SlackEmoji.people
    review = Review.new(content: content, rating: [*1..5].sample)
    review.cocktail = cocktail_db
    review.save
  end

  cocktail['ingredients'].each_with_index do |dose, dose_index|
    if dose.key?('ingredient')
      ingredient_db = Ingredient.new(name: dose['ingredient'])
      ingredient_db.save
      ingredient_db = Ingredient.find_by(name: dose['ingredient']) unless ingredient_db.save
      dose = Dose.new(description: "#{dose['amount']} #{dose['unit']} of #{dose['label'] || dose['ingredient']}")
      dose.cocktail = cocktail_db
      dose.ingredient = ingredient_db
      p dose
      dose.save
    elsif dose.key?('special')
      special_ingredient = Ingredient.new(name: "Special_#{cocktail_index + 1}_#{dose_index + 1}")
      special_ingredient.save(validate: false)
      dose = Dose.new(description: dose['special'])
      dose.cocktail = cocktail_db
      dose.ingredient = Ingredient.find_by(name: "Special_#{cocktail_index + 1}_#{dose_index + 1}")
      p dose
      dose.save
    end
  end
end
