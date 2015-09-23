RSpec.describe 'testsetup::default' do
  include ChefRun

  it 'set the proper DNS addresses on the client' do
    expect(chef_run).to config_win_domain('nordstrom.net')
  end
end
