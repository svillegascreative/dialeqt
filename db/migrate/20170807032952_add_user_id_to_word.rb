class AddUserIdToWord < ActiveRecord::Migration[5.0]
  def change
    add_column :words, :user_id, :integer
  end
end
