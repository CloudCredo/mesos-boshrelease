require 'spec_helper'

describe 'Marathon is deployed' do

  let(:marathon_url) { 'http://10.244.1.6:5050/' }

  it 'should should have an accessible homepage' do
    status_code = Faraday.head(marathon_url).status
    expect(status_code).to eq(200)
  end

  it 'should allow jobs to be submitted' do

  end

  private

  def marathon_url
    marathon = active_bosh_manifest_yaml.fetch('jobs').find do |job|
      job.fetch('name') == 'marathon'
    end

    ip = marathon
    .fetch('networks').first
    .fetch('static_ips').first

    "http://#{ip}:8080"
  end

end