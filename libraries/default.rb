# Encoding: utf-8

module Windows
  # helpers for the win_dyndns LWRP
  module Domainjoin
    # rubocop:disable Metrics/LineLength
    def status?(domain)
      domain = new_resource.domain
      membership = new_resource.membership
      Chef::Log.info "Checking for membership status \"#{membership}\" in domain: \"#{domain}\""
      if membership.eql?('join')
        domainmembership && memberserver_status?
        Chef::Log.info "Chef detected domain membership: #{domainmembership} and member server status: #{memberserver_status}"
      elsif membership.eql?('disjoin')
        standaloneserver?
        Chef::Log.info "Chef detected standalone server status: \"#{standaloneserver}\""
      end
    end

    def join_domain
      domain = new_resource.domain
      username = new_resource.username
      password = new_resource.password
      ou = new_resource.ou
      computername = powershell_out('$env:computername')
      Chef::Log.info "Joining computer to domain: \"#{domain}\""
      joincmd = shell_out!("netdom join /d:#{domain} #{computername} /ou:#{ou} /userd:#{domain}\\#{username} /passwordd:#{password}")
      Chef::Log.info "Join command result: \"#{joincmd.stdout}\""
      joincmd.stderr.empty? && joincmd.stdout.include?('The command completed successfully')
    end

    def disjoin_domain
      domain = new_resource.domain
      username = new_resource.username
      password = new_resource.password
      ou = new_resource.ou
      Chef::Log.info "disjoining computer from domain: #{domain}"
      disjoincmd = shell_out!("netdom remove /d:#{domain} %computername% /ou:#{ou} /userd:#{domain}\\#{username} /passwordd:#{password}")
      Chef::Log.info "Disjoin command result: \"#{disjoincmd.stdout}\""
      disjoincmd.stderr.empty? && disjoincmd.stdout.include?('The command completed successfully')
    end

    def standaloneserver
      # DomainRole == 2 corresponds to "Standalone Server" role
      role = powershell_out('(Get-WmiObject -Class Win32_ComputerSystem -ComputerName $env:ComputerName).DomainRole').stdout.chomp
      nouserdnsdomain = powershell_out('$env:userdnsdomain -eq $nil')
      Chef::Log.info("Chef detected this server domain role is: #{role}")
      Chef::Log.info "Chef detected this servers dns domain is: \"#{userdnsdomain}\""
      %w(2).include?(role) && nouserdnsdomain.eql?('True')
    end

    def memberserver_status
      # DomainRole == 3 corresponds to "Member Server" role
      domain = new_resource.domain
      role = powershell_out('(Get-WmiObject -Class Win32_ComputerSystem -ComputerName $env:ComputerName).DomainRole').stdout.chomp
      userdnsdomain = powershell_out("$env:userdnsdomain -match #{domain}")
      Chef::Log.info "Chef detected this server domain role is: \"#{role}\""
      Chef::Log.info "Chef detected this server useruserdnsdomain is: \"#{userdnsdomain}\""
      %w(3).include?(myrole) && useruserdnsdomain.include?(useruserdnsdomain)
    end

    def domainmembership
      domain = new_resource.domain
      Chef::Log.info "Chef is checking for membership in domain: #{domain}"
      userdnsdomain = powershell_out('$env:userdnsdomain')
      userdomain = powershell_out('$env:userdomain')
      userdnsdomain.stderr.empty? && ((userdnsdomain.stdout.include?(domain)) || (userdomain.stdout.include?(domain)))
    end
    # rubocop:enable Metrics/LineLength
  end
end
