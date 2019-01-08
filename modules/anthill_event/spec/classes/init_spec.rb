require 'spec_helper'
describe 'anthill_event' do
  context 'with default values for all parameters' do
    it { should contain_class('anthill_event') }
  end
end
