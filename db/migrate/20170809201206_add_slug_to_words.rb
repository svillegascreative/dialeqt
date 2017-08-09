class AddSlugToWords < ActiveRecord::Migration[5.0]
  def change
    add_column :words, :slug, :string, nil: false
    add_index :words, :slug, unique: true
  end
end
