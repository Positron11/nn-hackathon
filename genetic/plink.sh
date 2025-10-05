
# -------------------------------------------------------------------
# Script: compute_wegovy_scores.sh
# Author: Vineet Karlapalem
# Purpose: Compute composite Wegovy Suitability Scores using PLINK2
# -------------------------------------------------------------------

# Input files
GENO_FILE="SAS_1KG"
EUR_REF="EUR_1KG"

# Target phenotype PRS files
TARGET_FILES=("Adi_Vsc" "BMI_MA" "Hyprt" "T2D")

# Contraindication PRS files
CONTRA_FILES=("CKD" "DiaEye" "GallBlad" "Pancr" "ThyrCarc")

# Output directory
OUTDIR="wegovy_scores"
mkdir -p ${OUTDIR}

for tgt in "${TARGET_FILES[@]}"; do
    plink2 \
        --bfile ${GENO_FILE} \
        --score ${trait}.score 1 2 3 header cols=+scoresums \
        --out ${OUTDIR}/${trait}

    # z normalization
    awk 'NR==1{print $0, "Z_Score"} NR>1{print $0, ($3 - mean)/sd}' \
        mean=$(awk 'NR>1{s+=$3;n++}END{print s/n}' ${OUTDIR}/${trait}.sscore) \
        sd=$(awk -v m=$(awk 'NR>1{s+=$3;n++}END{print s/n}' ${OUTDIR}/${trait}.sscore) 'NR>1{ss+=($3-m)^2;n++}END{print sqrt(ss/n)}' ${OUTDIR}/${trait}.sscore) \
        ${OUTDIR}/${trait}.sscore > ${OUTDIR}/${trait}_zscore.txt
done

for cnt in "${CONTRA_FILES[@]}"; do
    plink2 \
        --bfile ${GENO_FILE} \
        --score ${trait}.score 1 2 3 header cols=+scoresums \
        --out ${OUTDIR}/${trait}

    awk 'NR==1{print $0, "Z_Score"} NR>1{print $0, ($3 - mean)/sd}' \
        mean=$(awk 'NR>1{s+=$3;n++}END{print s/n}' ${OUTDIR}/${trait}.sscore) \
        sd=$(awk -v m=$(awk 'NR>1{s+=$3;n++}END{print s/n}' ${OUTDIR}/${trait}.sscore) 'NR>1{ss+=($3-m)^2;n++}END{print sqrt(ss/n)}' ${OUTDIR}/${trait}.sscore) \
        ${OUTDIR}/${trait}.sscore > ${OUTDIR}/${trait}_zscore.txt
done


# Merge z-scores by IID
paste ${OUTDIR}/*_zscore.txt | awk '
BEGIN {OFS="\t"; print "IID", "Wegovy_Suitability_Score"}
NR>1 {
    # Assign weights to each target and contraindication phenotype
    # Target weights: Adi_Vsc=0.10, BMI_MA=0.60, Hyprt=0.05, T2D=0.25
    # Contra weights: CKD=0.20, DiaEye=0.10, GallBlad=0.15, Pancr=0.15, ThyrCarc=0.25
    target = 0.25*$3 + 0.30*$7 + 0.20*$11 + 0.25*$15
    contra = 0.20*$19 + 0.20*$23 + 0.15*$27 + 0.15*$31 + 0.15*$35 + 0.15*$39
    score = target - contra
    print $1, score
}' > ${OUTDIR}/Wegovy_Suitability_Score.txt

