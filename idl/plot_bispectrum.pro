  ; docformat = 'rst'
  ;+
  ; This little beaut plots bispectral data with Coyote Graphics routines, 
  ; using data produced by bi_spectrum.pro (which was written by Simon Vaughan, U. Leicester) 
  ; 
  ; :Keywords:
  ;   bicoh_scaled: Gives back scaled bicoherence set used for plotting
  ;   NO_NEG:       Don't allow negative bicoherence values
  ;   DO_CONT:      Add contours to bicoherence plot
  ;   POW_SPEC:     Plot power spectrum instead of bicoherence    
  ;   xrange:       Specify a range of frequencies (in kHz!) for the x axis (e.g., xrange=[335,355])
  ;   yrange:       Specify a range of frequencies (in kHz!) for the y axis
  ;   fname:        Input filename; otherwise default is used
  ;   data_dir:     Directory where 'fname' is located 
  ; :Categories:
  ;    Graphics
  ;
  ; :Examples:
  ;    Save the program as "plot_bispectrum.pro" and run it like this::
  ;       IDL> .RUN plot_bispectrum
  ;    Otherwise, do something like this:
  ;       cgWindow, 'Plot_Bispectrum', Background='White', WTitle='Bispectrum'
  ;            
  ;    Or if you are really awesome:
  ;    cgPS_Open, 'bispectrum_plot.ps' & Plot_Bispectrum & cgPS_Close & cgPS2Raster, 'bispectrum_plot.ps', /PNG, Width=600
  ;
  ; :History:
  ;     Change History::
  ;        Written, 16 Oct 2014 by Hammertime
  ;-
  ;TOMORROW:
  ;32768 SEG SIZE?
  ;OTHER REGIONS OF INTEREST
  ;What else was on Professor LaBelle's sheet?
  
PRO Plot_Bispectrum,DO_CONTOUR=do_cont,bicoh_scaled=bicoh_scaled,num_seg=num_seg,NO_NEG=no_neg,POW_SPEC=pow_spec,$
  xrange=xrange,yrange=yrange,fname=fname,data_dir=data_dir
  
  default_data_dir="/daq/bispectral_analysis/data/idl/"
  ;default_file='500kHz-10kHz_stationarity_proj/bispectrum_data_500_10_kHz_waves--5MHz--n_seg8192--FABRICATED--halfamp_inputwaves--doubleamp_output.idl.data'
  ;default_file="bispectrum_data_340_350_kHz_waves_at_2.5MHz--n_seg" + STRCOMPRESS(string(num_seg),/remove_all) + ".idl.data"
  default_file='bispectrum_data_500_10_kHz_waves--0.6V--5MHz--n_seg16384.data'
  
  IF NOT KEYWORD_SET(num_seg) THEN BEGIN & $
    num_seg = 16384 & $
    PRINT,"No number of segments specified! Doing a conservative " + STRCOMPRESS(string(num_seg),/remove_all) + "..." & $
  ENDIF
  
  ;Get the data back online
  IF NOT KEYWORD_SET(data_dir) then data_dir=default_data_dir
  IF NOT KEYWORD_SET(fname) THEN fname=default_file
  infile=data_dir+fname

  print,"Opening " + infile + " for action..."
  IF NOT FILE_TEST(infile) THEN BEGIN & $
    PRINT,"Plot_Bispectrum could not open " + infile + "!" & $
    PRINT,"Exiting..." & $
    RETURN & $
  ENDIF & $
  RESTORE,infile

;  IF bicoh_0_in[0,0] NE !NULL THEN BEGIN & $
;    bicoh = bicoh_0_in & $
;    bicoh_f = bicoh_f_0_in & $
;    bicoh_pj = bicoh_pj_0_in & $
;  ENDIF
;
;  IF bicoh_1_in[0,0] NE !NULL THEN BEGIN & $
;    bicoh = bicoh_1_in & $
;    bicoh_f = bicoh_f_1_in & $
;    bicoh_pj = bicoh_pj_1_in & $
;    ENDIF
;
;  IF bicoh_2_in[0,0] NE !NULL THEN BEGIN & $
;    bicoh = bicoh_2_in & $
;    bicoh_f = bicoh_f_2_in & $
;    bicoh_pj = bicoh_pj_2_in & $
;  ENDIF

  IF bicoh EQ !NULL THEN BEGIN & $
    print, "No input data!" & $
    RETURN & $
  ENDIF

