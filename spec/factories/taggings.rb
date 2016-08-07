FactoryGirl.define do
  factory :tagging do
    association :tag
    association :taggable
  end
end
