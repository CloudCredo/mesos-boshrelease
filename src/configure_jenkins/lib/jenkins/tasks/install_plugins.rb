module Jenkins
  module Tasks
    class InstallPlugins

      attr_reader :plugins_to_install

      def initialize(options = {})
        raise ArgumentError, 'Plugins must be specified' unless options[:plugins]
        raise ArgumentError, 'CLI must be specified' unless options[:cli]
        @plugins_to_install = options[:plugins]
        @cli = options[:cli]
      end

      def execute
        plugins_to_install.each do |name|
          unless plugins.include?(name)
            install_plugin(name)
          end
        end
      end

      def to_s
        'install_plugins'
      end

      def plugins
        @cli.run('list-plugins').split("\n").map do |line|
          line.split.first
        end
      end

      def install_plugin(name)
        update_plugin_list
        @cli.run "install-plugin #{name}"
        restart_jenkins
      end

      def update_plugin_list
        system("curl  -L http://updates.jenkins-ci.org/update-center.json | sed '1d;$d' | curl -X POST -H 'Accept: application/json' -d @- http://localhost/updateCenter/byId/default/postBack")
        raise "Problem updating Jenkins Plugin list" unless $?.success?
      end

      def restart_jenkins
        @cli.run 'safe-restart'
      end

    end
  end
end
