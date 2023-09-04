*&---------------------------------------------------------------------*
*&  Include           ZMCR0006_SSC
*&---------------------------------------------------------------------*

SELECTION-SCREEN:
     BEGIN OF BLOCK b_01 WITH FRAME TITLE text-s01.

       PARAMETERS:
          p_bukrs TYPE bsak-bukrs OBLIGATORY. " Campo Sociedad

       SELECT-OPTIONS:
          s_bldat FOR bsak-bldat  OBLIGATORY NO-EXTENSION, " Campo Fecha Documento
          s_belnr FOR bsak-belnr ,                         " Campo Numero Documento
          s_blart FOR bsak-blart ,                         " Clase de Documento
          s_lifnr FOR bsak-lifnr .                         " Proveedor

SELECTION-SCREEN:
     END OF BLOCK b_01.

SELECTION-SCREEN:
     BEGIN OF BLOCK b_02 WITH FRAME TITLE text-s02.

     PARAMETERS:
       p_vari TYPE disvariant-variant.                  " Variante

SELECTION-SCREEN:
     END OF BLOCK b_02.