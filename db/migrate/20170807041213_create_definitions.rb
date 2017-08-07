class CreateDefinitions < ActiveRecord::Migration[5.0]
  def change
    create_table :definitions do |t|
      t.string :details
      t.string :example
      t.integer :user_id

      t.timestamps
    end
  end
end
