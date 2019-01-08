require 'spec_helper'
describe 'anthill_discovery' do
  context 'with default values for all parameters' do
    it { should contain_class('anthill_discovery') }
  end
end
