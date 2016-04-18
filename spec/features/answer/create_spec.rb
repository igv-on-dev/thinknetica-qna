require 'rails_helper'

feature 'Create answer', %q{
  As an authenticated user
  I want to be able to answer question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:text_for_answer) { 'This is the answer for test question' }

  scenario 'Authenticated user answers question' do
    sign_in(user)
    visit question_path(question)

    fill_in t('answers.new.your_answer'), with: text_for_answer
    click_on t('answers.new.save')

    expect(current_path).to eq question_path(question)
    expect(page).to have_content t('answer.created')
    expect(page).to have_content text_for_answer
  end

  scenario 'Non-authenticated user is not able to answer questions' do
    visit question_path(question)
    expect(page).to_not have_link t('questions.show.add_answer')
  end
end
