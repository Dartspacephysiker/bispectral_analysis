;a wrapper for plot_bispectrum and producing .png files
;
;plotdir ="/daq/bispectral_analysis/data/idl/plots/"
plotdir ="/daq/bispectral_analysis/data/idl/500kHz-10kHz_stationarity_proj/plots/"
do_powspec=1
do_ranges=1
segs=16384
def_xmin=0
def_xmax=2500
def_ymin=0
def_ymax=2500

IF DO_RANGES NE !NULL AND DO_RANGES GT 0 THEN BEGIN & $
  xmin=480 & xmax=515 & ymin=0 & ymax=15 & rangestr=STRCOMPRESS("--"+string(xmin)+"-"+string(xmax)+"--"+string(ymin)+"-"+string(ymax),/remove_all) & $
ENDIF ELSE BEGIN & xmin = def_xmin & xmax = def_xmax & ymin = def_ymin & ymax = def_ymax & rangestr="" & ENDELSE


for i = 0,n_elements(segs)-1 do BEGIN & $
  cur_segnum=segs[i] & $
  
  ;"_pow_spec--FAB--5MHzrate--halfamp_inputwaves--doubleamp_output.ps"
  
  IF do_powspec then begin & $
    outfname=plotdir+"bispectrum_plot--n_segs" + STRCOMPRESS(cur_segnum,/remove_all) + rangestr + "_pow_spec--5MHzrate.ps" & $
 
    cgPS_Open, outfname & Plot_Bispectrum,num_seg=cur_segnum,/pow_spec,xrange=[xmin,xmax],yrange=[ymin,ymax] & cgPS_Close & cgPS2Raster, outfname, /PNG, /DELETE_PS, Width=1200 & $
  ENDIF ELSE BEGIN & $
    outfname=plotdir+"bispectrum_plot--n_segs" + STRCOMPRESS(cur_segnum,/remove_all) + rangestr + "--5MHzrate.ps" & $
 
    cgPS_Open, outfname & Plot_Bispectrum,num_seg=cur_segnum,xrange=[xmin,xmax],yrange=[ymin,ymax] & cgPS_Close & cgPS2Raster, outfname, /PNG, /DELETE_PS, Width=1200 & $
  ENDELSE & $

ENDFOR

;cgWindow, 'Plot_Bispectrum', num_seg=segs,xrange=[xmin,xmax],yrange=[ymin,ymax],Background='White', WTitle='Bispectrum'

;cgPS_Open, outfname & Plot_Bispectrum,num_seg=cur_segnum,xrange=[xmin,xmax],yrange=[ymin,ymax] & cgPS_Close & cgPS2Raster, outfname, /PNG, Width=1200

