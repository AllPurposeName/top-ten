class GuessesController < ApplicationController
  def index
    guesses   = Guess.all
    blueprint = GuessBlueprint.render(guesses)
    render json: blueprint
  end

  def create
    guess     = GuessService.guess!(strong_params)
    blueprint = GuessWrapperBlueprint.render(
      guess[:wrapper],
      guess: guess[:guess],
      results: guess[:results]
    )
    render json: blueprint
  rescue ErrorService::BasicError => error
    render json: ErrorBlueprint.render(error) # add http status code error.http_status_code
  end

  def strong_params
    params.permit(:category, :term)
  end
end
