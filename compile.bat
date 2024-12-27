vlog *.sv
vsim -c -voptargs=+acc tb_processor -do "run -all"