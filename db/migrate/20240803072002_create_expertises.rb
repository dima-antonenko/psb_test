class CreateExpertises < ActiveRecord::Migration[7.1]
  def change
    create_table :expertises do |t|
      t.string :title, index: true
      t.boolean :deleted, default: false
      t.timestamps
    end
  end
end
