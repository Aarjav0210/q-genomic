// ----------------- 1. Prepare data  ----------------- 

//Load functions from utils.q
show "Loading utils.q";
\l utils.q
show "Complete";

// Data paths
GWAS_DATA_PATH : `$":data/gwas_catalog_v1.0.2-associations_e112_r2024-08-12.tsv";

disAsTa:("DJSDS**S*S*JSSSSSSJJSSJJSBF*F*F*SSS*SS";enlist"\t")0: GWAS_DATA_PATH;
disAsTa: selectByColIndex[disAsTa; (til 38) except 5 35]; // Remove url columns 

update year: `year$DATE from `disAsTa; // Store year from DATE column in a new year column
disAsTa: `year xasc disAsTa; //Sorts in ascending order
update year: `p#year from `disAsTa; // Add sorted attribute to year column
show "Complete";

// Store as HDB
show "Generating HDB";
dbPath: `:db;
.Q.en[dbPath; disAsTa];
years: exec distinct year from disAsTa;
pathGen: {`$ raze (":db/", string x, "/disAsTa/")};
getDataByYear: {select from .Q.en[dbPath; disAsTa] where year = x};
{(pathGen x) set getDataByYear x} each years;
show "Complete";
