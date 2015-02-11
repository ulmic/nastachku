FactoryGirl.define do
  #TODO  first_name, first_name, city to russian sequence
  factory :user do
    password "ashQDR123!@#"
    first_name "Строка"
    last_name "Строка"
    city "Строка"
    company
    position "Строка"
    show_as_participant
    email
    twitter_name ""

    after(:create) do |user|
      user.activate
      FactoryGirl.create_list(:lecture, 5, user: user)
    end

  end

  factory :admin, parent: :user do
    admin true
  end

  factory :registrator, parent: :user do
    role :registrator
  end
end
