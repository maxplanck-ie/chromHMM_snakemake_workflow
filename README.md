# chromHMM_snakemake_workflow

To create the main conda environment, run ```mamba env create -f env.yaml```.
After activating the environment and updating the config file, run workflow with:
```snakemake --profile profiles/cluster``` . This will allow for cluster execution. Running ```snakemake --profile profiles/local``` will make the workflow run locally.

The organism is set in the config file under configs/config.yaml. Annotation files can be pointed to in the config as well, else they will be fetched from zenodo. Currently, mm10, mm39 and hg38 are supported.
