class Hall < ActiveRecord::Base
  include HallRepository
  
  attr_accessible :title
  
  validates :title, presence: true

  has_many :events, class_name: :BaseEvent
end