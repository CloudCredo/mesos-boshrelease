require_relative '../../../lib/jenkins/tasks/add_ssh_known_hosts'

module Jenkins
  module Tasks
    describe AddSshKnownHosts do

      describe '#initialize' do
        it 'raises if the path to known_hosts is not specified' do
          expect { AddSshKnownHosts.new(nil, []) }.to raise_error(ArgumentError,
            'Path to known_hosts must be specified')
        end
        it 'raises if the known hosts entries are not specified' do
          expect { AddSshKnownHosts.new("known_hosts", nil) }.to raise_error(ArgumentError,
            'Known hosts entries must be specified')
        end
      end

      describe "#execute" do
        before do
          allow(Dir).to receive(:exists?).with('/home/vcap/.ssh').and_return(true)
          allow(File).to receive(:readable?).and_return(true)
          allow(IO).to receive(:readlines).with(
            '/home/vcap/.ssh/known_hosts').and_return(
            StringIO.new("github.com ssh-rsa AAAA\nexample.com ssh-rsa BBBB"))
        end
        let(:task) { AddSshKnownHosts.new('/home/vcap/.ssh/known_hosts', { "github.com" => "github.com ssh-rsa zzzzQWAaQ==" }) }
        context :ssh_directory do
          it 'creates the parent .ssh directory if it does not already exist' do
            expect(Dir).to receive(:exists?).with('/home/vcap/.ssh').and_return(false)
            expect(Dir).to receive(:mkdir).with('/home/vcap/.ssh', 0700)
            task.execute
          end
          it 'does not try to create the parent directory if it does already exist' do
            expect(Dir).to receive(:exists?).with('/home/vcap/.ssh').and_return(true)
            expect(Dir).not_to receive(:mkdir)
            task.execute
          end
        end
        context :known_hosts do
          it 'does not add the github ssh key to known hosts if it is already present' do
            expect(IO).to receive(:readlines).with(
              '/home/vcap/.ssh/known_hosts').and_return(
                StringIO.new("github.com ssh-rsa AAAA\nexample.com ssh-rsa BBBB"))
            expect(File).not_to receive(:open)
            task.execute
          end
          it 'adds the github ssh key to known hosts if it is not already present' do
            expect(IO).to receive(:readlines).with(
              '/home/vcap/.ssh/known_hosts').and_return(
                StringIO.new("example.org ssh-rsa AAAA\nexample.com ssh-rsa BBBB"))
            expect(File).to receive(:open).with('/home/vcap/.ssh/known_hosts', 'a')
            task.execute
          end
          it 'pads the host key with newlines to ensure the file is formatted correctly' do
            expect(IO).to receive(:readlines).with(
              '/home/vcap/.ssh/known_hosts').and_return(
                StringIO.new("example.org ssh-rsa AAAA\nexample.com ssh-rsa BBBB"))
            file = double(File)
            expect(file).to receive(:write).with(/\ngithub.com.*AaQ==\n/)
            expect(File).to receive(:open).with(
              '/home/vcap/.ssh/known_hosts', 'a').and_yield(file)
            task.execute
          end
        end
      end

    end
  end
end
