if defined?(ChefSpec)
  ChefSpec.define_matcher(:win_dns)

  def config_win_dns(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:win_dns, :config, resource_name)
  end
end
