if defined?(ChefSpec)
  ChefSpec.define_matcher(:win_domain)

  def config_win_domain(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:win_domain, :config, resource_name)
  end
end
