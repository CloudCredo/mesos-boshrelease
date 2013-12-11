require_relative '../../../lib/jenkins/tasks/download_cli'

module Jenkins
  module Tasks
    describe DownloadCli do
      describe '#execute' do
        let(:task) { DownloadCli.new }
        let(:response) do
          response = double(Net::HTTPResponse)
          allow(response).to receive(:code).and_return('200')
          allow(response).to receive(:body).and_return('')
          response
        end
        before do
          allow(Net::HTTP).to receive(:get_response).with('localhost', '/jnlpJars/jenkins-cli.jar').and_return(response)
          allow(Dir).to receive(:tmpdir).and_return('/tmp')
        end
        it 'fetches the jenkins cli jar' do
          expect(Net::HTTP).to receive(:get_response).with('localhost', '/jnlpJars/jenkins-cli.jar').and_return(response)
          task.execute
        end
        it 'raises if the download response is a 500' do
          error_response = double(Net::HTTPResponse)
          allow(error_response).to receive(:code).and_return('500')
          allow(error_response).to receive(:body).and_return('Internal server error')
          allow(Net::HTTP).to receive(:get_response).with('localhost', '/jnlpJars/jenkins-cli.jar').and_return(error_response)
          expect{ task.execute }.to raise_error('Unable to download cli')
        end
        it 'writes the cli jar to a local temporary path' do
          expect(Dir).to receive(:tmpdir).and_return('/tmp')
          task.execute
        end
        it 'returns the path to the downloaded cli' do
          expect(task.execute).to eq '/tmp/jenkins-cli.jar'
        end
      end
    end
  end
end
