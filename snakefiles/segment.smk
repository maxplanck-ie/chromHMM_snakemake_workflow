rule binarizeBam:
    input: 
        bam_dir = config["input_dir"],
        sample_table = config["cellmarkfiletable"],
        chrom_sizes = config["chrom_sizes"] or "organisms/"+organism+"/chrom_sizes.tsv"
    output: touch("binarizedBams/done.all")
    params:
        out_dir = "binarizedBams"
    envmodules: "chromhmm/1.25"
    log: "logs/binarizeBam.log"
    shell: """
        ChromHMM.sh BinarizeBam -paired {input.chrom_sizes} {input.bam_dir} {input.sample_table} {params.out_dir} 2>{log}
        """

rule segmentBam:
    input:
        binarizedBams = "binarizedBams/done.all"
    output:
        expand("model_{{k}}_output/{group}_{{k}}_segments.bed",group=get_groups(config["cellmarkfiletable"]))
    params:
        num_states = lambda wildcards: wildcards.k,
        genome = organism,
        binarizedBams = "binarizedBams",
        out_dir = "model_{k}_output"
    log: 
        expand("logs/model_{{k}}_{group}_learnModel.log",group=get_groups(config["cellmarkfiletable"]))
    envmodules: "chromhmm/1.25"
    threads: 12
    shell: """
        _JAVA_OPTIONS='-Djava.awt.headless=true' ChromHMM.sh -Xms1g -Xmx10g LearnModel -noautoopen -p {threads} {params.binarizedBams} {params.out_dir} {params.num_states} {params.genome}
        """

