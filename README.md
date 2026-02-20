# docker_demo

Get overlay on torch
```bash
cp /share/apps/overlay-fs-ext3/overlay-0.1GB-25K.ext3.gz /scratch/wlp9800/my-image.ext3.gz && gunzip /scratch/wlp9800/my-image.ext3.gz
```

Then image from docker
```bash
sbatch --job-name=run_my-image --nodes=1 --ntasks=1 --mem=24G --time=06:00:00 --cpus-per-task=4 --output=/scratch/wlp9800/run-my-image-%j.log --error=/scratch/wlp9800/run-my-image-%j.err --wrap="singularity run --fakeroot --containall --no-home --cleanenv --overlay /scratch/wlp9800/my-image.ext3:rw --bind /home/wlp9800/.ssh:/root/.ssh docker://thewillyp/my-image"
```

