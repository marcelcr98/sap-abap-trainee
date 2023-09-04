*&---------------------------------------------------------------------*
*&  Include           ZMC0002_MAI
*&---------------------------------------------------------------------*
INITIALIZATION.

AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    PERFORM val_campos.
  ENDLOOP.
AT SELECTION-SCREEN.


START-OF-SELECTION.

PERFORM validar_saldo USING p_user.

IF p_dep = 'X'.
  PERFORM depositar.
ENDIF.

IF p_retiro = 'X'.
  PERFORM retirar.
ENDIF.

IF p_cons = 'X'.
  PERFORM consultar.
  p_csaldo = ''.
ENDIF.

IF p_csaldo = 'X'.
  PERFORM mostrar_saldo.
ENDIF.