sudo /usr/src/Core-FFT/core-fft.py -X 200 -n 4 --ngdef -F 2500000 -N 1024 /daq/bispectral_analysis/data/bispectral_data--L_350kHz-R_340kHz-0.6V--2.5MHz.data /daq/bispectral_analysis/data/processed/bispectral_data--L_350kHz-R_340kHz-0.6V--2.5MHz

#For doing the summed waveform
[ "$1" = "DO_SUM" ] && sudo /usr/src/Core-FFT/core-fft.py -n 1 --ngdef -F 2500000 -N 1024 /daq/bispectral_analysis/utils/bispectral_data--L_350kHz-R_340kHz-0.6V--2.5MHz--SUM.data /daq/bispectral_analysis/data/processed/bispectral_data--L_350kHz-R_340kHz-0.6V--2.5MHz--SUM
