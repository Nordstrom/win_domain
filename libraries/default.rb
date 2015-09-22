# Encoding: utf-8

module Windows
  # helpers for the win_dyndns LWRP
  module Domainjoin
    def status?(domain)
      domain = new_resource.domain
      membership = new_resource.membership
      Chef::Log.info "Checking for membership status \"#{membership}\" in domain: \"#{domain}\""
      if membership.eql?('join')
        domainmembership && memberserver_status?
        Chef::Log.info "Chef detected domain membership: #{domainmembership} and member server status: #{memberserver_status}"
      elsif membership.eql?('disjoin')
        standaloneserver?
        Chef::Log.info "Chef detected standalone server status: #{standaloneserver}"
      end
    end

    def join_domain
      domain = new_resource.domain
      Chef::Log.info "Joining computer to domain: #{domain}"
      powershell_out('*')
    end

    def domain_disjoined?(*)
      domain = new_resource.domain
      Chef::Log.info "Checking for membership in domain: #{domain}"
      @exists ||= begin
        cmd = shell_out('*')
        cmd.stderr.empty? && cmd.stdout.include?(domain)
      end
    end

    def disjoin_domain
      domain = new_resource.domain
      Chef::Log.info "Joining computer to domain: #{domain}"
      powershell_out('*')
    end

    def standaloneserver
      # DomainRole == 2 corresponds to "Standalone Server" role
      myrole = powershell_out('(Get-WmiObject -Class Win32_ComputerSystem -ComputerName $env:ComputerName).DomainRole').stdout.chomp
      Chef::Log.debug("WSE memberserver function detected this is a member server: #{myrole}")
      %w(2).include?(myrole)
    end

    def memberserver_status
      # DomainRole == 3 corresponds to "Member Server" role
      myrole = powershell_out('(Get-WmiObject -Class Win32_ComputerSystem -ComputerName $env:ComputerName).DomainRole').stdout.chomp
      Chef::Log.debug("WSE memberserver function detected this is a member server: #{myrole}")
      %w(3).include?(myrole)
    end

    def domainmembership
      domain = new_resource.domain
      Chef::Log.info "Chef is checking for membership in domain: #{domain}"
      userdnsdomain = powershell_out('$env:userdnsdomain')
      userdomain = powershell_out('$env:userdomain')
      userdnsdomain.stderr.empty? && ((userdnsdomain.stdout.include?(domain)) || (userdomain.stdout.include?(domain)))
    end
  end
end
