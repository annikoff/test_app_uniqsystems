FactoryGirl.define do
  factory :tag do
    sequence(:name) { |n| "Tag#{n}" }
    association :taggins
    association :posts
  end
end
