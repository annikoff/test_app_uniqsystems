FactoryGirl.define do
  factory :comment do
    sequence(:body) { |n| "Comment body #{n}" }
    association :user
    association :post
  end
end

