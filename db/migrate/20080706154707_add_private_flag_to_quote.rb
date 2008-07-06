class AddPrivateFlagToQuote < ActiveRecord::Migration
  def self.up
    add_column(:quotes, :private, :boolean)
  end

  def self.down
    remove_column (:quotes, :private)
  end
end
