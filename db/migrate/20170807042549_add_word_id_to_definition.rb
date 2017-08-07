class AddWordIdToDefinition < ActiveRecord::Migration[5.0]
  def change
    add_column :definitions, :word_id, :integer
  end
end
