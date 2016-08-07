require 'rails_helper'

RSpec.feature 'Comments', :type => :feature do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:category) { create(:category) }
  let!(:post) { create(:post, category: category) }

  context 'when there are no comments' do
    it 'have comments count' do
      visit post_path(post)

      expect(page).to have_css('strong', text: 'comments:')
      expect(page).to have_css('a.comments_count', text: '0')
    end
  end

  context 'when comment exists' do
    let!(:comment) { create(:comment, post: post, user: nil) }

    it 'have no comments' do
      visit post_path(post)

      expect(Comment.all.size).to eq(1)
      expect(page).to have_css('.comment', text: 'There are no comments yet')
    end

    it 'have comments to manage' do
      login_as(user1)
      visit post_path(post)

      expect(page).to have_css('.comment', count: 1)
      expect(page).to have_css('.commented_by', text: 'Anonymous')
      expect(page).to have_css('.body', text: comment.body)
      expect(page).to have_link('Accept')
      expect(page).to have_link('Delete')
    end

    it 'allows to admin to accept comment' do
      login_as(user1)
      visit post_path(post)

      click_link('Accept')
      expect(page).to have_css('.alert', text: 'Comment successfully accepted')
      expect(page).to have_link('Decline')
    end

    it 'allows to admin to decline comment' do
      login_as(user1)
      comment.update_attribute(:is_accepted, true)
      visit post_path(post)

      click_link('Decline')
      expect(page).to have_css('.alert', text: 'Comment successfully declined')
    end

    it 'allows to admin to delete comment' do
      login_as(user1)
      visit post_path(post)

      click_link('Delete', href: post_comment_path(post, comment))
      expect(page).to have_css('.alert', text: 'Comment successfully destroyed')
      expect(page).to have_css('.comment', text: 'There are no comments yet')
    end
  end

  it 'allows to registered user create a comment' do
    login_as(user2)
    visit post_path(post)

    fill_in 'comment_body', :with => 'Comment'
    click_button 'Submit'

    expect(page).to have_css('.alert', text: 'Comment successfully created. It would be shown after moderation')
    expect(page).to have_css('.comment', text: 'There are no comments yet')
  end
end
