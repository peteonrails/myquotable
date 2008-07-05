class CreateQuotes < ActiveRecord::Migration
  def self.up
    create_table :quotes do |t|
      t.text        :quote, :author, :quoted_by, :quote_context, :author_title, :copyright
      t.date        :quoted_at
      t.references  :user, :null => :false
      t.timestamps
    end
  end

  def self.down
    drop_table :quotes
  end
end
