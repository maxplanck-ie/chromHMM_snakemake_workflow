storage:
    provider="http",
    retrieve=False

org_dict={
         "mm10": "https://zenodo.org/records/17533220/files/mm10.tgz",
         "mm39": "https://zenodo.org/records/17828356/files/mm39.tgz",
         "hg38": "https://zenodo.org/records/17550896/files/hg38.tgz"
         }

rule download_tgz:
    input: storage.http(org_dict[organism], keep_local=True)
    output: temp("organisms/" + organism + ".tgz")
    shell: """
            cd organisms && wget {input}
           """

rule extract_archive:
    input: "organisms/" + organism + ".tgz"
    output: "organisms/" + organism + "/input_bed/rmsk.bed",
            "organisms/"+organism+"/chrom_sizes.tsv",
            "organisms/"+organism+"/TSS0.bed"
    params:
        input = organism + ".tgz"
    shell: """
        cd organisms && tar xzvf {params.input}
           """
