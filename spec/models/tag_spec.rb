require 'rails_helper'

RSpec.describe Tag, :type => :model do
  describe 'associations' do
    it { is_expected.to have_many(:taggings) }
    it { is_expected.to have_many(:posts) }
  end

  context 'when tag has no associations' do
    let!(:category) { create(:category) }
    let!(:post) { create(:post, category: category) }
    let!(:tag1) { create(:tag) }
    let!(:tag2) { create(:tag) }
    let!(:tagging) { create(:tagging, tag: tag1, taggable: post) }

    it 'must destroy not associated tags' do
      Tag.destroy_not_associated_tags

      expect(Tag.all.count).to eq(1)
    end
  end
end
