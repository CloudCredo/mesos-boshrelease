require 'yaml'
require 'faraday'
require 'json'
require 'pry'


def mesos_master_state_json
  raw_state = Faraday.get mesos_master_state_endpoint
  JSON.parse(raw_state.body)
end

def active_bosh_manifest_yaml
  erb = ERB.new(File.read(active_bosh_manifest))
  YAML.load(erb.result)
end

private

def active_bosh_manifest
  manifest = File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "manifests/mesos-jenkins-boshlite.yml"))
  raise "File not found: #{manifest}" unless File.exists?(manifest)
  manifest
end

def mesos_master
  "http://10.244.1.6:5050"
end

def mesos_master_state_endpoint
  "#{mesos_master}/master/state.json"
end
