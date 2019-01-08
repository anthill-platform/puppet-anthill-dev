require 'spec_helper'
describe 'anthill_config' do
  context 'with default values for all parameters' do
    it { should contain_class('anthill_config') }
  end
end
