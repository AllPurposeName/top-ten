class AnswersController < ApplicationController
  def show
    ensure_request_decoded
    answer    = Answer.find_by(id: params[:id])
    blueprint = AnswerBlueprint.render(answer)
    render json: blueprint
  end

  def index
    ensure_request_decoded
    answers   = Answer.in_category(filtered_category).order(:category_id).order(:ranking)
    blueprint = AnswerBlueprint.render(answers)
    render json: blueprint
  end

  def filtered_category
    Category.find_by(name: strong_params[:category])
  end

  def strong_params
    params.permit(:category)
  end
end
