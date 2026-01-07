import os
import re

rule overlapEnrichment:
    input: "model_{k}_output/{group}_{k}_segments.bed",
           config["input_bed"] or "organisms/"+organism+"/input_bed/rmsk.bed"
    output: "model_{k}_output/{group}_{k}_state_enrichments.txt"
    params:
        prefix = "model_{k}_output/{group}_{k}_state_enrichments",
        input_bed = subpath(input[1],parent=True)
    envmodules: "chromhmm/1.25"
    shell: """
        _JAVA_OPTIONS='-Djava.awt.headless=true' ChromHMM.sh -Xms1g -Xmx10g OverlapEnrichment {input[0]} {params.input_bed} {params.prefix}
        """

rule neighbourhoodEnrichment:
    input: "model_{k}_output/{group}_{k}_segments.bed",
        config["TSS_bed"] or "organisms/"+organism+"/TSS0.bed"
    output: "model_{k}_output/{group}_{k}_TSS_enrichment.txt"
    params:
        prefix = "model_{k}_output/{group}_{k}_TSS_enrichment"
    envmodules: "chromhmm/1.25"
    shell: """
        _JAVA_OPTIONS='-Djava.awt.headless=true' ChromHMM.sh -Xms1g -Xmx10g NeighborhoodEnrichment {input[0]} {input[1]} {params.prefix}
        """

#rule done_all:
#    input: expand("model_{k}_output/{group}_TSS_enrichment.txt",k=num_states,group=get_groups()),
#        expand("model_{k}_output/{group}_state_enrichments.txt",k=num_states,group=get_groups())
#    output: touch("done.all")
