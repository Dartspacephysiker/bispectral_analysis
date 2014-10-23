;Sweeping out 680-700 on x, 330-360 on y
;
default_data_dir="/daq/bispectral_analysis/data/idl/"
default_file="bispectrum_data_340_350_kHz_waves--10MHz--n_seg8192--FABRICATED.idl.data"
outfname="bispectrum_peak_data_bytscaled.txt"
outfile=default_data_dir+outfname

;filter the output based on a desired range of freqs?
filter_freq = 1
freq_range_x=[670,700]
freq_range_y=[0,1200]

if not keyword_set(num_seg) then begin & $
  num_seg = 8192 & $
  print,"no number of segments specified! doing a conservative " + strcompress(string(num_seg),/remove_all) + "..." & $
endif

;get the data back online
data_dir=default_data_dir
fname=default_file
infile=data_dir+fname
restore,infile

density = bicoh
maxdensity = max(density)
mindensity = min(density)
scaleddensity = bytscl(density, min=mindensity, max=maxdensity)
bicoh_scaled = scaleddensity

;which bins to filter?
if filter_freq then filtbins = bispectrum_get_freq_bins(bicoh_f,freq_range_x[0],freq_range_y[0],freq_range_x[1],freq_range_y[1])

;max(scaledDensity[freqbins[0]:freqbins[2],freqbins[1]:freqbins[3]])
;46-- not very big


;find out freq bins for array indices in question
;arrlen=4097L
;bin=33053L
;raw=DOUBLE(bin)/double(arrlen)
;row=floor(raw)
;clm=CEIL((raw-clm)*arrlen)
;print,"bin = " + string(bin)
;print,"col*arrlen + ceil = bin?"
;print,STRCOMPRESS(STRING(clm*arrlen)+" + " + string(row) + " = " + string(clm*arrlen+row),/REMOVE_ALL)

;open outfile
OPENW,outlun,outfile,/GET_LUN
printf,outlun,format='("BIN",T18,"COL FREQ (kHz)",T36,"ROW FREQ (kHz)",T54,"COL",T64,"ROW",T74,"VALUE")' & $

;output time
searchbins=where(scaledDensity GE 0 AND scaledDensity LE 255)
arrlen=4097L
for i=0,n_elements(searchbins)-1 DO BEGIN & $
  bin=searchbins[i] & $
  raw=DOUBLE(bin)/double(arrlen) & $
  row=floor(raw) & $
  clm=CEIL((raw-row)*arrlen) & $

;  print,"bin = " + string(bin) & $
;  print,"col*arrlen + ceil = bin?" & $
;  print,STRCOMPRESS(STRING(clm*arrlen)+" + " + string(row) + " = " + string(clm*arrlen+row),/REMOVE_ALL) & $
;good, now get freq info

  IF filter_freq THEN BEGIN & $
    IF clm GE filtbins[0] AND clm LE filtbins[2] AND row GE filtbins[1] AND row LE filtbins[3] THEN BEGIN & $
      printf,outlun,format='(I-0,T18,D-0,T36,D-0,T54,I-0,T64,I-0,T74,I-0)',$
        bin,(bicoh_f[clm]/1000.),(bicoh_f[row]/1000.),clm,row,scaleddensity[clm,row] & $
    ENDIF & $
  ENDIF ELSE BEGIN & $
    printf,outlun,format='(I-0,T18,D-0,T36,D-0,T54,I-0,T64,I-0,T74,I-0)',$
      bin,(bicoh_f[clm]/1000.),(bicoh_f[row]/1000.),clm,row,scaleddensity[clm,row] & $
  ENDELSE & $ 
  
ENDFOR

CLOSE,outlun
