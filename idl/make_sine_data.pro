;Script for making fake data

;data product variables
sample_rate = 5000000
n_ensembles=16L
n_ppe=16384L ;number of points per ensemble
m=n_ensembles*n_ppe

dt=1./sample_rate

;waveform variables
twopi=!DPI*2.0
f1=500000 ;in Hz
f2=10000 ;in Hz

;output variables
data_dir="/daq/bispectral_analysis/data/idl/"
outfname="fabdata--" + STRCOMPRESS(string(f1/1000) + "kHz-" + STRING(f2/1000) + "kHz--" + $
            string(sample_rate/1000000) + "MHz--" + "multiplied_and_added--halfamp_inputwaves--doubleamp_output.idl.data",/REMOVE_ALL)
outfile=data_dir+outfname

ts = INDGEN(m) * dt
wave1=sin(f1*twopi*ts)
wave2=sin(f2*twopi*ts)
;wave1=sin(f1*ts)
;wave2=sin(f2*ts)
wave_mult=wave1*wave2
wavform_data=0.5*(wave1+wave2)+2.0*wave_mult

plotlen=200
cgplot,ts[0:plotlen],wave1[0:plotlen],color='blue'
cgplot,ts[0:plotlen],wave2[0:plotlen],/OVERPLOT,COLOR='red'
cgplot,ts[0:plotlen],wave_mult[0:plotlen],/OVERPLOT,COLOR='black'
;cgwindow,winid=1 & cgplot,ts[0:plotlen],wavform_data[0:plotlen],COLOR='black',window=1

save,wavform_data,filename=outfile

;for comparing real and fabricated data
;restore,'real_and_fake_wavform_data.idl.sav'
;plotlen = 1000 & cgwindow,winid=0 & cgplot,wavform_data[0:plotlen],COLOR='black',window=1 & cgwindow,winid=1 & cgplot,wavform_real[0:plotlen],COLOR='black',window=1

;norming fake data
;restore,'real_and_normed_fake_wavform_data.idl.sav'
;wavform_normed=wavform_data-(max(wavform_data)+min(wavform_data))/2.
;wavform_normed=wavform_normed/max(wavform_normed)
;plotlen = 1000 & cgwindow,winid=0 & cgplot,wavform_real[0:plotlen],COLOR='black',window=1 & cgwindow,winid=1 & cgplot,wavform_normed[0:plotlen],COLOR='black',window=1