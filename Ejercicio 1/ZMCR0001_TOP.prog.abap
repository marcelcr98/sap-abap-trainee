*&---------------------------------------------------------------------*
*&  Include           ZMCR0001_TOP
*&---------------------------------------------------------------------*

TYPES:
  BEGIN OF gty_operacion,
      fecha TYPE sy-datum,
      hour TYPE sy-uzeit,
      monto(13) TYPE p DECIMALS 3,
      minicial(13) TYPE p DECIMALS 3,
      mtotal(13) TYPE p DECIMALS 3,
      des(100),
      coney(5),
      tcambio(3) TYPE p DECIMALS 2,
      soles(13) TYPE p DECIMALS 3,

   END OF gty_operacion.

DATA:
      gp_monto(13) TYPE p DECIMALS 3,
      gp_minicial(13) TYPE p  DECIMALS 3 VALUE '15000',
      gp_mtotal(13) TYPE p DECIMALS 3,
      gp_tcambio(3) TYPE p DECIMALS 2 VALUE '3.88',
      gs_coney TYPE char30.