class Quote < ActiveRecord::Base

  belongs_to :user
  
  acts_as_taggable
  acts_as_voteable
  
  named_scope :public, :conditions => "(private is NULL) OR (private = 'F') OR (private = 0)"
  named_scope :recent, lambda { |*args| {:conditions => ["created_at > ?", (args.first || 2.weeks.ago).to_s(:db)]} }
  named_scope :descending, :order => "created_at DESC"
  
  attr_accessible :quote, :quote_context, :author, :quoted_at, :quoted_by, :private, :author_title, :copyright 

  cattr_reader :per_page
  @@per_page = 5

end
