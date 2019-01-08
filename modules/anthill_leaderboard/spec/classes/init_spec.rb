require 'spec_helper'
describe 'anthill_leaderboard' do
  context 'with default values for all parameters' do
    it { should contain_class('anthill_leaderboard') }
  end
end
