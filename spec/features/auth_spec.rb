require 'rails_helper'

RSpec.feature 'Auth', :type => :feature do
  let(:user) { create(:user, password: password) }
  let(:password) { 'user_password' }

  describe 'sign in' do
    let(:input_password) { password }

    before do
      visit new_user_session_path
      within('form#new_user') do
        fill_in 'Email', with: user.email
        fill_in 'Password', with: input_password
      end
      click_button 'Sign in'
    end

    context 'with valid password' do
      it 'show message' do
        expect(page).to have_css('.alert', text: 'Signed in successfully.')
      end

      it 'have sign out link' do
        expect(page).to have_link 'Sign out'
      end
    end

    context 'with invalid password' do
      let(:input_password) { 'invalid' }

      it 'show error' do
        expect(page).to have_css('.alert', text: 'Invalid Email or password')
      end

      it 'have not sing out link' do
        expect(page).not_to have_link 'Sign out'
      end

      it 'have sign up link' do
        expect(page).to have_link 'Sign up'
      end
    end
  end

  describe 'Sing out' do
    before do
      login_as(user)
      visit root_path
      click_link 'Sign out'
    end

    it 'show message' do
      expect(page).to have_css('.alert', text: 'Signed out successfully.')
    end

    it 'have sign in link' do
      expect(page).to have_link 'Sign in'
    end

    it 'have sign up link' do
      expect(page).to have_link 'Sign up'
    end
  end
end