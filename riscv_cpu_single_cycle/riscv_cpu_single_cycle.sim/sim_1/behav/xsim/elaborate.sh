#!/bin/bash -f
# ****************************************************************************
# Vivado (TM) v2019.1 (64-bit)
#
# Filename    : elaborate.sh
# Simulator   : Xilinx Vivado Simulator
# Description : Script for elaborating the compiled design
#
# Generated by Vivado on Tue Apr 27 12:29:38 UTC 2021
# SW Build 2552052 on Fri May 24 14:47:09 MDT 2019
#
# Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
#
# usage: elaborate.sh
#
# ****************************************************************************
set -Eeuo pipefail
echo "xelab -wto a823a68f7a984c7598a78ae3d7c5abd2 --incr --debug typical --relax --mt 8 -L dist_mem_gen_v8_0_13 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -L xpm --snapshot cpu_behav xil_defaultlib.cpu xil_defaultlib.glbl -log elaborate.log"
xelab -wto a823a68f7a984c7598a78ae3d7c5abd2 --incr --debug typical --relax --mt 8 -L dist_mem_gen_v8_0_13 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -L xpm --snapshot cpu_behav xil_defaultlib.cpu xil_defaultlib.glbl -log elaborate.log

