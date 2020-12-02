class CategoriesController < ApplicationController

  def show
    blueprint = Rails.cache.fetch(strong_params.to_json, expires_in: 1.hour) do
      category = Category.find_by(strong_params)
      CategoryBlueprint.render(category)
    end
    render json: blueprint, status: 200
  end

  def index
    blueprint = Rails.cache.fetch(Category.maximum(:id), expires_in: 1.hour) do
      categories = Category.all
      CategoryBlueprint.render(categories)
    end
    render json: blueprint, status: 200
  end

  def strong_params
    params.permit(:id, :name)
  end
end
