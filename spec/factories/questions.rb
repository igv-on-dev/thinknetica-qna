FactoryGirl.define do
  factory :question do
    title 'MyString'
    body 'MyText'

    trait :without_title do
      title nil
    end

    trait :without_body do
      body nil
    end

    trait :with_sequential_title do
      sequence(:title) { |n| "Title of question #{n}" }
    end

    factory :invalid_question, traits: [:without_title, :without_body]

    factory :question_with_answers do
      transient do
        answers_count 5
      end

      after(:create) do |question, evaluator|
        create_list(:answer, evaluator.answers_count, :with_sequential_body, question: question)
      end
    end
  end
end
