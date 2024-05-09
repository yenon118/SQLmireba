rule mysql_backup_database:
    params:
        host = host,
        usr = username,
        pw = password,
        db = '{database}',
        out_dir = os.path.abspath(output_folder),
        log_dir = os.path.join(os.path.abspath(output_folder),'log')
    output:
        out_file = os.path.join(os.path.abspath(output_folder),'{database}.sql'),
        out_tmp_dir = temp(directory(os.path.join(os.path.abspath(output_folder),'tmp','{database}')))
    log:
        os.path.join(os.path.abspath(output_folder),'log','{database}.log')
    shell:
        """
        mkdir -p {params.log_dir};
        mkdir -p {params.out_dir};
        mkdir -p {output.out_tmp_dir};

        current_dir=$(pwd);

        mysqldump -h "{params.host}" --user="{params.usr}" --password="{params.pw}" --add-drop-database --add-drop-table --add-drop-trigger --routines --result-file "{output.out_file}" "{params.db}" > {log};

        cd {params.out_dir};
        md5sum {params.db}.sql > {params.db}.sql.md5;
        cd "$current_dir";
        """