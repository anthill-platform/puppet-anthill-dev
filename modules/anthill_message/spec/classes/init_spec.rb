require 'spec_helper'
describe 'anthill_message' do
  context 'with default values for all parameters' do
    it { should contain_class('anthill_message') }
  end
end
