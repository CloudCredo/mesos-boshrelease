require 'tmpdir'

module Jenkins

  class Cli

    def run(cmd)
      result = %x{/var/vcap/packages/jre/bin/java -jar #{cli_path} -s http://localhost/ #{cmd}}
      raise "Problem running jenkins cli" unless $?.success?
      result
    end

    private

    def cli_path
      "#{Dir.tmpdir}/jenkins-cli.jar"
    end

  end

end
