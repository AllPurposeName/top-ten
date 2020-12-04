class GuessWrapperBlueprint < Blueprinter::Base
  field :winner, if: -> (_winner, _guess_wrapper, options) { options[:victory] } do
    'YOU DID IT, WINNER WINNER CHICKEN DINNER!!!1!'
  end

  field :guess_count
  field :correct_count
  field :correct_remaining
  field :correctly_guessed

  association :guess, blueprint: GuessBlueprint do |_guess_wrapper, options|
    options[:guess]
  end
end

