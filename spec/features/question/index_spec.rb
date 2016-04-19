require 'rails_helper'

feature 'Show list of questions', %q{
  As a user
  I want to be able to see list of questions
} do
  given!(:questions)  { create_list(:question, 5, :with_sequential_title) }
  given(:user)        { create(:user) }

  scenario 'Non-authenticated user sees the list of questions' do
    questions_page_should_contents_links_to_all_questions
  end

  scenario 'Authenticated user sees the list of questions' do
    sign_in(user)
    questions_page_should_contents_links_to_all_questions
  end

  def questions_page_should_contents_links_to_all_questions
    visit questions_path
    questions.each { |q| expect(page).to have_link(q.title, question_path(q)) }
  end
end
