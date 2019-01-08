require 'spec_helper'
describe 'anthill_report' do
  context 'with default values for all parameters' do
    it { should contain_class('anthill_report') }
  end
end
