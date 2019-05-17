class ReviewsController < ApplicationController
  def create
    # cocktais/:cocktail_id/reviews/
    @cocktail = Cocktail.find(params[:cocktail_id])
    @review = Review.new(review_params)
    @review.cocktail = @cocktail
    @review.save!
    redirect_to cocktail_path(@cocktail)
  end

  private

  def review_params
    params.require(:review).permit(:content, :rating)
  end
end
