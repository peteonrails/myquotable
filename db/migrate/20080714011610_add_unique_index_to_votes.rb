class AddUniqueIndexToVotes < ActiveRecord::Migration
  def self.up
    add_index :votes, ["voteable_id", "voteable_type", "voter_id", "voter_type"], :name => "uniq_voter_voteable", :unique => true
  end

  def self.down
    remove_index :votes, :name => "uniq_voter_voteable"
  end
end
