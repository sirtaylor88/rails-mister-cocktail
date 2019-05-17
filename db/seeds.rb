# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#Ingredient.destroy_all
#Cocktail.destroy_all
#Dose.destroy_all
require 'open-uri'
require 'json'
require 'nokogiri'
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
cocktails.each do |cocktail|
  cocktail_db = Cocktail.new(name: cocktail['name'], preparation: cocktail['preparation'])
  doc = Nokogiri::HTML(open("#{base_url}#{cocktail['name'].downcase.tr(' ', '+')}").read)
  cocktail_db.image_url = doc.search('.col-sm-3 a img').first.attribute('src').value unless doc.search('.col-sm-3 a img').empty?

  cocktail_db.save
  cocktail['ingredients'].each do |dose|
    ingredient_db = Ingredient.new(name: dose['ingredient'])
    ingredient_db.save
    dose = Dose.new(description: "#{dose['amount']} #{dose['unit']}")
    dose.cocktail = cocktail_db
    dose.ingredient = ingredient_db
    dose.save
  end
end

Review.create!(cocktail_id: 1, content: "Very good", rating: 4)
Review.create!(cocktail_id: 1, content: "Bad", rating: 1)
Review.create!(cocktail_id: 1, content: "Excellent", rating: 5)

