module LectureRepository
  extend ActiveSupport::Concern

  include UsefullScopes

  included do
    scope :new_and_in_voting, -> { where(state: [:new, :voted]) }
    scope :new_lectures, -> { where(state: :new) }
    scope :web, ->{ by_created_at.scheduled }
    scope :admin, ->{ where(state: [:new, :voted, :in_schedule]) }
    scope :scheduled, -> { where(state: :in_schedule) }
    scope :without_votings_events, -> { where(state: [:in_schedule, :rejected]) }
    scope :voted, -> { where(state: :voted) }
    scope :voted_or_scheduled, -> {where(state: [:voted, :in_schedule])}
    scope :by_lecture_votes, -> { by_lecture_votings_count }
    scope :by_listener_votes, -> { by_listener_votings_count }
    scope :with_active_speaker, -> { joins(:user).where(users: { state: :active, attending_conference_state: :attended}) }
    scope :without_speaker, -> {where(user_id: nil)}
  end
end
