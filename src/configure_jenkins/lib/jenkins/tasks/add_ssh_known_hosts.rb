module Jenkins
  module Tasks
    class AddSshKnownHosts

      def initialize(known_hosts_path, known_hosts_entries)
        raise ArgumentError, 'Path to known_hosts must be specified' if known_hosts_path.to_s.empty?
        raise ArgumentError, 'Known hosts entries must be specified' unless known_hosts_entries

        @known_hosts_path = known_hosts_path
        @known_hosts_entries = known_hosts_entries
      end

      def execute
        Dir.mkdir(ssh_config_dir, 0700) unless Dir.exists? ssh_config_dir
	  ssh_known_hosts_entries.each do |label, host_key|
          unless ssh_host_key_present?(label)
    	    add_ssh_host_key("\n#{label} #{host_key}\n")
    	  end
        end
      end

      def to_s
        'add_github_ssh_host_key'
      end

      private

      def ssh_known_hosts_path
        @known_hosts_path
      end

      def ssh_known_hosts_entries
        @known_hosts_entries
      end

      def ssh_config_dir
        File.dirname(ssh_known_hosts_path)
      end

      def ssh_host_key_present?(hostname)
        File.readable?(ssh_known_hosts_path) and IO.readlines(ssh_known_hosts_path).any? do |host_key|
          host_key.start_with?(hostname)
        end
      end

      def add_ssh_host_key(host_key)
        File.open(ssh_known_hosts_path, 'a'){|f| f.write(host_key)}
      end

    end
  end
end
