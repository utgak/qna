class CreateQuestionsUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :questions_users do |t|
      t.references :question, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
