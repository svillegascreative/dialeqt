class UseTextForDefinitions < ActiveRecord::Migration[5.0]
  def change
    change_column :definitions, :details, :text
    change_column :definitions, :example, :text
  end
end
