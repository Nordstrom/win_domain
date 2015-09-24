# Encoding: utf-8

module Windows
  # helpers for the win_dyndns LWRP
  module Domainjoin
    # rubocop:disable Metrics/LineLength
    def config_exists(domain)
      domain = new_resource.domain
      membership = new_resource.membership
      Chef::Log.info("Checking config_exists for membership status \"#{membership}\" in domain: \"#{domain}\"")
      if membership.eql?('join')
        Chef::Log.info("Chef config_exists detected domain membership: \"#{domainmembership}\" and member server status: \"#{memberserver_status}\"")
        domainmembership && memberserver_status
      elsif membership.eql?('disjoin')
        Chef::Log.info("Chef config_exists detected standalone server status: \"#{standaloneserver}\"")
        standaloneserver
      end
    end

    def config_domain_membership
      membership = new_resource.membership
      if membership == 'join'
        join_domain
      elsif membership == 'disjoin'
        leave_domain
      else
        fail "The win_domain LWRP cannot process the specified membership value: \"#{membership}\""
      end
    end

    def join_domain
      domain = new_resource.domain
      username = new_resource.username
      password = new_resource.password
      ou = new_resource.ou
      Chef::Log.info("Joining computer to domain: \"#{domain}\"")
      joincmd = shell_out!("netdom join /D:\"#{domain}\" %computername% /ou:\"#{ou}\" /UD:#{domain}\\#{username} /PD:#{password}", returns: [0, 1190])
      Chef::Log.info "Join join_domain command result: \"#{joincmd.stdout}\""
      joincmd.stderr.empty? && joincmd.stdout.include?('The command completed successfully')
    end

    def leave_domain
      domain = new_resource.domain
      username = new_resource.username
      password = new_resource.password
      Chef::Log.info("Disjoining computer from domain: #{domain}")
      disjoincmd = shell_out!("netdom remove /D:#{domain} %computername% /UD:#{domain}\\#{username} /PD:#{password}")
      Chef::Log.info("Disjoin command result: \"#{disjoincmd.stdout}\"")
      disjoincmd.stderr.empty? && disjoincmd.stdout.include?('The command completed successfully')
    end

    def standaloneserver
      # DomainRole == 2 corresponds to "Standalone Server" role
      domain = new_resource.domain
      role = node['kernel']['cs_info']['domain_role']
      getdomain = node['domain']
      Chef::Log.info("standaloneserver method detected this server domain role is: \"#{role}\"")
      Chef::Log.info "standaloneserver method detected this servers dns domain is: \"#{getdomain}\""
      (role == 2) && !getdomain.eql?(domain)
    end

    def memberserver_status
      # DomainRole == 3 corresponds to "Member Server" role
      domain = new_resource.domain
      role = node['kernel']['cs_info']['domain_role']
      getdomain = node['domain']
      Chef::Log.info("memberserver_status detected this server domain role is: \"#{role}\"")
      Chef::Log.info("memberserver_status detected this server domain is: \"#{getdomain}\"")
      (role == 3) && getdomain.eql?(domain)
    end

    def domainmembership
      domain = new_resource.domain
      Chef::Log.info("Chef is checking for membership in domain: \"#{domain}\"")
      getdomain = node['domain']
      getdomain.eql?(domain)
    end
    # rubocop:enable Metrics/LineLength
  end
end
