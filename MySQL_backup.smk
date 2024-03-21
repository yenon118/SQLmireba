import sys
import os
import re


#######################################################################
# Inputs
#######################################################################
host = config['host']
username = config['username']
password = config['password']
tables = config['tables']
output_folder = config['output_folder']

#######################################################################
# Check if output parent folder exists
# If not, create the output parent folder
#######################################################################
if not os.path.exists(output_folder):
    try:
        os.makedirs(output_folder, exist_ok = True)
    except FileNotFoundError as e:
        pass
    except FileExistsError as e:
        pass
    except Exception as e:
        pass
    if not os.path.exists(output_folder):
        sys.exit(1)

#######################################################################
# Snakemake managed processes
#######################################################################
rule all:
    input:
        expand(os.path.join(os.path.abspath(output_folder),'{table}.sql'), table=tables),

include: './rules/MySQL/MySQL_backup.smk'
