class CreatePostScores < ActiveRecord::Migration[5.1]
  def change
    create_table :post_scores do |t|
      t.references :post, foreign_key: true
      t.integer :score
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
