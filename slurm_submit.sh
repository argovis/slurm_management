# usage: bash slurm_submit.sh <slurm script>

jobid=$(sbatch --qos=blanca-giglio --account=blanca-giglio --partition=blanca-giglio --parsable $1)

sleep 5
queuereason=$(squeue -u $USER -o "%r %i" | grep $jobid | cut -f 1 -d " ")

if [[ $queuereason = @(Resources|Priority) ]]; then
    scancel $jobid
    lowp=$(sbatch --qos=preemptable $1)
    echo "${lowp} to preemptable queue"
else
    echo "Submitted batch job ${jobid} to high-priority queue"
fi
