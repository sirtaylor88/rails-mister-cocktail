class CreateCocktails < ActiveRecord::Migration[5.2]
  def change
    create_table :cocktails do |t|
      t.string :name
      t.string :image_url
      t.text :preparation
      t.timestamps
    end
  end
end
