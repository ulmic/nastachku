# -*- coding: utf-8 -*-
require 'digest/md5'

class User < ActiveRecord::Base
  include UserRepository
  extend Enumerize

  attr_accessible :email, :password, :first_name, :last_name, :city, :company, :position,
    :show_as_participant, :photo, :state_event, :about, :carousel_info, :in_carousel,
    :lectures_attributes, :twitter_name, :invisible_lector, :timepad_state_event, :attending_conference_state_event, :pay_state_event, :facebook, :vkontakte

  audit :email, :first_name, :last_name, :city, :company, :photo, :state, :about

  validates :email, presence: true, uniqueness: {case_sensitive: false}, email: true
  validates :last_name, presence: true
  validates :first_name, presence: true
  validates_format_of :first_name, with: /^[a-zA-Zа-яА-ЯёЁ][a-zA-Zа-яА-ЯёЁ '`-]{0,253}[a-zA-Zа-яА-ЯёЁ]{0,1}$/
  validates_format_of :last_name, with: /^[a-zA-Zа-яА-ЯёЁ][a-zA-Zа-яА-ЯёЁ '`-]{0,253}[a-zA-Zа-яА-ЯёЁ]{0,1}$/
  validates_format_of :city, with: /^[a-zA-Zа-яА-ЯёЁ0-9 '`-]{0,255}$/
  validates_format_of :company, with: /^[a-zA-Zа-яА-ЯёЁ0-9 '`~\!@#\$\%\^\&\*\(\)_+=\-"\{\}\[\]\/\\|;:,.?<>]{0,255}$/
  validates_format_of :position, with: /^[a-zA-Zа-яА-ЯёЁ0-9 '`~\!@#\$\%\^\&\*\(\)_+=\-"\{\}\[\]\/\\|;:,.?<>]{0,255}$/
  validates :facebook, url: true, allow_blank: true
  validates :vkontakte, url: true, allow_blank: true

  enumerize :role, in: [ :lector, :user ], default: :user
  has_many :lectures, dependent: :destroy
  has_many :lecture_votings
  has_many :listener_votings
  has_many :orders
  has_many :shirt_orders
  has_many :afterparty_orders
  has_many :ticket_orders

  accepts_nested_attributes_for :lectures, reject_if: :all_blank, allow_destroy: true

  mount_uploader :photo, UsersPhotoUploader

  has_many :auth_tokens
  has_many :topics, through: :user_topics
  has_many :user_topics
  has_many :authorizations
  has_many :event_users
  has_many :events, through: :event_users
  has_one :promo_code

  state_machine :state, initial: :new do
    state :new
    state :active
    state :inactive

    event :activate do
      transition [:inactive, :new] => :active
    end

    event :deactivate do
      transition [:active, :new] => :inactive
    end

  end

  state_machine :timepad_state, initial: :unsynchronized do
    state :unsynchronized
    state :synchronized
    state :failed

    event :synchronize do
      transition [:unsynchronized, :failed] => :synchronized
    end

    event :failure do
      transition [:unsynchronized] => :failed
    end
  end

  state_machine :attending_conference_state, initial: :attended do
    state :attended
    state :not_decided

    event :not_decide do
      transition attended: :not_decided # for testing
    end

    event :attend do
      transition not_decided: :attended
    end
  end

  state_machine :pay_state, initial: :not_paid_part do
    state :not_paid_part
    state :paid_part

    event :not_pay_part do
      transition paid_part: :not_paid_part
    end

    event :pay_part do
      transition not_paid_part: :paid_part
    end
  end

  def create_auth_token
    create_token(configus.token.auth_lifetime)
  end

  def create_remind_password_token
    create_token(configus.token.remind_password_lifetime)
  end

  def create_user_welcome_token
    create_token(configus.token.old_user_welcome_lifetime)
  end

  def create_token(lifetime)
    token = SecureHelper.generate_token
    expired_at = Time.current + lifetime
    auth_tokens.create! :authentication_token => token, :expired_at => expired_at
  end

  def authenticate(password)
    self.password_digest == Digest::MD5.hexdigest(password)
  end

  def to_s
    UserDecorator.decorate(self).full_name
  end

  def password=(password)
    if password.present?
      @real_password = password
      self.password_digest = Digest::MD5.hexdigest(password)
    end
  end

  def password
    @real_password
  end
end
