require 'spec_helper'
describe 'anthill_static' do
  context 'with default values for all parameters' do
    it { should contain_class('anthill_static') }
  end
end
