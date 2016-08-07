require 'rails_helper'

RSpec.feature 'Comments', :type => :feature do
  describe 'User visit root page' do
    let!(:user1) { create(:user) }
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
      let!(:comment) { create(:comment, post: post, user: user1) }

      it 'have comments' do
        visit post_path(post)

        within('.comments') do
          expect(page).to have_css('.comment', count: 1)
          within page.find('.comment') do
            expect(page).to have_css('.commented_by', text: user1.name)
            expect(page).to have_css('.body', text: comment.body)
          end
        end
      end
    end
  end
end
