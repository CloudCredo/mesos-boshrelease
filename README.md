# Bosh release for Apache Mesos

This is a simple [Bosh][2] release for [Apache Mesos][1]. It is designed to showcase Apache Mesos deployments with Bosh. The example release illustrates Mesos functionality by spinning up [Jenkins CI][3] slave jobs within an Apache Mesos cluster. The release contains three jobs

1. A Mesos master job
2. A Mesos slave 
3. A Jenkins master 

The release runs [Apache Mesos][1] version 0.14. Jenkins is configured with the [Jenkins CI Mesos plugin][4]. The plugin was built from source as the published Jenkins plugin for Apache Mesos does not work against version 0.14.

## Usage

To build:

1. Run `git clone https://github.com/cghsystems/bosh-jenkins-mesos`
2. `cd bosh-jenkins-mesos`
3. Run `bosh create release`
4. Run `bosh upload release`
5. Run `bosh deploy`. This stage takes about 15 minutes running on a MacBook Pro running OSX Mavericks with 16gb RAM and an Intel core I7 2.7ghz. The majority of the time is taken up compiling Apache Mesos.

Once deployed Jenkins should be available at `http://10.244.1.2` and the Mesos console should be available at `http://10.244.1.2:5050/`. There should be a single registered Mesos slave visible under the `Slaves` tab.

To create a Jenkins job that will run on Mesos add the label 'mesos' to the jobs (configure -> Restrict where this project can run checkbox) that you want to be run on a Jenkins slave launched on Mesos

## Road Map

~~1. Create Zoo Keeper managed Apache Mesos Cluster~~
2. Seperate Jenkins and Mesos jobs into separate releases
3. Add Marathon support
4. Add Chronos support

## Disclaimer 
This is not presently a production ready Apche Mesos release. This is a work in progress. Please raise any issue to chris@cloudcredo.com

The release has been created and tested against [Bosh Lite][5]. 

[1]: http://mesos.apache.org
[2]: https://github.com/cloudfoundry/bosh
[3]: http://jenkins-ci.org
[4]: https://github.com/jenkinsci/mesos-plugin
[5]: https://github.com/cloudfoundry/bosh-lite
