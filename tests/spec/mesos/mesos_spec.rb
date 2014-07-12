require 'spec_helper'

describe 'Apache Mesos Bosh release' do

  let(:mesos_url) { 'http://10.244.1.6:5050/' }

  context 'Mesos UI is configured to run' do

    it 'should should have an accessible homepage' do
      status_code = Faraday.head(mesos_url).status
      expect(status_code).to eq(200)
    end

    it 'the master is healthy' do
      health_endpoint = "#{mesos_url}/master/health"
      status_code = Faraday.head(health_endpoint).status
      expect(status_code).to eq(200)
    end

    it 'should have the correct number of activated slaves' do
      activeated_slaves_count = mesos_master_state_json.fetch('activated_slaves')
      expect(activeated_slaves_count).to eq(expected_activated_slave_count)
    end

  end

  private

  def expected_activated_slave_count
    job = active_bosh_manifest_yaml.fetch('jobs').find do |job|
      job.fetch('name') == 'mesos-slave'
    end
    job.fetch('instances')
  end

end