require 'spec_helper'
describe 'anthill_dlc' do
  context 'with default values for all parameters' do
    it { should contain_class('anthill_dlc') }
  end
end
