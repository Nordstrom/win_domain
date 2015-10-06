# Encoding: utf-8

module Windows
  # helpers for the win_dyndns LWRP
  module Domainjoin
    # rubocop:disable Metrics/LineLength
    def config_exists(domain)
      domain = new_resource.domain
      membership = new_resource.membership
      Chef::Log.debug("Checking config_exists for membership status \"#{membership}\" in domain: \"#{domain}\"")
      if membership.eql?('join')
        Chef::Log.debug("Chef config_exists detected domain membership: \"#{domainmembership}\" and member server status: \"#{memberserver_status}\"")
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
        spawn_reboot
        kill_chef_run
      elsif membership == 'disjoin'
        leave_domain
        delete_computer_account
        spawn_reboot
        kill_chef_run
      else
        fail "The win_domain LWRP cannot process the specified membership value: \"#{membership}\""
      end
    end

    def spawn_reboot
      delay = new_resource.reboot_delay
      Chef::Log.info("win_domain LWRP is spawing a #{delay} second delayed reboot...")
      powershell_out("cmd /c start powershell -NoExit {sleep #{delay}; restart-computer -force}")
    end

    def kill_chef_run
      Chef::Log.info('win_domain LWRP is terminating the chef run to force a reboot...')
      killcmd = powershell_out("cmd /c start powershell -NoExit { invoke-expression \"get-process | ?{$_.ProcessName -like \"ruby\*\"} | stop-process -force\" }")
      killcmd.stderr.empty?
    end

    def join_domain
      domain = new_resource.domain
      username = new_resource.username
      password = new_resource.password
      ou = new_resource.ou
      Chef::Log.info("Joining computer to domain: \"#{domain}\"")
      joincmd = shell_out("netdom join /D:\"#{domain}\" %computername% /ou:\"#{ou}\" /UD:#{domain}\\#{username} /PD:#{password}", returns: [0, 1190, 1219, 2692])
      Chef::Log.debug "Join join_domain command result: \"#{joincmd.stdout}\""
      # back off and retry if busy
      until joincmd.stdout.include?('The command completed successfully')
        sleep 10
        joincmd = shell_out("netdom join /D:\"#{domain}\" %computername% /ou:\"#{ou}\" /UD:#{domain}\\#{username} /PD:#{password}", returns: [0, 1190, 1219, 2692])
        Chef::Log.info("RETRYING: Join command result: \"#{joincmd.stdout}\"")
      end
      joincmd.stderr.empty? && joincmd.stdout.include?('The command completed successfully')
    end

    def leave_domain
      domain = new_resource.domain
      username = new_resource.username
      password = new_resource.password
      Chef::Log.info("Disjoining computer from domain: #{domain}")
      disjoincmd = shell_out("netdom remove /D:#{domain} %computername% /UD:#{domain}\\#{username} /PD:#{password}", returns: [0, 1190, 1219, 2692])
      Chef::Log.debug("Disjoin command result: \"#{disjoincmd.stdout}\"")
      # back off and retry if busy
      until disjoincmd.stdout.include?('The command completed successfully') || disjoincmd.stdout.include?('This machine is not currently joined to a domain')
        sleep 10
        disjoincmd = shell_out("netdom remove /D:#{domain} %computername% /UD:#{domain}\\#{username} /PD:#{password}", returns: [0, 1190, 1219, 2692])
        Chef::Log.info("RETRYING: Disjoin command result: \"#{disjoincmd.stdout}\"")
      end
      disjoincmd.stderr.empty? && (disjoincmd.stdout.include?('The command completed successfully') || disjoincmd.stdout.include?('This machine is not currently joined to a domain'))
    end

    def delete_computer_account
      domain = new_resource.domain
      username = new_resource.username
      password = new_resource.password
      ou = new_resource.ou
      Chef::Log.info("Deleting computer account \"#{ENV['computername']}\" from domain: \"#{domain}\"")
      deletecmd = shell_out!("dsrm \"CN=#{ENV['computername']},#{ou}\" -u #{domain}\\#{username} -p #{password} -d #{domain} -noprompt")
      Chef::Log.debug("Computer account delete command result: \"#{deletecmd.stdout}\"")
      deletecmd.stderr.empty? && deletecmd.stdout.include?("dsrm succeeded:CN=#{ENV['computername']},#{ou}")
    end

    def standaloneserver
      # DomainRole == 2 corresponds to "Standalone Server" role
      role = node['kernel']['cs_info']['domain_role']
      Chef::Log.info("standaloneserver method detected this server domain role is: \"#{role}\"")
      (role == 2)
    end

    def memberserver_status
      # DomainRole == 3 corresponds to "Member Server" role
      domain = new_resource.domain
      role = node['kernel']['cs_info']['domain_role']
      getdomain = node['domain']
      Chef::Log.debug("memberserver_status detected this server domain role is: \"#{role}\"")
      Chef::Log.debug("memberserver_status detected this server domain is: \"#{getdomain}\"")
      (role == 3) && getdomain.eql?(domain)
    end

    def domainmembership
      domain = new_resource.domain
      Chef::Log.debug("Chef is checking for membership in domain: \"#{domain}\"")
      getdomain = node['domain']
      getdomain.eql?(domain)
    end
    # rubocop:enable Metrics/LineLength
  end
end
