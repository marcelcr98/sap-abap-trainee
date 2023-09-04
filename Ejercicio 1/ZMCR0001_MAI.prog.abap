*&---------------------------------------------------------------------*
*&  Include           ZMCR0001_MAI
*&---------------------------------------------------------------------*
AT SELECTION-SCREEN ON monto.
  PERFORM VALIDARMONTO USING monto.

START-OF-SELECTION.
PERFORM VALIDAROPERACION USING opc.

  IF dolar = 'X'.
    PERFORM CONVERT_SOLES USING monto.
    gs_coney = '$'.
  ELSEIF soles = 'X'.
    gs_coney = 'S/.'.
    gp_monto = monto.
  ENDIF.

  IF opc = 'I'.
    PERFORM sumtotal USING gp_monto.
  ELSEIF opc = 'R'.
    PERFORM restotal USING gp_monto.
  ENDIF.

  IF pbal = 'X'.
    PERFORM B_CAJA.
  ELSEIF pbal = ''.
    WRITE:
      'Asunto de la operacion:', asunto, /,
      'Inicial: ', gp_minicial, /,
      'Total ingresado: ', monto, /,
      'Monto Soles: ', gp_monto, /,
      'Monto Total:', gp_mtotal, /.

  ENDIF.