class CocktailsController < ApplicationController
  def index
    # cocktails/
    @cocktails = Cocktail.all
    @search = params[:search]
    @name = @search[:name] if @search.present?
    @cocktails = Cocktail.where('name ILIKE ?', "%#{@name}%") if @search.present?
  end

  def show
    # cocktails/:id/
    @cocktail = Cocktail.find(params[:id])
    # show all available doses
    @ingredients = Ingredient.all
    @doses = @cocktail.doses
    @reviews = @cocktail.reviews

    @dose = Dose.new
    @review = Review.new
  end

  def new
    # cocktails/new/
    @cocktail = Cocktail.new
  end

  def create
    # cocktails/
    @cocktail = Cocktail.new(cocktail_params)
    @cocktail.save!
    redirect_to cocktail_path(@cocktail)
  end

  def search
  end

  private

  def cocktail_params
    params.require(:cocktail).permit(:name, :preparation)
  end
end
