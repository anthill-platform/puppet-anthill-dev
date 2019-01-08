require 'spec_helper'
describe 'anthill_admin' do
  context 'with default values for all parameters' do
    it { should contain_class('anthill_admin') }
  end
end
