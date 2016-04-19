require 'rails_helper'

feature 'Delete question', %q{
  As an author
  I want to be able to delete my question
} do
  given(:author) { create(:user) }
  given(:not_author) { create(:user) }
  given!(:question) { create(:question, user: author) }

  scenario 'Author deletes his question' do
    sign_in(author)
    visit question_path(question)
    click_on "delete_question_#{ question.id }"

    expect(current_path).to eq questions_path
    expect(page).to have_content t('question.deleted')
    expect{ visit question_path(question) }.to raise_error( ActiveRecord::RecordNotFound )
  end

  scenario 'Authorised user does not see deletion link for not owned question' do
    sign_in(not_author)
    question_deletion_link_should_be_absent(question)
  end

  scenario 'Non-authorised user does not see deletion link for any questions' do
    question_deletion_link_should_be_absent(question)
  end


  def question_deletion_link_should_be_absent(question)
    visit question_path(question)
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to_not have_selector(:css, "#delete_question_#{ question.id }")
  end
end
