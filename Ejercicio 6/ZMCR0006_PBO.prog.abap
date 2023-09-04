*&---------------------------------------------------------------------*
*&  Include           ZMCR0006_PBO
*&---------------------------------------------------------------------*


*&---------------------------------------------------------------------*
*&      MODULE  D0100_USER_COMMAND  INPUT
*&---------------------------------------------------------------------*

" Capturar los eventos del Dynpro

MODULE d0100_user_command INPUT.

  PERFORM f400_user_command USING gs_okcode.

ENDMODULE.

*&---------------------------------------------------------------------*
*&      MODULE  D0100_EXIT_COMMAND  INPUT
*&---------------------------------------------------------------------*

" Al seleccionar salir del Dynpro

MODULE d0100_exit_command INPUT.

  PERFORM f500_exit_command.

ENDMODULE.