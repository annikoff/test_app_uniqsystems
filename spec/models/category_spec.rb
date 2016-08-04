require 'rails_helper'

RSpec.describe Category, :type => :model do
  describe 'associations' do
    it { is_expected.to have_many(:posts) }
  end
end
