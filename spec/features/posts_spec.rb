require 'rails_helper'

RSpec.feature 'Posts', :type => :feature do
  describe 'User visit root page' do
    let!(:user) { create(:user) }

    it 'have h1' do
      visit root_path
      expect(page).to have_css('h1', text: 'Posts')
    end

    context 'when there are no posts' do
      it 'have text' do
        visit root_path
        expect(page).to have_css('h3', text: 'There are no posts yet')
      end
    end
  end

  describe 'Signed in user', :js => true do
    let!(:user) { create(:user) }
    let!(:category) { create(:category) }
    let!(:post) { create(:post, category: category) }
    let!(:tag) { create(:tag) }
    let!(:tagging) { create(:tagging, tag: tag, taggable: post) }

    before do
      login_as(user)
    end

    it 'can see create link if user is admin' do
      visit root_path
      expect(user.is_admin?).to eq(true)
      expect(page).to have_link('Create post', href: new_post_path)
    end

    it 'create post' do
      visit new_post_path

      fill_in 'Title', :with => post.title
      fill_in 'Body', :with => post.body
      select category.name, from: 'post_category_id', :match => :first
      click_button 'Submit'

      expect(page).to have_css('.title', text: post.title)
      expect(page).to have_css('.body', text: post.body)
      expect(page).to have_css('div', text: category.name)
      expect(page).to have_css('div', text: tag.name)
      expect(page).to have_css('.alert', text: 'Post successfully created')
    end

    it 'edit post' do
      visit root_path
      page.find('.post').first(:link, 'Edit').click

      fill_in 'Title', :with => 'Updated title'
      fill_in 'Body', :with => 'Updated body'
      select category.name, from: 'post_category_id', :match => :first
      check "post_tag_ids_#{tag.id}"
      click_button 'Submit'

      expect(page).to have_css('.title', text: 'Updated title')
      expect(page).to have_css('.body', text: 'Updated body')
      expect(page).to have_css('div', text: category.name)
      expect(page).to have_css('div', text: tag.name)
      expect(page).to have_css('.alert', text: 'Post successfully updated')
    end

    it 'create new tag' do
      visit edit_post_path(post)
      tag_name = 'Tag name'

      fill_in 'post_tag_name', :with => tag_name
      find('a', :text => 'Add tag').click
      click_button 'Submit'

      expect(page).to have_css('div', text: tag_name)
    end

    it 'uncheck tag' do
      visit edit_post_path(post)

      uncheck "post_tag_ids_#{tag.id}"
      click_button 'Submit'

      expect(page).not_to have_css('div', text: tag.name)
    end

    it 'delete post' do
      visit post_path(post)
      click_link 'Delete'

      expect(page).to have_css('.alert', text: 'Post successfully destroyed')
    end
  end
end
