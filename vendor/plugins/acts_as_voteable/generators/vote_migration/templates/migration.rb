class ActsAsVoteableMigration < ActiveRecord::Migration
  def self.up
    create_table :votes, :force => true do |t|
      t.boolean  :vote,                        :default => false
      t.string   :voteable_type, :limit => 15, :default => "", :null => false
      t.integer  :voteable_id,                 :default => 0,  :null => false
      t.integer  :<%= model_name %>_id,        :default => 0,  :null => false
      t.timestamps      
    end

    add_index :votes, ["<%= model_name %>_id"], :name => "fk_votes_<%= model_name %>"
  end

  def self.down
    drop_table :votes
  end

end
