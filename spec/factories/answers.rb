FactoryGirl.define do
  factory :answer do
    body 'MyText'
    question
    user

    trait :without_body do
      body nil
    end

    trait :with_sequential_body do
      sequence(:body) { |n| "Body of answer #{n}" }
    end

    factory :invalid_answer, traits: [:without_body]
  end
end
