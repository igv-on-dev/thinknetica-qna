require 'rails_helper'

feature 'Show a question with answers', %q{
  As a user
  I want to be able to see question and its answers if exist
} do
  given(:unanswered_question) { create(:question) }
  given!(:answered_question) { create(:question_with_answers, answers_count: 3) }
  given(:user) { create(:user) }

  scenario 'Non-authenticated user sees answered question' do
    question_should_be_visible(answered_question)
  end

  scenario 'Authenticated user sees answered question' do
    sign_in(user)
    question_should_be_visible(answered_question)
  end

  scenario 'Non-authenticated user sees unanswered question' do
    question_should_be_visible(unanswered_question)
  end

  scenario 'Authenticated user sees question unanswered question' do
    sign_in(user)
    question_should_be_visible(unanswered_question)
  end

  def question_should_be_visible(question)
    visit question_path(question)

    expect(page).to have_content(question.title)
    expect(page).to have_content(question.body)
    question.answers.each { |answer| expect(page).to have_content(answer.body) }
    expect(page).to have_content(t('questions.show.no_answers_yet')) unless question.answers.any?
  end
end
