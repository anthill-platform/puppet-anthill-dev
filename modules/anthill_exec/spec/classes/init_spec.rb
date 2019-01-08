require 'spec_helper'
describe 'anthill_exec' do
  context 'with default values for all parameters' do
    it { should contain_class('anthill_exec') }
  end
end
