module Jenkins
  module Tasks
    class CreateJobs

      attr_accessor :job_dir

      def initialize(options = {})
        if options[:job_dir].to_s.empty?
          raise ArgumentError, 'Job directory must be specified'
        end
        raise ArgumentError, 'CLI must be specified' unless options[:cli]
        @job_dir = options[:job_dir]
        @cli = options[:cli]
      end

      def execute
        desired_jobs.each do |job_xml_path|
          name = job_name(job_xml_path)
          create_job(job_xml_path) unless deployed_jobs.include?(name)
        end
      end

      def to_s
        'create_jobs'
      end

      def desired_jobs
        Dir.glob("#{jenkins_desired_jobs_dir}/*.xml")
      end

      def deployed_jobs
        @cli.run('list-jobs').split("\n")
      end

      def jenkins_desired_jobs_dir
        "#{job_dir}/jenkins_jobs"
      end

      def job_name(job_xml_path)
        File.basename(job_xml_path, '.*')
      end

      def create_job(job_xml_path)
        @cli.run("create-job #{job_name(job_xml_path)} < #{job_xml_path}")
      end

    end
  end
end
