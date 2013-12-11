require_relative '../../../lib/jenkins/tasks/update_config'

module Jenkins
  module Tasks
    describe UpdateConfig do
      describe '#initialize' do
        it 'can be instantiated with the store directory and job_dir' do
          UpdateConfig.new({:store_dir => '/var/vcap/store/jenkins_master',
                            :job_dir => '/var/vcap/jobs/jenkins_master',
                            :cli => double})
        end
        it 'raises if no directories are provided' do
          expect{ UpdateConfig.new(nil) }.to raise_error(ArgumentError,
            'Store directory must be provided')
        end
        it 'raises if the store directory is not provided' do
          expect{ UpdateConfig.new(
            {:job_dir => '/var/vcap/jobs/jenkins_master', :cli => double}) }.to raise_error(
              ArgumentError, 'Store directory must be provided')
        end
        it 'raises if the job directory is not provided' do
          expect{ UpdateConfig.new(
            {:store_dir => '/var/vcap/store/jenkins_master', :cli => double}) }.to raise_error(
              ArgumentError, 'Job directory must be provided')
        end
        it 'raises if the cli is not provided' do
          expect{ UpdateConfig.new(
            {:job_dir => '/var/vcap/jobs/jenkins_master',
             :store_dir => '/var/vcap/store/jenkins_master'}) }.to raise_error(
              ArgumentError, 'CLI must be provided')
        end
      end

      context(:config_paths) do
        let(:task) do
          UpdateConfig.new({:store_dir => '/var/lib/foo',
                            :job_dir => '/var/lib/baz',
                            :cli => double})
        end
        describe '#existing_config_path' do
          it 'is under the store directory' do
            expect(task.existing_config_path).to eq('/var/lib/foo/config.xml')
          end
        end
        describe '#src_config_path' do
          it 'is under the job directory' do
            expect(task.src_config_path).to eq('/var/lib/baz/config/config.xml')
          end
        end

      end

      describe '#execute' do
        let(:task) do
          UpdateConfig.new({:store_dir => '/var/lib/foo',
                            :job_dir => '/var/lib/baz',
                            :cli => double})
        end
        it 'takes no action if the config is already at the current version' do
          expect(task).to receive(:config_version).with('/var/lib/foo/config.xml').and_return('0.1.0')
          expect(task).to receive(:config_version).with('/var/lib/baz/config/config.xml').and_return('0.1.0')
          expect(task).not_to receive(:copy_config_into_place)
          expect(task).not_to receive(:restart_jenkins)
          task.execute
        end
        it 'copies the config over if the config is changed' do
          expect(task).to receive(:config_version).with('/var/lib/foo/config.xml').and_return('0.1.0')
          expect(task).to receive(:config_version).with('/var/lib/baz/config/config.xml').and_return('0.1.1')
          expect(task).to receive(:copy_config_into_place)
          allow(task).to receive(:restart_jenkins)
          task.execute
        end
        it 'restarts jenkins if the config is changed' do
          expect(task).to receive(:config_version).with('/var/lib/foo/config.xml').and_return('0.1.0')
          expect(task).to receive(:config_version).with('/var/lib/baz/config/config.xml').and_return('0.1.1')
          allow(task).to receive(:copy_config_into_place)
          expect(task).to receive(:restart_jenkins)
          task.execute
        end

      end

      describe '#config_version' do
        let(:task) do
          UpdateConfig.new({:store_dir => '/var/lib/foo',
                            :job_dir => '/var/lib/baz',
                            :cli => double})
        end
        it 'retrieves the config version from within the jenkins config' do
          config_path = '/var/lib/foo/config.xml'
          allow(File).to receive(:readable?).with(config_path).and_return(true)
          allow(File).to receive(:read).with(config_path).and_return(%q{
            <hudson><systemMessage>Pivotal Jenkins 0.1.0</systemMessage></hudson>
          }.strip)
          expect(task.config_version(config_path)).to eq 'Pivotal Jenkins 0.1.0'
        end
        it 'returns nil if the config file is not readable' do
          config_path = '/var/lib/foo/config.xml'
          allow(File).to receive(:readable?).with(config_path).and_return(false)
          expect(task.config_version(config_path)).to be_nil
        end
        it 'returns nil if the version is not in the jenkins config' do
          config_path = '/var/lib/foo/config.xml'
          allow(File).to receive(:readable?).with(config_path).and_return(true)
          allow(File).to receive(:read).with(config_path).and_return('<hudson/>')
          expect(task.config_version(config_path)).to be_nil
        end
      end
   end
  end
end
