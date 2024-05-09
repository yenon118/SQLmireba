rule mysql_restore_database:
    input:
        in_file = os.path.join(os.path.abspath(input_folder),'{database}'+input_extension),
    params:
        host = host,
        usr = username,
        pw = password,
        db = '{database}',
        out_dir = os.path.join(os.path.abspath(output_folder),'log')
    output:
        out_file = os.path.join(os.path.abspath(output_folder),'log','{database}.log'),
        out_tmp_dir = temp(directory(os.path.join(os.path.abspath(output_folder),'tmp','{database}')))
    shell:
        """
        mkdir -p {params.out_dir};
        mkdir -p {output.out_tmp_dir};

        mysql -h "{params.host}" --user="{params.usr}" --password="{params.pw}" -e "CREATE DATABASE IF NOT EXISTS {params.db};"
        mysql -h "{params.host}" --user="{params.usr}" --password="{params.pw}" "{params.db}" < {input.in_file} > {output.out_file};
        """