require 'spec_helper'
describe 'anthill' do
  context 'with default values for all parameters' do
    it { should contain_class('anthill') }
  end
end
