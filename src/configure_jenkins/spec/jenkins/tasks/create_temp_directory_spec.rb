require_relative '../../../lib/jenkins/tasks/create_temp_directory'

module Jenkins
  module Tasks
    describe CreateTempDirectory do

      describe '#initialize' do
        it 'raises if the store directory is not specified' do
          expect { CreateTempDirectory.new(nil) }.to raise_error(ArgumentError, 'Store directory must be specified')
        end
      end

      describe '#execute' do
        let(:task) { CreateTempDirectory.new('/var/vcap/store/jenkins_master') }
        it 'creates a separate temp directory for jenkins to use with sufficient space' do
          expect(Dir).to receive(:exists?).with('/var/vcap/store/jenkins_master').and_return(true)
          expect(FileUtils).to receive(:mkdir_p).with('/var/vcap/store/jenkins_master/tmp')
          task.execute
        end
        it 'does not create the temp directory if the store directory is not present' do
          expect(Dir).to receive(:exists?).with('/var/vcap/store/jenkins_master').and_return(false)
          expect(FileUtils).not_to receive(:mkdir_p)
          task.execute
        end
      end

    end
  end
end
