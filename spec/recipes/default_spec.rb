RSpec.describe 'win_domain::default' do
  include ChefRun

  it 'converges successfully' do
    expect(chef_run).to include_recipe(described_recipe)
  end
end
