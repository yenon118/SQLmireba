rule mysql_backup:
    params:
        host = host,
        usr = username,
        pw = password,
        db_tbl = '{table}',
        db = lambda w: re.sub("\\..*", "", w.table),
        tbl = lambda w: re.sub(".*\\.", "", w.table),
        out_dir = os.path.abspath(output_folder),
        log_dir = os.path.join(os.path.abspath(output_folder),'log')
    output:
        out_file = os.path.join(os.path.abspath(output_folder),'{table}.sql'),
        out_tmp_dir = temp(directory(os.path.join(os.path.abspath(output_folder),'tmp','{table}')))
    log:
        os.path.join(os.path.abspath(output_folder),'log','{table}.log')
    shell:
        """
        mkdir -p {params.log_dir};
        mkdir -p {params.out_dir};
        mkdir -p {output.out_tmp_dir};

        current_dir=$(pwd);

        mysqldump -h "{params.host}" --user="{params.usr}" --password="{params.pw}" --add-drop-table --routines --result-file "{output.out_file}" "{params.db}" "{params.tbl}" > {log};

        cd {params.out_dir};
        md5sum {params.db_tbl}.sql > {params.db_tbl}.sql.md5;
        cd "$current_dir";
        """