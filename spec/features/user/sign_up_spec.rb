require 'rails_helper'

feature 'User sign up', %q{
  In order to be able to sign in
  As an non-registered user
  I want to be able to sign up
} do

  given(:registered) { create(:user) }

  scenario 'Non-registered user try to register' do
    visit root_path
    click_on t('devise.registrations.new.sign_up')

    expect(current_path).to eq new_user_registration_path

    fill_in 'Email', with: 'trytosignup@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_button t('devise.registrations.new.sign_up')

    expect(current_path).to eq root_path
    expect(page).to have_content t('devise.registrations.signed_up')
  end


  scenario 'Registered user try to register' do
    visit root_path
    click_on t('devise.registrations.new.sign_up')

    expect(current_path).to eq new_user_registration_path

    fill_in 'Email', with: registered.email
    fill_in 'Password', with: registered.password
    fill_in 'Password confirmation', with: registered.password_confirmation
    click_button t('devise.registrations.new.sign_up')

    expect(current_path).to eq user_registration_path
    expect(page).to have_content "Email #{t('errors.messages.taken')}"
  end
end
