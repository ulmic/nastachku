require 'carrierwave/orm/activerecord' # for load_models initializer, remove if remove its

class Lecture < ActiveRecord::Base
  include LectureRepository

  attr_accessible :presentation, :thesises, :title, :workshop_id, :user_id,
                  :listener_votings_count, :lecture_votings_count, :type, :state

  validates :title, presence: true
  validates :thesises, presence: true
  belongs_to :workshop
  belongs_to :user

  has_many :listener_votings, as: :voteable, extend: [Extensions::VotingExtension]
  has_many :lecture_votings, as: :voteable, extend: [Extensions::VotingExtension]
  has_many :listeners, through: :listener_votings, source: :user
  has_many :voted, through: :lecture_votings, source: :user
  has_one :slot, as: :event
  has_many :halls, through: :slots

  mount_uploader :presentation, EventPresentationUploader

  audit :title, :thesises, :workshop, :user

  state_machine :state, initial: :new do
    state :new
    state :in_schedule
    state :voted
    state :rejected

    event :move_to_schedule do
      transition [:new, :voted, :rejected] => :in_schedule
    end

    event :move_to_voting do
      transition [:new, :in_schedule, :rejected] => :voted
    end

    event :reject do
      transition [:new, :in_schedule, :voted] => :rejected
    end
  end
end
