class CreateUserAnswers < ActiveRecord::Migration[6.0]
  def change
    create_join_table :users, :answers do |t|
      t.index :user_id
      t.index :answer_id
    end
  end
end
