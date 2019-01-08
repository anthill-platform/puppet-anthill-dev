require 'spec_helper'
describe 'anthill_profile' do
  context 'with default values for all parameters' do
    it { should contain_class('anthill_profile') }
  end
end
