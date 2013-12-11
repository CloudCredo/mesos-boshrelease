require_relative '../../../lib/jenkins/tasks/install_plugins'

module Jenkins
  module Tasks
    describe InstallPlugins do
      describe '#initialize' do
        it 'does not raise if the list of plugins to install is empty' do
          expect{ InstallPlugins.new({:cli => double,
                                     :plugins => []}) }.not_to raise_error
        end
        it 'takes an enumerable of plugins to install' do
          expect{ InstallPlugins.new({:cli => double,
                                      :plugins => %w{git}}) }.not_to raise_error

        end
        it 'raises if plugins are not specifed' do
          expect{ InstallPlugins.new({:cli => double}) }.to raise_error(
            ArgumentError, 'Plugins must be specified')
        end
        it 'raises if the cli is not specifed' do
          expect{ InstallPlugins.new({:plugins => []}) }.to raise_error(
            ArgumentError, 'CLI must be specified')
        end
      end
      describe '#execute' do
        let(:task) { InstallPlugins.new({:cli => double, :plugins => %w{git}}) }
        it 'does not attempt to install the plugin if it is already installed' do
          expect(task).to receive(:plugins).and_return(%w{git})
          expect(task).not_to receive(:install_plugin).with('git')
          task.execute
        end
        it 'installs the plugin if it is not already installed' do
          expect(task).to receive(:plugins).and_return(%w{svn perforce})
          expect(task).to receive(:install_plugin).with('git')
          task.execute
        end
      end
    end
  end
end
