class ChangeWordName < ActiveRecord::Migration[5.0]
  def change
    rename_column :words, :word, :name
  end
end
