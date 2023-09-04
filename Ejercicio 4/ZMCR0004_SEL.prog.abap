*&---------------------------------------------------------------------*
*&  Include           ZMCR0004_SEL
*&---------------------------------------------------------------------*


  SELECTION-SCREEN:
    BEGIN OF BLOCK b_01 WITH FRAME TITLE text-s01.
    SELECT-OPTIONS:
      s_ndoc FOR ztmcr_bkpf-belnr, " Número de documento
      s_clase FOR ztmcr_bkpf-blart, " Clase de documento
      s_fecha FOR ztmcr_bkpf-bldat NO-EXTENSION, "OBLIGATORY , " Fecha de documento
      s_money FOR ztmcr_bkpf-waers, " Moneda
      s_cmayor FOR ztmcr_bseg-hkont. " Cuenta de mayor

  SELECTION-SCREEN:
    END OF BLOCK b_01.

  SELECTION-SCREEN:
    BEGIN OF BLOCK b_02 .

    PARAMETERS:
      p_readp RADIOBUTTON GROUP opc DEFAULT 'X',
      p_nreadp RADIOBUTTON GROUP opc,
      p_std as checkbox,
      p_vari type slis_vari.

  SELECTION-SCREEN:
    END OF BLOCK b_02.