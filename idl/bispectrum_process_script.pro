;Bispectrum script
;

data_dir="/daq/bispectral_analysis/data/idl/"
;fname='out_wavform.data'
fname='500kHz-10kHz_stationarity_proj/fabdata--500kHz-10kHz--5MHz--multiplied_and_added--halfamp_inputwaves--doubleamp_output.idl.data'
;fname='bispectral_data--L_500kHz-R_10kHz-0.6V--5MHz--SUM.idl.data'
;fname='bispectrum_data_340_350_kHz_waves--5MHzrate--n_seg16384--FABRICATED--halfamp_inputwaves--doubleampmixedwave.idl'
restore,data_dir+fname

;just do the first thousandth of the whole waveform
n_ensembles=6L
samp_rate=5000000.0 ;in Hz
delta_t = 1.0/samp_rate

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
wavform_data=wavform_data[0:n_points-1]
bicoh_3 = BI_SPECTRUM(wavform_data,dt=delta_t,f=bicoh_f_3,Pj=bicoh_pj_3,/img,n_seg=num_seg)

;save,bicoh_3,bicoh_f_3,bicoh_pj_3,FILENAME=data_dir+"bispectrum_data_340_350_kHz_waves--2.5MHz--n_seg16384.idl.data"
;or...
bicoh = bicoh_3 & bicoh_f = bicoh_f_3 & bicoh_pj = bicoh_pj_3 & $
  ;save, bicoh,bicoh_f,bicoh_pj,FILENAME=data_dir+"bispectrum_data_500_10_kHz_waves--0.6V--5MHz--n_seg16384.data"
  save, bicoh,bicoh_f,bicoh_pj,FILENAME=data_dir+"bispectrum_data_500_10_kHz_waves--5MHz--n_seg16384--FABRICATED--halfamp_inputwaves--doubleamp_output.idl.data"
  
;num_seg=32768
;bicoh_4 = BI_SPECTRUM(wavform_data,dt=delta_t,err=bicoh_err_3,f=bicoh_f_3,Pj=bicoh_pj_3,/img,n_seg=num_seg)
;
;save,bicoh_4,bicoh_f_4,bicoh_pj_4,FILENAME="bispectrum_data_340_350_kHz_waves_at_2.5MHz--n_seg32768.idl.data"

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