;+
; :NAME:
;   BISPECTRUM_GET_FREQ_BINS
;
; :PURPOSE:
;   Returns a four-element array [xmin,xmax, ymin,ymax] of boundary values to be used by plot_bispectrum
;
; :EXAMPLE:
;   bispec_bounds = bispectrum_get_freq_bins(bicoh_f,xmin,ymin,xmax,ymax
;
; :KEYWORDS:
;   bispec_f: Array of frequency values, outputted by bi_spectrum.pro (written by Simon Vaughan, U. Leicester)
;   x_freqmin: scalar specifying min frequency along x axis (in kHz!!)
;   y_freqmin: scalar specifying min frequency along y axis (in kHz!!)
;   x_freqmax: scalar specifying max frequency along x axis (in kHz!!)
;   y_freqmax: scalar specifying max frequency along y axis (in kHz!!)
;
;
;
;
;-

FUNCTION bispectrum_get_freq_bins,bicoh_f,x_freqmin,y_freqmin,x_freqmax,y_freqmax

  DIAG = 1 ;diagnostics?
  
  IF x_freqmin EQ !NULL THEN BEGIN
    PRINT, "No frequency info provided! What were you thinking?"
    RETURN, 0
  ENDIF

  def_freqmax = bicoh_f[-1]
  IF x_freqmax EQ !NULL THEN BEGIN
    PRINT, "No max x frequency provided! Using max possible..."
    x_freqmax = def_freqmax
  ENDIF
  IF y_freqmax EQ !NULL THEN BEGIN
    PRINT, "No max y frequency provided! Using max possible..."
    y_freqmax = def_freqmax
  ENDIF

  xminbin=VALUE_LOCATE(bicoh_f,x_freqmin*1000.0)
  yminbin=VALUE_LOCATE(bicoh_f,y_freqmin*1000.0)
  xmaxbin=VALUE_LOCATE(bicoh_f,x_freqmax*1000.0)
  ymaxbin=VALUE_LOCATE(bicoh_f,y_freqmax*1000.0)

  IF DIAG NE !NULL and DIAG NE 0 THEN BEGIN
    PRINT,FORMAT='("xmin",T10,"Bin:",A-20,"Freq:",T50,F-13.6)',xminbin,bicoh_f[xminbin]
    PRINT,FORMAT='("ymin",T10,"Bin:",A-20,"Freq:",T50,F-13.6)',yminbin,bicoh_f[yminbin]
    PRINT,FORMAT='("xmax",T10,"Bin:",A-20,"Freq:",T50,F-13.6)',xmaxbin,bicoh_f[xmaxbin]
    PRINT,FORMAT='("xymax",T10,"Bin:",A-20,"Freq:",T50,F-13.6)',ymaxbin,bicoh_f[ymaxbin]
  ENDIF

    binarr = [xminbin,yminbin,xmaxbin,ymaxbin]
  RETURN, binarr

END