class CreateGuesses < ActiveRecord::Migration[6.0]
  def change
    create_table :guesses do |t|
      t.string :term
      t.boolean :correct
      t.references :category
      t.references :user
      t.timestamps
    end
  end
end
