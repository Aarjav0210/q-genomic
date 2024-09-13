
\l utils.q
\l db

// ----------------- 1. Get all Diseases/Traits ----------------- 
getAllDiseasesAndTraits: {
    select distinct DISEASE_OR_TRAIT from disAsTa
 }


// ----------------- Uncomment this to test the functions  ----------------- 
/ getAllDiseasesAndTraits[]


// ----------------- 2. Identify the key SNPs for Disease/Trait ----------------- 
identifyKeySNPs: {
    colsToGet: getColsDict (enlist "DISEASE_OR_TRAIT"), (enlist "STRONGEST SNP-RISK ALLELE"), (enlist "SNPS"), (enlist "PVALUE_MLOG");
    `PVALUE_MLOG xdesc ?[`disAsTa; (); 0b; colsToGet]
 }



identifyKeySNPsFor:{[disease_or_trait]
    if[(type disease_or_trait) <> -11h;
        :`typeError
    ];
    if[(not disease_or_trait in (value exec distinct DISEASE_OR_TRAIT from select from disAsTa));
        :`DiseaseNotFoundError
    ];
    select from identifyKeySNPs[] where DISEASE_OR_TRAIT = disease_or_trait
 }


// ----------------- Uncomment this to test the functions  ----------------- 
/ identifyKeySNPs[]
/ identifyKeySNPsFor[`$"Parkinson's disease"]

/ identifyKeySNPsFor[first 1?(value exec distinct DISEASE_OR_TRAIT from select from disAsTa)]



// ----------------- 3. Map SNPs to Genes ----------------- 
mapSNPsToGenes: {
    colsToGet: getColsDict (enlist "DISEASE_OR_TRAIT"), (enlist "STRONGEST SNP-RISK ALLELE"), (enlist "SNPS"), (enlist "PVALUE_MLOG"), (enlist "SNP_GENE_IDS"), (enlist "UPSTREAM_GENE_ID"), (enlist "DOWNSTREAM_GENE_ID"), (enlist "MAPPED_GENE");
    maxPValues: select maxPValue: max PVALUE_MLOG by DISEASE_OR_TRAIT from disAsTa;
    ?[select from (select from disAsTa) lj maxPValues where PVALUE_MLOG = maxPValue; (); 0b; colsToGet]
 }

mapSNPsToGenesFor: {[disease_or_trait]
    if[(type disease_or_trait) <> -11h;
        :`typeError
    ];
    if[(not disease_or_trait in (value exec distinct DISEASE_OR_TRAIT from select from disAsTa));
        :`DiseaseNotFoundError
    ];
    disease2Gene: mapSNPsToGenes[];
    select from disease2Gene where DISEASE_OR_TRAIT = disease_or_trait
 }


// ----------------- Uncomment this to test the functions  ----------------- 
/ mapSNPsToGenes[]
/ mapSNPsToGenesFor[first 1?(value exec distinct DISEASE_OR_TRAIT from select from disAsTa)]


// Get OR ratios for each SNP ::: How much more likely a person with a particular SNP or allele is to develop the disease compared to someone without it
getAssociatedRisk: {
    getData[`disAsTa; 0b; getColsDict((enlist "DISEASE_OR_TRAIT"), (enlist "STRONGEST SNP-RISK ALLELE"), (enlist "MAPPED_GENE"), (enlist "PVALUE_MLOG"), (enlist "OR or BETA"), (enlist "95% CI (TEXT)"))]
 }

getAssociatedRiskFor: {[disease_or_trait]
    if[(type disease_or_trait) <> -11h;
        :`typeError
    ];
    if[(not disease_or_trait in (value exec distinct DISEASE_OR_TRAIT from select from disAsTa));
        :`DiseaseNotFoundError
    ];
    ?[getAssociatedRisk[];enlist (=;`DISEASE_OR_TRAIT;enlist disease_or_trait);0b;()]
 }


// ----------------- Uncomment this to test the functions  ----------------- 
/ getAssociatedRisk[]
/ getAssociatedRiskFor[first 1?(value exec distinct DISEASE_OR_TRAIT from select from disAsTa)]

