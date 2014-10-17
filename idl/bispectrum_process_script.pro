;Bispectrum script
;
restore,'/daq/bispectral_analysis/data/idl/out_wavform.data'

;delta_t = 1.0/2500000.0
;num_seg=256
;bicoh_0 = BI_SPECTRUM(wavform_data,dt=delta_t,err=bicoh_err_0,f=bicoh_f_0,Pj=bicoh_pj_0,/img,n_seg=num_seg)
;
;num_seg=1024
;bicoh_1 = BI_SPECTRUM(wavform_data,dt=delta_t,err=bicoh_err_1,f=bicoh_f_1,Pj=bicoh_pj_1,/img,n_seg=num_seg)
;
;num_seg=8192
;bicoh_2 = BI_SPECTRUM(wavform_data,dt=delta_t,err=bicoh_err_2,f=bicoh_f_2,Pj=bicoh_pj_2,/img,n_seg=num_seg)

num_seg=16384
bicoh_3 = BI_SPECTRUM(wavform_data,dt=delta_t,err=bicoh_err_3,f=bicoh_f_3,Pj=bicoh_pj_3,/img,n_seg=num_seg)

save,bicoh_3_in,bicoh_f_3_in,bicoh_pj_3_in,FILENAME="bispectrum_data_340_350_kHz_waves_at_2.5MHz--n_seg16384.data"

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


;save,/all,FILENAME="bispectrum_data_340_350_kHz_waves_at_2.5MHz.data"