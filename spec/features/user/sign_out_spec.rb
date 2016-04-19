require 'rails_helper'

feature 'User sign out', %q{
  In order to be able to finish session
  As an authenticated user
  I want to be able to sign out
} do
  given(:user) { create(:user) }

  scenario 'Authenticated user try to sign out' do
    sign_in(user)

    click_on t('devise.sessions.destroy.sign_out')

    expect(page).to have_content t('devise.sessions.already_signed_out')
    expect(page).to have_content t('devise.sessions.new.sign_in')
    expect(page).to_not have_content t('devise.sessions.destroy.sign_out')
  end
end
