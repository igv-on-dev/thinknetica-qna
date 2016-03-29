module FeatureHelper
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button I18n.t('devise.sessions.new.sign_in')
  end
end