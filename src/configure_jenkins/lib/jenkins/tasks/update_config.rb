require 'nokogiri'
require 'tmpdir'

module Jenkins
  module Tasks
    class UpdateConfig

      def initialize(options)
        if ! options.respond_to?(:[]) || options[:store_dir].to_s.empty?
          raise ArgumentError, 'Store directory must be provided'
        end
        if options[:job_dir].to_s.empty?
          raise ArgumentError, 'Job directory must be provided'
        end
        raise ArgumentError, 'CLI must be provided' unless options[:cli]
        @options = options.freeze
      end

      def execute
        if config_version(existing_config_path) != config_version(src_config_path)
          copy_config_into_place
          restart_jenkins
        end
      end

      def to_s
        'update_config'
      end

      def config_version(config_path)
        if File.readable?(config_path)
          version = Nokogiri::XML.parse(
            File.read(config_path)).xpath('hudson/systemMessage').text
          version.empty? ? nil : version
        end
      end

      def copy_config_into_place
        FileUtils.cp src_config_path, existing_config_path
      end

      def src_config_path
        "#{@options[:job_dir]}/config/config.xml"
      end

      def existing_config_path
        "#{@options[:store_dir]}/config.xml"
      end

      def restart_jenkins
        @options[:cli].run 'safe-restart'
      end

    end
  end
end
