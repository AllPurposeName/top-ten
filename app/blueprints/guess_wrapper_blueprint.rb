class GuessWrapperBlueprint < Blueprinter::Base
  field :guess_count
  field :correct_count
  field :correct_remaining
  field :correctly_guessed

  association :guess, blueprint: GuessBlueprint do |_guess_wrapper, options|
    options[:guess]
  end
end

