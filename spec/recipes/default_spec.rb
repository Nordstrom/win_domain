RSpec.describe 'testsetup::default' do
  include ChefRun

  it 'set the proper DNS addresses on the client' do
    expect(chef_run).to config_win_dns('Ethernet')
  end
end