; Set up variables for the plot. Normally, these values would be
; passed into the program as positional and keyword parameters.
  IF ~KEYWORD_SET(xrange) AND ~KEYWORD_SET(yrange) THEN BEGIN & $
    x = bicoh_f/1000.0 & $
    y = x & $
    xrange = [Min(x), Max(x)] & $
    yrange = xrange & $
    freqbins = [bicoh_f[0],bicoh_f[0],bicoh_f[-1],bicoh_f[-1]]
  ENDIF ELSE BEGIN
    IF KEYWORD_SET(xrange) AND ~KEYWORD_SET(yrange) THEN BEGIN
 
      yrange = [ max(bicoh_f)/1000.0, min(bicoh_f)/1000.0 ]
      
      ;Get bins from bicoh_f
      freqbins = bispectrum_get_freq_bins(bicoh_f,xrange[0],yrange[0],xrange[1],yrange[1])
    
      ;set up ranges  
      x = bicoh_f[freqbins[0]:freqbins[2]]
      xrange = [ bicoh_f(freqbins[0])/1000.0, bicoh_f(freqbins[2])/1000.0 ]
    ENDIF ELSE BEGIN
      IF ~KEYWORD_SET(xrange) AND KEYWORD_SET(yrange) THEN BEGIN
        
        ;set up x, because it isn't...
        x = bicoh_f
        xrange = [Min(x), Max(x)]
        
        ;Get bins from bicoh_f
        freqbins = bispectrum_get_freq_bins(bicoh_f,xrange[0],yrange[0],xrange[1],yrange[1])

        ;set up ranges
        xrange = [ bicoh_f(freqbins[0])/1000.0, bicoh_f(freqbins[2])/1000.0 ]
        yrange = [ bicoh_f(freqbins[1])/1000.0, bicoh_f(freqbins[3])/1000.0 ]
        y = bicoh_f[freqbins[1]:freqbins[3]]
        y = y/1000.0
      ENDIF ELSE BEGIN
        IF KEYWORD_SET(xrange) AND KEYWORD_SET(yrange) THEN BEGIN
          ;Get bins from bicoh_f
          freqbins = bispectrum_get_freq_bins(bicoh_f,xrange[0],yrange[0],xrange[1],yrange[1])

          ;set up ranges
          x = bicoh_f(freqbins[0]:freqbins[2])
          x = x/1000.0
          y = bicoh_f[freqbins[1]:freqbins[3]]  
          y = y/1000.0
          xrange = [ bicoh_f(freqbins[0])/1000.0, bicoh_f(freqbins[2])/1000.0 ]
          yrange = [ bicoh_f(freqbins[1])/1000.0, bicoh_f(freqbins[3])/1000.0 ]
        ENDIF
      ENDELSE
    ENDELSE
  ENDELSE
  
  ;These are the same for everyone
  xbinsize = bicoh_f[1]-bicoh_f[0]
  ybinsize = xbinsize

  ; Open a display window.
  cgDisplay

  ; Create the density plot by binning the data into a 2D histogram.
  ;density = Hist_2D(x, y, Min1=xrange[0], Max1=xrange[1], Bin1=xbinsize, $
  ;  Min2=yrange[0], Max2=yrange[1], Bin2=ybinsize)
  density = bicoh

  neg_elem = WHERE(density LT 0)
  IF neg_elem[0] NE -1 AND KEYWORD_SET(no_neg) THEN BEGIN & $
    print,format='("Got some neg elements at ",(T30,8(I-12)))',neg_elem & $
    print,format='((T30,8(F-12)))',density(neg_elem) & $
    density(neg_elem) = 0.0 & $
  ENDIF

  maxDensity = Max(density)
  minDensity = Min(density)
  scaledDensity = BytScl(density, Min=minDensity, Max=maxDensity)
  bicoh_scaled = scaledDensity

  ; Load the color table for the display. All zero values will be gray.
  cgLoadCT, 33
  ;TVLCT, cgColor('gray', /Triple), 0
  ;TVLCT, cgColor('gray', /Triple), 1
  TVLCT, r, g, b, /Get
  palette = [ [r], [g], [b] ]
  
  ;handle position of plot before displaying
  IF KEYWORD_SET(pow_spec) THEN BEGIN & $
      pos_bicoh=[0.1, 0.1, 0.45, 0.85] & pos_cb =[ 0.1, 0.9, 0.45, 0.925] & pos_powspec = [0.65, 0.1, 0.95, 0.90] & $
    ENDIF ELSE BEGIN & $
      pos_bicoh=[0.125, 0.125, 0.9, 0.8] & pos_cb=[0.125, 0.875, 0.9, 0.925] & $
    ENDELSE
  
  
  ; Display the density plot.
  cgImage, scaledDensity[freqbins[0]:freqbins[2],freqbins[1]:freqbins[3]], XRange=xrange, YRange=yrange, $
    XTitle='Frequency (kHz)', YTitle='Frequency (kHz)', $
    /Axes, Position=pos_bicoh, Palette=palette

  IF KEYWORD_SET(do_cont) THEN BEGIN & $
    thick = (!D.Name EQ 'PS') ? 6 : 2 & $
    cgContour, density, LEVELS=maxDensity*[0.25, 0.5, 0.75], /OnImage, $
      C_Colors=['Tan','Tan', 'Brown'], C_Annotation=['Low', 'Avg', 'High'], $
      C_Thick=thick, C_CharThick=thick & $
  ENDIF

  ; Display a color bar.
  cgColorbar, Position=pos_cb, Title='Scaled Bicoherence', $
    Range=[minDensity, maxDensity], NColors=254, OOB_LOW=0,$
    TLocation='Top'

  ;Now do power spectrum, if desired
  IF KEYWORD_SET(pow_spec) THEN BEGIN & $
    PRINT, "Displaying power spectrum" & $
;    pj_scaled = BYTSCL(bicoh_pj,MAX=max(bicoh_pj),MIN=min(bicoh_pj),TOP=100.0) & $
;    pj_scaled = pj_scaled/100.0     
    pj_norm = bicoh_pj/TOTAL(bicoh_pj)
    cgPlot, x, pj_norm[freqbins[0]:freqbins[2]], xtitle="Frequency (kHz)", ytitle="Normalized power", $
            xrange=[min(x),max(x)], Position=pos_powspec, /NoErase & $
  ENDIF

END