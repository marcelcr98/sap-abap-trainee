*&---------------------------------------------------------------------*
*&  Include           ZMC0002_SSC
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE text-t01.
PARAMETERS:
  p_user TYPE syst-uname MATCHCODE OBJECT syst-uname OBLIGATORY,
  p_retiro RADIOBUTTON GROUP g1 USER-COMMAND u1 DEFAULT 'X',
  p_dep RADIOBUTTON GROUP g1,
  p_cons RADIOBUTTON GROUP g1 ,
  p_csaldo AS CHECKBOX,
  p_monto TYPE ze_monto MODIF ID R,
  p_desc TYPE ze_descri MODIF ID D.




  SELECT-OPTIONS:
    s_fecha FOR syst-datum MODIF ID C.
  SELECT-OPTIONS:
    s_tipope FOR ZTMCR_MOVBAN-tipope MODIF ID C.
SELECTION-SCREEN END OF BLOCK B1.