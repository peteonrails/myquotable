class AddNameToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :first_name, :string, :null => false, :default => ""
    add_column :users, :last_name,  :string, :null => false, :default => ""
  end

  def self.down
    remove_column :users, :first_name
    remove_column :users, :last_name
  end
end
