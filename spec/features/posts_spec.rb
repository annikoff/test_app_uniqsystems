require 'rails_helper'

RSpec.feature 'Posts', :type => :feature do
  describe 'User visit root page' do
    let!(:user) { create(:user) }

    it 'have h1' do
      visit root_path
      expect(page).to have_css('h1', text: 'Posts')
    end

    context 'when posts exists' do
      let!(:category) { create(:category) }
      let!(:post) { create(:post, category: category) }

      it 'have posts' do
        visit root_path
        within('.posts') do
          expect(page).to have_css('.post', count: 1)
          within page.find('.post', text: post.title) do
            expect(page).to have_css('.title', text: post.title)
            expect(page).to have_css('.body', text: post.body)
          end
        end
      end
    end

    context 'when there is no posts' do
      it 'have text' do
        visit root_path
        expect(page).to have_css('h3', text: 'There is no posts yet')
      end
    end
  end

  describe 'Signed in user' do
    let!(:user) { create(:user) }
    let!(:category) { create(:category) }
    let!(:post) { create(:post, category: category) }

    before do
      login_as(user)
    end

    it 'can see create link if user is admin' do
      visit root_path
      expect(user.is_admin?).to eq(true)
      expect(page).to have_link('a', text: 'Create post', href: new_post_path)
    end

    it 'create post' do
      visit new_post_path

      fill_in 'Title', :with => post.title
      fill_in 'Body', :with => post.body
      select category.name, from: 'post_category_id', :match => :first
      click_button 'Submit'

      expect(page).to have_css('.alert-info', text: 'Post successfully created')
    end

    it 'edit post' do
      visit root_path
      page.find('.post').first(:link, 'Edit').click

      fill_in 'Title', :with => 'Updated title'
      fill_in 'Body', :with => 'Updated body'
      select category.name, from: 'post_category_id', :match => :first
      click_button 'Submit'

      expect(page).to have_css('.alert-info', text: 'Post successfully updated')
    end

    it 'delete post' do
      visit post_path(post)
      click_link 'Delete'

      expect(page).to have_css('.alert-info', text: 'Post successfully destroyed')
    end
  end
end
