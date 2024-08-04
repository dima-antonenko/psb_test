class CreateCourses < ActiveRecord::Migration[7.1]
  def change
    create_table :courses do |t|
      t.string :title, index: true
      t.string :description, index: true

      t.integer :user_id, index: true
      t.integer :expertise_ids,    index: true, null: false, array: true, default: []
      t.integer :liked_user_ids,    index: true, null: false, array: true, default: []
      t.integer :disliked_user_ids, index: true, null: false, array: true, default: []

      t.integer :total_views, index: false, null: false, default: 1
      t.integer :reviews_count, index: false, null: false, default: 0
      t.integer :appeals_count, index: false, null: false, default: 0

      t.boolean :deleted, index: true, null: false, default: false
      t.timestamps
    end
  end
end
