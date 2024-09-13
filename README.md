# q-genomic
1. Navigate to https://www.ebi.ac.uk/gwas/docs/file-downloads and download the following tsv file: All associations v1.0.2 - with added ontology annotations, GWAS Catalog study accession numbers and genotyping technology
2. Store this tsv in a folder called data in the main directory of this repository
3. Run `q makedb.q` to import the data from the GWAS tsv file and create a partitioned database.
4. In a new process, you can now access the data using the functions from the makeapi file.
