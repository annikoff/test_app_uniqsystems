class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.text       :title, null: false
      t.text       :body, null: false
      t.belongs_to :category, null: false
      t.timestamps
    end
  end
end
