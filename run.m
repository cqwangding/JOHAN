addpath('mykit');
clear;

cd experiments
get_Y_coast
run_baselines
run_PA_tra
run_PA_int
run_ORION_tra
run_ORION_int
run_OMuLeT_tra
run_OMuLeT_int
run_JOHAN_tra
run_JOHAN_int
run_JOHAN

cd ..

plot_table
