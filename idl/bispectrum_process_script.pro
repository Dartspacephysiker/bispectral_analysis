;Bispectrum script
;
restore,'/daq/bispectral_analysis/data/idl/out_wavform.data'

delta_t = 1.0/2500000.0
num_seg=256
bicoh_0 = BI_SPECTRUM(wavform_data,dt=delta_t,err=bicoh_err_0,f=bicoh_f_0,Pj=bicoh_pj_0,/img,n_seg=num_seg)

num_seg=1024
bicoh_1 = BI_SPECTRUM(wavform_data,dt=delta_t,err=bicoh_err_1,f=bicoh_f_1,Pj=bicoh_pj_1,/img,n_seg=num_seg)

num_seg=8192
bicoh_2 = BI_SPECTRUM(wavform_data,dt=delta_t,err=bicoh_err_2,f=bicoh_f_2,Pj=bicoh_pj_2,/img,n_seg=num_seg)

num_seg=16384
bicoh_3 = BI_SPECTRUM(wavform_data,dt=delta_t,err=bicoh_err_3,f=bicoh_f_3,Pj=bicoh_pj_3,/img,n_seg=num_seg)

save,/all,FILENAME="bispectrum_data_340_350_kHz_waves_at_2.5MHz.data"