# Bosh release for Jenkins

One of the fastest ways to get [Jenkins](http://jenkins-ci.org/) running on any infrastructure is too deploy this bosh release.

## Usage

To use this bosh release, first upload it to your bosh:

```
bosh target BOSH_URL
bosh login
git clone https://bitbucket.org/cloudcredo/cloudcredo-jenkins-development-pipeline
cd cloudcredo-jenkins-development-pipeline
bosh upload release releases/jenkins-1.yml
```

You can now view Jenkins in your browser at http://172.16.13.11/

Additional steps:

1. ssh onto Jenkins box and add id_rsa and id_rsa.pub to 
2. add entries to known hosts by typing `ssh -t git@bitbucket.org` and type `yes` at the prompt. This adds a known 
hosts entry to /home/vcap/.ssh/known_hosts

There is no guarantee that the bitbucket hosts in use for ssh git retrieval will remain constant, and the above step 2
may be necessary if the job shows the following error:

Failed to connect to repository : Command "ls-remote -h git@bitbucket.org:cloudcredo/cassandra-as-a-service.git HEAD" returned status code 128:
stdout:
stderr: Host key verification failed.
fatal: The remote end hung up unexpectedly
