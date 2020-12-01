class GuessBlueprint < Blueprinter::Base
  field :term
  field :correct

  association :category, blueprint: CategoryBlueprint
end




