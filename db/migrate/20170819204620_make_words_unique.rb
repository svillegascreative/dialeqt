class MakeWordsUnique < ActiveRecord::Migration[5.0]
  def change
    change_column :words, :name, :string, unique: true
  end
end
