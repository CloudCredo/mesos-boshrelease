require 'net/http'
require 'tmpdir'

module Jenkins
  module Tasks
    class DownloadCli

      def execute
        res = Net::HTTP.get_response('localhost', '/jnlpJars/jenkins-cli.jar')
        raise 'Unable to download cli' unless res.code.to_i >= 200 and res.code.to_i < 400
        File.open(cli_path, 'w'){|f| f.write(res.body)}
        cli_path
      end

      def to_s
        'download_cli'
      end

      private

      def cli_path
        "#{Dir.tmpdir}/jenkins-cli.jar"
      end

    end
  end
end
