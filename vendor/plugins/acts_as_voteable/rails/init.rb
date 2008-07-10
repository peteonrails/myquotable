require 'acts_as_voteable'

ActiveRecord::Base.send(:include, Juixe::Acts::Voteable)
RAILS_DEFAULT_LOGGER.info "** acts_as_votable: initialized properly."