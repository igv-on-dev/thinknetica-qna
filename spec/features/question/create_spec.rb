require 'rails_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to ask questions
} do
  given(:user) { create(:user) }

  scenario 'Authenticated user tries to create question' do
    sign_in(user)

    visit questions_path
    click_on t('questions.index.ask_question')
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Body of test question'
    click_on t('questions.new.create')

    expect(page).to have_content t('question.created')
    expect(page).to have_content 'Test question'
    expect(page).to have_content 'Body of test question'
  end


  scenario 'Non-authenticated user tries to create question' do
    visit questions_path
    click_on t('questions.index.ask_question')

    expect(page).to have_content t('devise.failure.unauthenticated')
  end
end
