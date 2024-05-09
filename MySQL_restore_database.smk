import sys
import os
import re


#######################################################################
# Inputs
#######################################################################
host = config['host']
username = config['username']
password = config['password']
files = config['files']
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
# Extract information
#######################################################################
databases = []
input_folder = ''
input_extension = ''

for i in range(len(files)):
    if os.path.dirname(files[i]) != input_folder:
        input_folder = os.path.dirname(files[i])
    possible_database = re.sub('\\.[^\\.]*$', '', str(os.path.basename(files[i])))
    if not possible_database in databases:
        databases.append(possible_database)
    possible_extension = re.sub(possible_database,'',str(os.path.basename(files[i])))
    if possible_extension != input_extension:
        input_extension = possible_extension

#######################################################################
# Snakemake managed processes
#######################################################################
rule all:
    input:
        expand(os.path.join(os.path.abspath(output_folder),'log','{database}.log'), database=databases),

include: './rules/MySQL/MySQL_restore_database.smk'
