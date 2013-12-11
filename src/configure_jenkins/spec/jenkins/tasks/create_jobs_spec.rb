require_relative '../../../lib/jenkins/tasks/create_jobs'

module Jenkins
  module Tasks
    describe CreateJobs do
      describe '#initialize' do
        it 'accepts the BOSH job directory and CLI' do
          CreateJobs.new({:job_dir => '/var/vcap/jobs/jenkins_master', :cli => double})
        end
        it 'raises if the job directory is not provided' do
          expect{ CreateJobs.new({:cli => double}) }.to raise_error(ArgumentError,
            'Job directory must be specified')
        end
        it 'raises if the CLI is not provided' do
          expect{ CreateJobs.new({:job_dir => '/var/vcap/jobs/jenkins_master'}) }.to raise_error(ArgumentError,
            'CLI must be specified')
        end
      end
      describe '#execute' do
        let(:task) { CreateJobs.new({:job_dir => '/var/vcap/jobs/jenkins_master', :cli => double}) }
        it 'does not create jobs if there are no desired jobs' do
          expect(task).to receive(:desired_jobs).and_return([])
          expect(task).not_to receive(:create_job)
          task.execute
        end
        it 'does not create the job if it already exists' do
          expect(task).to receive(:desired_jobs).and_return(['/foo/my_job.xml'])
          expect(task).to receive(:deployed_jobs).and_return(['my_job'])
          expect(task).not_to receive(:create_job)
          task.execute
        end
        it 'creates the job if it does not already exist' do
          expect(task).to receive(:desired_jobs).and_return(
            ['/foo/my_first_job.xml', '/foo/my_second_job.xml'])
          expect(task).to receive(:deployed_jobs).twice.and_return(['my_first_job'])
          expect(task).not_to receive(:create_job).with('/foo/my_first_job.xml')
          expect(task).to receive(:create_job).with('/foo/my_second_job.xml')
          task.execute
        end
      end
      describe "#job_name" do
        let(:task) { CreateJobs.new({:job_dir => '/var/vcap/jobs/jenkins_master', :cli => double}) }
        it 'uses the basename of the job config file for the job name' do
          expect(task.job_name('/foo/my_job.xml')).to eq 'my_job'
        end
      end
    end
  end
end
