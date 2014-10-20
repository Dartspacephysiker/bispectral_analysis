;Bispectrum script
;

data_dir="/daq/bispectral_analysis/data/idl/"
restore,data_dir+'out_wavform.data'

;just do the first thousandth of the whole waveform
n_ensembles=16L
delta_t = 1.0/2500000.0

;num_seg=256
;bicoh_0 = BI_SPECTRUM(wavform_data,dt=delta_t,err=bicoh_err_0,f=bicoh_f_0,Pj=bicoh_pj_0,/img,n_seg=num_seg)
;
;num_seg=1024
;bicoh_1 = BI_SPECTRUM(wavform_data,dt=delta_t,err=bicoh_err_1,f=bicoh_f_1,Pj=bicoh_pj_1,/img,n_seg=num_seg)
;
;num_seg=8192
;bicoh_2 = BI_SPECTRUM(wavform_data,dt=delta_t,err=bicoh_err_2,f=bicoh_f_2,Pj=bicoh_pj_2,/img,n_seg=num_seg)

num_seg=16384L
n_points=LONG(n_ensembles*num_seg)
wav_in=wavform_data[0:n_points-1]
bicoh_3 = BI_SPECTRUM(wav_in,dt=delta_t,err=bicoh_err_3,f=bicoh_f_3,Pj=bicoh_pj_3,/img,n_seg=num_seg)

;save,bicoh_3,bicoh_f_3,bicoh_pj_3,FILENAME=data_dir+"bispectrum_data_340_350_kHz_waves_at_2.5MHz--n_seg16384.idl.data"
;or...
bicoh = bicoh_3 & bicoh_f = bicoh_f_3 & bicoh_pj = bicoh_pj_3 & save, bicoh,bicoh_f,bicoh_pj,$
  FILENAME=data_dir+"bispectrum_data_340_350_kHz_waves_at_2.5MHz--n_seg16384.idl.data"

num_seg=32768
bicoh_4 = BI_SPECTRUM(wavform_data,dt=delta_t,err=bicoh_err_3,f=bicoh_f_3,Pj=bicoh_pj_3,/img,n_seg=num_seg)

save,bicoh_4,bicoh_f_4,bicoh_pj_4,FILENAME="bispectrum_data_340_350_kHz_waves_at_2.5MHz--n_seg32768.idl.data"

;Whoops! Screwed up, had to learn about getting variables outside current scope
;Use PRINT, 'All variables in $MAIN$: ', SCOPE_VARNAME(LEVEL=1)

;bicoh_0_in = SCOPE_VARFETCH('bicoh_0', LEVEL=1)
;bicoh_f_0_in = SCOPE_VARFETCH('bicoh_f_0', LEVEL=1)
;bicoh_pj_0_in = SCOPE_VARFETCH('bicoh_pj_0', LEVEL=1)
;save,bicoh_0_in,bicoh_f_0_in,bicoh_pj_0_in,FILENAME="bispectrum_data_340_350_kHz_waves_at_2.5MHz--n_seg256.idl.data"
;bicoh_1_in = SCOPE_VARFETCH('bicoh_1', LEVEL=1)
;bicoh_f_1_in = SCOPE_VARFETCH('bicoh_f_1', LEVEL=1)
;bicoh_pj_1_in = SCOPE_VARFETCH('bicoh_pj_1', LEVEL=1)
;save,bicoh_1_in,bicoh_f_1_in,bicoh_pj_1_in,FILENAME="bispectrum_data_340_350_kHz_waves_at_2.5MHz--n_seg1024.idl.data"
;bicoh_2_in = SCOPE_VARFETCH('bicoh_2', LEVEL=1)
;bicoh_f_2_in = SCOPE_VARFETCH('bicoh_f_2', LEVEL=1)
;bicoh_pj_2_in = SCOPE_VARFETCH('bicoh_pj_2', LEVEL=1)
;save,bicoh_2_in,bicoh_f_2_in,bicoh_pj_2_in,FILENAME="bispectrum_data_340_350_kHz_waves_at_2.5MHz--n_seg8192.idl.data"


;save,/all,FILENAME="bispectrum_data_340_350_kHz_waves_at_2.5MHz.idl.data"