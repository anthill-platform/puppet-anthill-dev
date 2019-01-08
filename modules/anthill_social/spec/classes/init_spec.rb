require 'spec_helper'
describe 'anthill_social' do
  context 'with default values for all parameters' do
    it { should contain_class('anthill_social') }
  end
end
