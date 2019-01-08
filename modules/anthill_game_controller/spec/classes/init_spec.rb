require 'spec_helper'
describe 'anthill_game' do
  context 'with default values for all parameters' do
    it { should contain_class('anthill_login') }
  end
end
