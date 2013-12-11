require 'fileutils'
module Jenkins
  module Tasks
    class CreateTempDirectory

      attr_reader :store_dir

      def initialize(store_dir)
        raise ArgumentError.new('Store directory must be specified') if store_dir.to_s.empty?
        @store_dir = store_dir
      end

      def execute
        FileUtils.mkdir_p "#{store_dir}/tmp" if Dir.exists? store_dir
      end

      def to_s
        'create_temp_directory'
      end

    end
  end
end
