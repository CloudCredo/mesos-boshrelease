require_relative '../lib/configurator'

module Jenkins
  describe Configurator do

    describe '#initialize' do
      it 'can be instantiated without any options' do
        Configurator.new
      end
      it 'can be instantiated with a list of plugins to install' do
        Configurator.new({:plugins => ['git']})
      end
    end

    describe '#configure' do
      it 'should execute every task' do
        task_one = double
        task_two = double
        expect(task_one).to receive(:execute)
        expect(task_two).to receive(:execute)
        jenkins = Configurator.new
        allow(jenkins).to receive(:tasks).and_return([task_one, task_two])
        jenkins.configure
      end
    end

    describe '#tasks' do
      it 'defines the expected list of tasks' do
        expect(Configurator.new.tasks.map{ |t| t.to_s }).to eq(
          %w{
            create_temp_directory
            add_github_ssh_host_key
            download_cli
            install_plugins
            update_config
            create_jobs
          }
        )
      end
    end

  end
end

