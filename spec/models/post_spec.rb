require 'rails_helper'

RSpec.describe Post, :type => :model do
  describe 'associations' do
    it { is_expected.to belong_to(:category) }
    it { is_expected.to have_many(:comments) }
  end
end
