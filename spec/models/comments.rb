require 'rails_helper'

RSpec.describe Comment, :type => :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:posts) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:post) }
  end
end
