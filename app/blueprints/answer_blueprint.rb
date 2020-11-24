class AnswerBlueprint < Blueprinter::Base
  identifier :id

  field :term
  field :variants
  field :ranking

  association :category, blueprint: CategoryBlueprint
end

