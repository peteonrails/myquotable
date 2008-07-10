class ActsAsVoteableMigration < ActiveRecord::Migration
  def self.up
    create_table :votes, :force => true do |t|
      t.boolean  :vote,                        :default => false
      t.string   :voteable_type, :limit => 15, :default => "", :null => false
      t.integer  :voteable_id,                 :default => 0,  :null => false
      t.integer  :user_id,        :default => 0,  :null => false
      t.timestamps      
    end

    add_index :votes, ["user_id"], :name => "fk_votes_user"
  end

  def self.down
    drop_table :votes
  end

end
