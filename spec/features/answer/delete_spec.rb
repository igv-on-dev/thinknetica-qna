require 'rails_helper'

feature 'Delete answer', %q{
  As an author
  I want to be able to delete my answer
} do

  given(:author) { create(:user) }
  given(:non_author) { create(:user) }
  given(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 3, :with_sequential_body, question: question, user: author) }
  given!(:target) { answers.last }

  scenario 'Author deletes his answer' do
    sign_in(author)

    visit question_path(question)
    expect(page).to have_content(target.body)

    click_on "delete_answer_#{ target.id }"
    expect(current_path).to eq question_path(question)
    expect(page).to have_content t('answer.deleted')
    expect(page).to_not have_content target.body
  end

  scenario 'Authorised user try to delete answer of another user' do
    sign_in(non_author)
    answer_deletion_link_should_be_absent(target)
  end

  scenario 'Non-authorised user try to delete answer' do
    answer_deletion_link_should_be_absent(target)
  end

  def answer_deletion_link_should_be_absent(answer)
    visit question_path(answer.question)
    expect(page).to have_content(answer.body)
    expect(page).to_not have_selector(:css, "#delete_answer_#{ answer.id }")
  end
end
