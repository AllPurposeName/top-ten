class GuessesController < ApplicationController
  def index
    ensure_request_decoded
    blueprint = Rails.cache.fetch("guesses?filters[category]=#{strong_params[:category]}", expires: 1.hour) do
      guesses   = Guess.in_category(filtered_category).order(:category_id)
      GuessBlueprint.render(guesses)
    end
    render json: blueprint, status: 200
  end

  def create
    ensure_request_decoded
    guess     = GuessFactory.guess!(
      category: strong_params[:category],
      term: strong_params[:term],
      user: current_user
    )
    blueprint = GuessWrapperBlueprint.render(
      guess[:wrapper],
      guess: guess[:guess],
      results: guess[:results],
      victory: guess[:victory]
    )
    render json: blueprint, status: 201
  rescue ErrorService::BasicError => error
    render json: ErrorBlueprint.render(error), status: error.http_status_code
  end

  def filtered_category
    Category.find_by(name: strong_params[:category])
  end

  def strong_params
    params.permit(:category, :term)
  end
end
