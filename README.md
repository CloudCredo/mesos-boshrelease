# Bosh release for Apache Mesos

This is a simple [Bosh][2] release for [Apache Mesos][1]. The release contains four jobs

1. A Mesos master job
2. A Mesos slave 
3. A [Jenkins CI][3] master 
4. A [Marathon][6] job
5. An Apache Storm job

## Usage

To build:

1. Run `git clone https://github.com/cghsystems/bosh-jenkins-mesos`
2. `cd bosh-jenkins-mesos`
3. Run `bosh create release`
4. Run `bosh upload release`
5. Run `bosh deployment manifests/mesos-jenkins-boshlite.yml`
6. Run `bosh deploy`. This stage takes about 15 minutes running on a MacBook Pro running OSX Mavericks with 16gb RAM and an Intel core I7 2.7ghz. The majority of the time is taken up compiling Apache Mesos.
7. Add tests

## Jenkins
Once deployed Jenkins should be available at `http://10.244.1.2` and the Mesos console should be available at `http://10.244.1.2:5050/`. There should be a single registered Mesos slave visible under the `Slaves` tab.

To create a Jenkins job that will run on Mesos add the label 'mesos' to the jobs (configure -> Restrict where this project can run checkbox) that you want to be run on a Jenkins slave launched on Mesos. Test out the connection via the 'Cloud' section under 'Configure Jenkins'

## Marathon
Apache [Marathon][6] should be available at `http://10.244.1.18:8080`

## Road Map

1. ~~Create Zoo Keeper managed Apache Mesos Cluster~~ 
2. Seperate all jobs in to seperate Bosh releases
3. ~~Add Marathon supporti~~
4. Add Chronos support
5. ~~Add Storm support~~ 

## Disclaimer 
This is not presently a production ready Apache Mesos release. This is a work in progress. Please raise any issue to chris@cloudcredo.com

The release has been created and tested against [Bosh Lite][5]i with Bosh client version `BOSH 1.2560.0`. 

[1]: http://mesos.apache.org
[2]: https://github.com/cloudfoundry/bosh
[3]: http://jenkins-ci.org
[4]: https://github.com/jenkinsci/mesos-plugin
[5]: https://github.com/cloudfoundry/bosh-lite
[6]: https://github.com/mesosphere/marathon
