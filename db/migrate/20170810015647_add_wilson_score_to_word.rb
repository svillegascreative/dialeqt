class AddWilsonScoreToWord < ActiveRecord::Migration[5.0]
  def change
    add_column :words, :wilson_score, :decimal
  end
end
