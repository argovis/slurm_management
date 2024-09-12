# CU slurm submission management

This repo contains tools and instructions for managing slurm submissions to our high-priority blanca queue.

## Docs

See [the CU RC docs](https://curc.readthedocs.io/en/latest/clusters/blanca/blanca.html) for full details on using blanca and slurm. This repo is not a substitute for reading these docs.

## Usage

`slurm_submit.sh` will try to submit a slurm job to our group's high priority queue. If the job gets queued, it will kill it and send it to run on another node.

> **Use thoughtfully**: Sending jobs to run on other nodes means they can be killed and restarted with no warning if the owners of those nodes need their resources back. You might be better off just queueing your jobs on our high priority node depending on wait times and on how annoying it would be if your job is killed and restarted on you.

 - Log into a login node in the RC cluster: `ssh username@login.rc.colorado.edu`
 - Import the blanca management module: `module load slurm/blanca`
 - Prepare a regular slurm job script per [the instructions from RC](https://curc.readthedocs.io/en/latest/running-jobs/batch-jobs.html#making-a-job-script), without `--qos`, `--partition`, or `--accounts` flags. An extremely minimal example, `my_job_script.sh`:

```
#!/bin/bash

#SBATCH --time=1:00:00
#SBATCH --job-name=example

module purge

sleep 60
```

- Use `slurm_submit.sh` to manage submission: `bash slurm_submit.sh my_job_script.sh`.
- Your job will be submitted to the high priority queue if it can start there immediately, or the preemptable queue otherwise. Use `squeue -u $USER` to see which of your jobs are running where; `blanca-g4-u12-3` is our node, anything else is preemptable.
- Note from Jacopo:
It seems that by adding 
#SBATCH --export=NONE 
to the .sh job script, matlab on the Blanca node works! 
