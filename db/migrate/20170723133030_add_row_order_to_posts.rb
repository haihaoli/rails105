class AddRowOrderToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :row_order, :integer

    Post.find_each do |post|
      post.update(:row_order_position => :last)
    end

    add_index :posts, :row_order

  end
end
