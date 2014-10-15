#!/bin/bash

#10/09/2014
#David's experimental setup
#340 kHz on HP3325A @ 0.6V teed to o-scope and mixer
#350 kHz on HP3324A @ 0.6V teed to o-scope and mixer
#HP 10514A passive mixer with teed input signals; the output signal runs through a 
# 4.85-MHz TTE passive anti-aliasing filter and is terminated with 50 ohms
#O-scope is set for high-impedance input

#This script is for acquiring a signal from the experimental setup described above.

#sudo /usr/src/acq_c/acq_c -n 1 -F 10000000 -d 0.5 -m /tmp/rtd/latest_acquisition.data
#sudo /daq/acq_c/acq_c -n 1 -F 10000000 -o /daq/biz.data -d 0.5 -m /tmp/rtd/latest_acquisition.data

#10/13/2014
#Accidentally deleted data.... foolish. Reacquired as necessary.

#10/11/2014
#RUN 1
#CH 1/L: HP3324A @ 350kHZ, 0.6Vpp, teed
#CH 2/R: HP3325A @ 340kHZ, 0.6Vpp, teed
#CH 3/X: HP10514A passive mixer, teed inputs
#Sample freq 2.5MHz
#digitization buffer @ 65536

#RUN 2
#CH 1/L: HP3324A @ 35kHZ, 0.6Vpp, teed
#CH 2/R: HP3325A @ 34kHZ, 0.6Vpp, teed
#CH 3/X: HP10514A passive mixer, teed inputs
#Sample freq 1MHz
#digitization buffer @ 65536

#RUN 3
#CH 1/L: HP3324A @ 3.5kHZ, 0.6Vpp, teed                                                                                                                      
#CH 2/R: HP3325A @ 3.4kHZ, 0.6Vpp, teed
#CH 3/X: HP10514A passive mixer, teed inputs
#Sample freq 100kHz
#digitization buffer @ 8192


DATA_DIR="/daq/bispectral_analysis/data/"

echo "Get ready to get bispectral..."

if sudo comedi_config --read-buffer 65536 /dev/comedi0 && sudo comedi_test -s0 /dev/comedi0 
then
    echo "Comedi_configged and tested. You're in the money."
    #sudo /usr/src/acq_c/acq_c -r 0000 -n 4 -F 2500000 -d 0.5 -m /tmp/rtd/rtd_digitizer.data -o ${DATA_DIR}/bispectral_data--L_175kHz-R_170kHz-0.6V--2.5MHz.data
    sudo /usr/src/acq_c/acq_c -r 0000 -n 4 -F 1000000 -d 0.5 -m /tmp/rtd/rtd_digitizer.data -o ${DATA_DIR}/bispectral_data--L_35kHz-R_34kHz-0.6V--1MHz.data
    #sudo /usr/src/acq_c/acq_c -r 0000 -n 4 -F 100000 -d 0.5 -m /tmp/rtd/rtd_digitizer.data -o ${DATA_DIR}/bispectral_data--L_3.5kHz-R_3.4kHz-0.6V--kHz.data
else
    echo "Couldn't [comedi_]config your DAQ card! Laterz..."
fi
