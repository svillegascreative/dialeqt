class AddWilsonScoreDefault < ActiveRecord::Migration[5.0]
  def change
    change_column :words, :wilson_score, :decimal, default: 0.0
    change_column :definitions, :wilson_score, :decimal, default: 0.0
  end
end
