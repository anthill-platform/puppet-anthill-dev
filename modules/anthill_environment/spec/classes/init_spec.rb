require 'spec_helper'
describe 'anthill_environment' do
  context 'with default values for all parameters' do
    it { should contain_class('anthill_environment') }
  end
end
