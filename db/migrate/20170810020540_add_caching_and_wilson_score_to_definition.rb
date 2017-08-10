class AddCachingAndWilsonScoreToDefinition < ActiveRecord::Migration[5.0]
  def change
    add_column :definitions, :cached_votes_total, :integer, :default => 0
    add_column :definitions, :cached_votes_score, :integer, :default => 0
    add_column :definitions, :cached_votes_up, :integer, :default => 0
    add_column :definitions, :cached_votes_down, :integer, :default => 0
    add_index  :definitions, :cached_votes_total
    add_index  :definitions, :cached_votes_score
    add_index  :definitions, :cached_votes_up
    add_index  :definitions, :cached_votes_down

    add_column :definitions, :wilson_score, :decimal
  end
end
