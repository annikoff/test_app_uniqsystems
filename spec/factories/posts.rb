FactoryGirl.define do
  factory :post do
    sequence(:title) { |n| "Post title #{n}" }
    sequence(:body) { |n| "Post body #{n}" }
    association :category
  end
end

