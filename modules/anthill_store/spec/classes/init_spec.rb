require 'spec_helper'
describe 'anthill_store' do
  context 'with default values for all parameters' do
    it { should contain_class('anthill_store') }
  end
end
