class Movie < ActiveRecord::Base

  def self.possible_ratings
    ['G','PG','PG-13','R']
  end
  
end
