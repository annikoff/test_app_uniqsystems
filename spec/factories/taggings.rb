FactoryGirl.define do
  factory :tagging do
    association :tags
    association :taggable
  end
end
