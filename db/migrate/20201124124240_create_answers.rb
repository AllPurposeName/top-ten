class CreateAnswers < ActiveRecord::Migration[6.0]
  def change
    create_table :answers do |t|
      t.string :term
      t.integer :ranking
      t.text :variants, array: true, default: []
      t.references :category

      t.timestamps
    end
  end
end
