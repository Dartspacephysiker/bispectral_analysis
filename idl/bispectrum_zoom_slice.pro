;Diddling with bicoherence data to try to do some zooming and region plotting
;
;plot the slice of data nearest to a given frequency
desired_f=340000
slice=VALUE_LOCATE(bicoh_f,desired_f)
ptitle = string(FORMAT='("Bicoherence slice at ",F0.0, " kHz")',bicoh_f[slice])
cgplot,bicoh_f/1000,bicoh[slice,*],title=ptitle,xtitle="Frequency (kHz)"
