class GuessesController < ApplicationController
  def index
    ensure_request_decoded
    guesses   = Guess.all
    blueprint = GuessBlueprint.render(guesses)
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
      results: guess[:results]
    )
    render json: blueprint, status: 201
  rescue ErrorService::BasicError => error
    render json: ErrorBlueprint.render(error), status: error.http_status_code
  end

  def strong_params
    params.permit(:category, :term)
  end
end
