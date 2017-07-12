echo "test on RelocaTE2 simulation data"
bash create_data_dir_runner.sh
python Summary_CNVRepeat_Simulation.py --input ./ | sort -k1,1n -k2,2n > example_Chr34.summary.txt

