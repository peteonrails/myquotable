class Quote < ActiveRecord::Base
  belongs_to :user
  
  acts_as_taggable
  
  named_scope :public, :conditions => "(private is NULL) OR (private = 'F') OR (private = 0)"
  named_scope :recent, lambda { |*args| {:conditions => ["created_at > ?", (args.first || 2.weeks.ago).to_s(:db)]} }
  named_scope :descending, :order => "created_at DESC"
end
