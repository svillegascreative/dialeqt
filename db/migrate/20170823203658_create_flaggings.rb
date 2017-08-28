class CreateFlaggings < ActiveRecord::Migration[5.0]
  def change
    create_table :flaggings do |t|
      t.string :flaggable_type
      t.integer :flaggable_id
      t.string :flagger_type
      t.integer :flagger_id
      t.string :reason
      t.text :comment

      t.timestamps
    end
  end
end
