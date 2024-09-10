# SQLmireba

<!-- badges: start -->
<!-- badges: end -->

The SQLmireba pipeline is built for database migration supports including data backup, restoration, and more.

## Requirements

In order to run the SQLmireba pipeline, users need to install Miniconda and prepare the Miniconda environment in their computing systems.

The required software, programming languages, and packages include:

```
mysql>=8.3.0
mysqlclient>=2.2.4
snakemake>=8.20.3
```

Miniconda can be downloaded from [https://docs.anaconda.com/free/miniconda/](https://docs.anaconda.com/free/miniconda/).

For example, if users plan to install Miniconda3 Linux 64-bit, the wget tool can be used to download the Miniconda.

```
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
```

To install Miniconda in a server or cluster, users can use the command below.

Please remember to replace the _<installation_shell_script>_ with the actual Miniconda installation shell script. In our case, it is **Miniconda3-latest-Linux-x86_64.sh**.

Please also remember to replace the _<desired_new_directory>_ with an actual directory absolute path.

```
chmod 777 -R <installation_shell_script>
./<installation_shell_script> -b -u -p <desired_new_directory>
rm -rf <installation_shell_script>
```

After installing Miniconda, initialization of Miniconda for bash shell can be done using the command below.

Please also remember to replace the _<desired_new_directory>_ with an actual directory absolute path.

```
<desired_new_directory>/bin/conda init bash
```

Installation of the Miniconda is required, and Miniconda environment needs to be activated every time before running the SQLmireba pipeline.

Write a Conda configuration file (.condarc) before creating a Conda environment:

```
nano ~/.condarc
```

Put the following text into the Conda configuration file (make sure you change _envs_dirs_ and _pkgs_dirs_) then save the file.

Please make sure not use tab in this yaml file, use 4 spaces instead.

Please make sure to replace _/new/path/to/_ with an actual directory absolute path.

```
envs_dirs:
    - /new/path/to/miniconda/envs
pkgs_dirs:
    - /new/path/to/miniconda/pkgs
channels:
    - conda-forge
    - bioconda
    - defaults
```

Create a Conda environment by specifying all required packages (option 1).

Please make sure to replace the _<conda_environment_name>_ with an environment name of your choice.

```
conda create -n <conda_environment_name> \
conda-forge::mysql conda-forge::mysqlclient \
bioconda::snakemake bioconda::snakemake-executor-plugin-cluster-generic
```

Create a Conda environment by using a yaml environment file (option 2).

Please make sure to replace the _<conda_environment_name>_ with an environment name of your choice.

```
conda create --name <conda_environment_name> --file SQLmireba-environment.yml
```

Create a Conda environment by using a explicit specification file (option 3).

Please make sure to replace the _<conda_environment_name>_ with an environment name of your choice.

```
conda create --name <conda_environment_name> --file SQLmireba-spec-file.txt
```

Activate Conda environment using conda activate command.

This step is required every time before running SQLmireba pipeline.

Please make sure to replace the _<conda_environment_name>_ with an environment name of your choice.

```
conda activate <conda_environment_name>
```

## Installation

You can install the SQLmireba from [Github](https://github.com/yenon118/SQLmireba.git) with:

```
git clone https://github.com/yenon118/SQLmireba.git
```

## Usage

#### Write a configuration file in json format

Please checkout files ends with _inputs.json to write different json files for different purposes.

#### Run workflow with the Snakemake workflow management system

```
snakemake -j NUMBER_OF_JOBS --configfile CONFIGURATION_FILE --snakefile SNAKEMAKE_FILE

Mandatory Positional Argumants:
    NUMBER_OF_JOBS                          - the number of jobs
    CONFIGURATION_FILE                      - a configuration file
    SNAKEMAKE_FILE                          - the MySQL_backup.smk file that sit inside this repository
```

## Examples

Below are some fundamental examples illustrating the usage of the SQLmireba pipeline.

Please adjust _/path/to/_ to an actual directory absolute path.

**Examples of running without an executor.**

```
cd /path/to/SQLmireba

snakemake -pj 3 --configfile MySQL_backup_table_inputs.json --snakefile MySQL_backup_table.smk
```

**Examples of running with an executor.**

Snakemake version >= 8.0.0.

```
cd /path/to/SQLmireba

snakemake --executor cluster-generic \
--cluster-generic-submit-cmd "sbatch --account=xulab --time=0-02:00 \
--nodes=1 --ntasks=1 --cpus-per-task=3 \
--partition=Lewis,BioCompute,hpc5,General --mem=64G" \
--jobs 25 --latency-wait 60 \
--configfile MySQL_backup_table_inputs.json \
--snakefile MySQL_backup_table.smk
```

Snakemake version < 8.0.0.

```
cd /path/to/SQLmireba

snakemake --cluster "sbatch --account=xulab --time=0-02:00 \
--nodes=1 --ntasks=1 --cpus-per-task=3 \
--partition=Lewis,BioCompute,hpc5,General --mem=64G" \
--jobs 25 --latency-wait 60 \
--configfile MySQL_backup_table_inputs.json \
--snakefile MySQL_backup_table.smk
```