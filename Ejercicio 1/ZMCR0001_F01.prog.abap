*&---------------------------------------------------------------------*
*&  Include           ZMCR0001_F01
*&---------------------------------------------------------------------*

FORM VALIDARMONTO USING i_monto TYPE i.

  DATA:
        s_topera(1) TYPE c.

  IF i_monto = 0 OR i_monto < 0.
    MESSAGE e000.
  ENDIF.

ENDFORM.

FORM VALIDAROPERACION USING u_operacion TYPE c.

    DATA:
          s_topera(1) TYPE c.

    IF u_operacion <> 'I' AND u_operacion <> 'R'.
      MESSAGE e001.
    ENDIF.

ENDFORM.


FORM CONVERT_SOLES USING i_monto TYPE i.

  DATA:
        p_total(13) TYPE p DECIMALS 3.


  p_total = i_monto * gp_tcambio.
  gp_monto = p_total.

ENDFORM.




FORM sumtotal using b_monto TYPE p.

  DATA:
        p_mtotal(13) TYPE p DECIMALS 3.

  p_mtotal = gp_minicial + b_monto.
  gp_mtotal = p_mtotal.

ENDFORM.





FORM restotal using b_monto TYPE p.

  DATA:
       p_mtotal(13) TYPE p DECIMALS 3.
  p_mtotal = gp_minicial - b_monto.
  gp_mtotal = p_mtotal.

ENDFORM.


FORM B_CAJA.

DATA:
      lwa_bal TYPE gty_operacion.

  lwa_bal-fecha = sy-datum.
  lwa_bal-hour = sy-uzeit.
  lwa_bal-monto = monto.
  lwa_bal-minicial = gp_minicial.
  lwa_bal-mtotal =  gp_mtotal.
  lwa_bal-des = opc.
  lwa_bal-coney = gs_coney.
  lwa_bal-tcambio = gp_tcambio.
  lwa_bal-soles = gp_monto.
 WRITE:
    /,
    5(10) 'FECHA TRANSACCION', 20(5) 'TIME', 30(13) 'MONTO TOTAL', 48(13) 'M. ANTERIOR', 66(13) 'M. ACTUAL', 84(50) 'ASUNTO', 139(6) 'MONEDA', 150(5) 'TIPO CAMBIO', 160(8) 'CAMBIO EN SOLES',
    /,
    5(10) lwa_bal-fecha, 20(5) lwa_bal-hour, 30(13) lwa_bal-monto, 48(13) lwa_bal-minicial, 66(13) lwa_bal-mtotal, 84(50) lwa_bal-des, 139(6) lwa_bal-coney, 150(5) lwa_bal-tcambio, 160(8) lwa_bal-soles.

 ENDFORM.