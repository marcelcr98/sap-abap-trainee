*&---------------------------------------------------------------------*
*&  Include           ZMCR0006_PAI
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      MODULE  SET_STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*

" Modulo para especificar el status GUI del Dynpro creado

MODULE d0100_set_status OUTPUT.

  PERFORM v004_valida_correo.
  SET TITLEBAR 'D0100'.

ENDMODULE.