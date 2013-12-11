require_relative './jenkins/cli'
Dir.glob(File.dirname(__FILE__) + '/jenkins/tasks/*.rb', &method(:require))

module Jenkins
  class Configurator

    def initialize(options = {})
      @options = options
    end

    def configure
      tasks.each { |t| t.execute }
    end

    def tasks
      cli = Cli.new
      [
        ::Jenkins::Tasks::CreateTempDirectory.new(store_dir),
        ::Jenkins::Tasks::AddSshKnownHosts.new(ssh_known_hosts_path, ssh_known_hosts_entries),
        ::Jenkins::Tasks::DownloadCli.new,
        ::Jenkins::Tasks::InstallPlugins.new(
          {:plugins => Array(@options[:plugins]), :cli => cli}),
        ::Jenkins::Tasks::UpdateConfig.new(
          {:job_dir => job_dir, :store_dir => store_dir, :cli => cli}),
        ::Jenkins::Tasks::CreateJobs.new({:job_dir => job_dir, :cli => cli})
      ]
    end

    private

    def store_dir
      @options[:store_dir] || '/var/vcap/store/jenkins_master'
    end

    def job_dir
      @options[:job_dir] || '/var/vcap/jobs/jenkins_master'
    end

    def ssh_known_hosts_path
      @options[:known_hosts_path] || '/home/vcap/.ssh/known_hosts'
    end

    def ssh_known_hosts_entries
      @options[:known_hosts_entries] || {
	  'bitbucket1' => 'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAoKv1BKNt+5oPgEcjaHdbqsaRsuCutdWec/1FCcjXsRJMi46XDWFA0Z1MXmUORUqhs+tLgBrX5Vz4JG5MBMGfH09xIpWbF8kyLdTCHy8pEzETqHBusADwtHJE5y7is8YHd+PhVaW70M5d70EcX3GXys0pRrGPL+rOHwACA6rMx8wpOkdjOAzO2RtnDgB63QJMlmJhnGDou7idgoR+a1pzBXNfqImHa8v/fVao7wyj2+4fp6VVzzVghxy9Pv5yfeyHWyNoHi77EmDdR3y2IuZOQlzjikk9J1iDQ+xaehjH0Ub4RdOucmy722IsphNaCtwm1/+HbzXt+MPtucnnIC8Szw==', 
	  'bitbucket2' => 'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAubiN81eDcafrgMeLzaFPsw2kNvEcqTKl/VqLat/MaB33pZy0y3rJZtnqwR2qOOvbwKZYKiEO1O6VqNEBxKvJJelCq0dTXWT5pbO2gDXC6h6QDXCaHo6pOHGPUy+YBaGQRGuSusMEASYiWunYN0vCAI8QaXnWMXNMdFP3jHAJH0eDsoiGnLPBlBp4TNm6rYI74nMzgz3B9IikW4WVK+dc8KZJZWYjAuORU3jc1c/NPskD2ASinf8v3xnfXeukU0sJ5N6m5E8VLjObPEO+mN2t/FZTMZLiFqPWc/ALSqnMnnhwrNi2rbfg/rd/IpL8Le3pSBne8+seeFVBoGqzHM9yXw==', 
	  'bitbucket3' => 'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==', 
        } 
    end

  end
end
