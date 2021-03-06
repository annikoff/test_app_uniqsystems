class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.text       :body, null: false
      t.belongs_to :user, null: true
      t.belongs_to :post, null: false
      t.boolean    :is_accepted, defalut: false, null: false
      t.timestamps
    end
  end
end
