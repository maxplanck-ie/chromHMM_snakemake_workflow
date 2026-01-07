################################config files ############################################

configfile: "config/config.yaml"

#######################################################################################

#wildcard_constraints:
#    k = [ str(x) for x in range(config["min_states"],config["max_states"]+1)]
num_states = [ str(x) for x in range(config["min_states"],config["max_states"]+1)]
print(num_states)

organism=config["genome"]

def get_groups(cellmarkfiletable):
    """
    Reads a multi-line text file and collects all unique values from the 
    first field (index 0) of each line, corresponding to cell type.

    The line is split using tab. 
    Empty lines and lines starting with '#' are skipped.

    Args:
        cellmarkfiletable (str): The path to the input cellmark file table.

    Returns:
        set: A set of unique values found in the first field.
    """

    unique_fields = set()
    try:
        with open(cellmarkfiletable, 'r') as f:
            for line in f:
                line = line.strip()
                if not line or line.startswith("#"):
                    continue  # Skip empty lines or comments

                # Split the line by the specified delimiter or whitespace
                fields = line.split('\t')
                # Check if the line has a value in the first field (index 0)
                if fields and fields[0] and fields[0]:
                    unique_fields.add(fields[0])
    except FileNotFoundError:
        print(f"Error: File not found at {cellmarkfiletable}")
        return set()
    except Exception as e:
        print(f"An error occurred while reading the file: {e}")
        return set()
                #
    return unique_fields

include: "snakefiles/organism.smk"
include: "snakefiles/segment.smk"
include: "snakefiles/enrichments.smk"

localrules:
  download_tgz,
  extract_archive


rule all:
    input:
        expand("model_{k}_output/{group}_{k}_segments.bed",k=num_states,group=get_groups(config["cellmarkfiletable"])),
        expand("model_{k}_output/{group}_{k}_state_enrichments.txt",k=num_states,group=get_groups(config["cellmarkfiletable"])),
        expand("model_{k}_output/{group}_{k}_TSS_enrichment.txt",k=num_states,group=get_groups(config["cellmarkfiletable"]))
