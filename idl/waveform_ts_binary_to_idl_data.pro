PRO WAVEFORM_TS_BINARY_TO_IDL_DATA,infile,outfile,tmplt=tmplt,freq=freq

  ; ----------------------------------------------------------
  ;+
  ; NAME:
  ;       WAVEFORM_TS_BINARY_TO_IDL_DATA.PRO
  ;
  ; PURPOSE:
  ;       Convert time binary waveform data to IDL-readable data.
  ;
  ; AUTHOR:
  ;       Spencer Hatch (Dartmouth College)
  ;
  ; CALLING SEQUENCE:
  ;       WAVEFORM_TS_BINARY_TO_IDL_DATA,infile
  ;       ; HISTORY:
  ;       09/02/2007  - v1.0 -  First working version
  ;-
  ; ----------------------------------------------------------

  def_datadir='/daq/bispectral_analysis/data/processed/'
  def_outdir='/daq/bispectral_analysis/data/idl/'

  IF NOT KEYWORD_SET(outfile) THEN BEGIN
    outfile=def_outdir+"out_wavform.data"
    print, "No outfile provided! Using " + outfile
  ENDIF

  IF NOT KEYWORD_SET(freq) THEN BEGIN
    freq=1000000
    print,format='("Frequency not provided! Defaulting to ",I-0," kHz")',freq/1000 
  ENDIF

;  IF NOT KEYWORD_SET(tmplt) THEN BEGIN
;    def_tmplt='/daq/bispectral_analysis/idl/wavform_ts_tmplt_IDL.sav'
;    
;    IF (FILE_TEST(def_tmplt)) THEN BEGIN
;      PRINT, "Using default template: " + def_tmplt
;      RESTORE,FILENAME=def_tmplt
;      tmplt=def_tmplt
;    ENDIF ELSE BEGIN
;      PRINT, "Couldn't find default template: " + def_tmplt
;      tmplt = BINARY_TEMPLATE(infile)
;      SAVE, tmplt, FILENAME=def_tmplt
;    ENDELSE 
;  ENDIF

  PRINT, "Reading " + infile + "..."
  OPENR, lun, infile, /get_lun
    wavform_data=READ_BINARY(lun,data_type=2)
  CLOSE, lun
  PRINT, "Done! Got " + string(N_ELEMENTS(wavform_data)) + " data points"

  SAVE,wavform_data,FILENAME=outfile

  PRINT,"Saved waveform data to " + outfile
END