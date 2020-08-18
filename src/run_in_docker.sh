docker run --rm \
-v $PWD/../gpunit/input:/temp/data \
-v $PWD/../job_1234:/job_1234 \
-w /job_1234 \
-it genepattern/voomnormalize:1.0 \
Rscript /module/run_gp_preprocess_read_counts.R \
--input.file "/temp/data/BRCA_minimal_60x20.gct" \
--cls.file "/temp/data/BRCA_minimal.cls" \
--output.file "test" \
--expression.value.filter.threshold 0
