require 'spec_helper'
describe 'anthill_promo' do
  context 'with default values for all parameters' do
    it { should contain_class('anthill_promo') }
  end
end
