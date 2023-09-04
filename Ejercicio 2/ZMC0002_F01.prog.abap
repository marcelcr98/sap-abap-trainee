*&---------------------------------------------------------------------*
*&  Include           ZMC0002_F01
*&---------------------------------------------------------------------*

FORM val_campos.

    IF p_cons  = 'X'.
      IF screen-group1 = 'D' OR screen-group1 = 'R'.
         screen-active = '0'.
         MODIFY SCREEN.
      ENDIF.
      IF screen-group1 = 'C'.
         screen-required = 2.
         MODIFY SCREEN.
        IF ( s_tipope = '' ).
        ENDIF.
      ENDIF.
   ELSEIF p_retiro  = 'X'.
      IF screen-group1 = 'C' .
         screen-active   = 0.
         MODIFY SCREEN.
      ENDIF.
      IF screen-group1 = 'R'.
         screen-required = 2.
         MODIFY SCREEN.
      ENDIF.

   ELSEIF p_dep  = 'X'.
      IF screen-group1 = 'C'.
         screen-active = 0.
         MODIFY SCREEN.
      ENDIF.
      IF screen-group1 = 'R' OR screen-group1 = 'D' .
         screen-required = 2.
         MODIFY SCREEN.
      ENDIF.
   ENDIF.

ENDFORM.



FORM validar_saldo USING p_user.

  DATA:
        ltd_movban TYPE STANDARD TABLE OF  ztmcr_movban.
  FIELD-SYMBOLS:
               <fs_aux> LIKE LINE OF ltd_movban.
  SELECT * FROM ztmcr_movban INTO TABLE ltd_movban WHERE uname = p_user.

  IF sy-subrc = 0.
    LOOP AT ltd_movban ASSIGNING <fs_aux>.
       gi_saldo = <fs_aux>-saldo.
       gi_correl = <fs_aux>-correl.
    ENDLOOP.
  ELSEIF sy-subrc = 1 or sy-subrc = 4.
    gi_saldo = 0.
    gi_correl = 0.
  ENDIF.
ENDFORM.



FORM depositar.

  IF ( p_monto = 0 )."Si el monto es igual a 0
      MESSAGE s000 DISPLAY LIKE 'E'.
      " LEAVE PROGRAM.
      EXIT.
    ELSE.
       DATA:
        lwa_movban LIKE LINE OF gtd_movban.
        lwa_movban-uname = p_user.
        lwa_movban-datum = sy-datum.
        lwa_movban-correl = gi_correl + 1.
        lwa_movban-uzeit = sy-uzeit.
        lwa_movban-tipope = 'D'.
        lwa_movban-import = p_monto.
        gi_saldoc = gi_saldo + p_monto.
        lwa_movban-saldo = gi_saldoc.
        lwa_movban-descri = p_desc.

        INSERT INTO ZTMCR_MOVBAN VALUES lwa_movban.
        MESSAGE s005.

    ENDIF.

ENDFORM.



FORM retirar.
  IF ( p_monto = 0 )."Si el monto es igual a 0
      MESSAGE s000 DISPLAY LIKE 'E'.
      " LEAVE PROGRAM.
      EXIT.
    ELSE.
      DATA:
        lwa_movban LIKE LINE OF gtd_movban.
        IF gi_saldo > p_monto.
         lwa_movban-uname = p_user.
         lwa_movban-datum = sy-datum.
         lwa_movban-correl = gi_correl + 1.
         lwa_movban-uzeit = sy-uzeit.
         lwa_movban-tipope = 'R'.
         lwa_movban-import = p_monto.
         gi_saldoc = gi_saldo - p_monto.
         lwa_movban-saldo = gi_saldoc.
         lwa_movban-descri = p_desc.
         INSERT INTO ZTMCR_MOVBAN VALUES lwa_movban.
         MESSAGE s003.
        ELSEIF gi_saldo < p_monto.
          MESSAGE e002.
        ENDIF.
  ENDIF.

ENDFORM.



FORM mostrar_saldo.


   IF ( p_monto = 0 )."Si el monto es igual a 0
      MESSAGE s000 DISPLAY LIKE 'E'.
      " LEAVE PROGRAM.
      EXIT.
    ELSE.
      gi_correl = gi_correl + 1.

      WRITE: text-t02,/  sy-uline(100),
             /,text-t03,p_user ,
             /,text-t04,'  ',gi_correl ,
             /,text-t05, '  ',sy-datum,
             /,text-t06, '  ',sy-uzeit,
             /,text-t07, '  ', p_desc,
             /,text-t08,p_monto,
             /,text-t09,gi_saldo,
             /,text-t10, gi_saldoc,/.
  ENDIF.

ENDFORM.



FORM consultar.

  IF ( s_fecha[] IS INITIAL ).
        MESSAGE s007 DISPLAY LIKE 'E' .
        EXIT.
  ELSE.
      DATA:
          ltd_movban TYPE TABLE OF ztmcr_movban.
          FIELD-SYMBOLS:
                       <fs_aux> LIKE LINE OF ltd_movban.
          SELECT * FROM ztmcr_movban INTO TABLE ltd_movban WHERE uname = p_user AND datum IN s_fecha AND tipope IN s_tipope.

          LOOP AT ltd_movban ASSIGNING <fs_aux>.
            AT FIRST.
              FORMAT COLOR 4.
              WRITE:
              text-t11,/  sy-uline(200)
              , 1(6)  text-t04,
              10(10) text-t03,
              26(9) text-t05,
              38(15) text-t06 ,
              50(95)  text-t12  ,
              70(80) text-t07 ,
              156(11) text-t13,
              / sy-uline(200).
              FORMAT COLOR OFF.
            ENDAT.
            WRITE: sy-uline(10),
            1(6) <fs_aux>-correl,
            10(10) <fs_aux>-uname,
            26(9) <fs_aux>-datum,
            38(15)  <fs_aux>-uzeit,
            50(95) <fs_aux>-tipope,
            70(80) <fs_aux>-descri,
            156(11) <fs_aux>-import, sy-uline(200).
      ENDLOOP.
  ENDIF.

ENDFORM.