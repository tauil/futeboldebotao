FactoryGirl.define do
  factory :player do
    sequence(:email) { |n| "email#{n}@rankit.com" }
    sequence(:name) { |n| "Player Name #{n}" }
    sequence(:team_name) { |n| "Playe Team Name #{n}" }
  end

end
