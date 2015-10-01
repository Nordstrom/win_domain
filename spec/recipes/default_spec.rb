RSpec.describe 'testsetup::default' do
  include ChefRun

  it 'carried out the domain membership action' do
    expect(chef_run).to config_win_domain('nordstrom.net')
  end
end
