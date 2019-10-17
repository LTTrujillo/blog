# class CreateComments < ActiveRecord::Migration
#   def change
#     create_table :comments do |t|
#       t.string :commenter
#       t.text :body
#       t.references :post, index: true, foreign_key: true

#       t.timestamps null: false
#     end
#   end
# end

class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :commenter
      t.text :body
      t.references :post
 
      t.timestamps
    end
 
    add_index :comments, :post_id
  end
end
