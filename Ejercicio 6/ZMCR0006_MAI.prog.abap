*&---------------------------------------------------------------------*
*&  Include           ZMCR0006_MAI
*&---------------------------------------------------------------------*

*&--------------------------------------------------------------------&*
*&          S T A R T  -  O F  -  S E L E C T I O N                   &*
*&--------------------------------------------------------------------&*

START-OF-SELECTION.
  DATA:
    ls_validacion.

  PERFORM f01_validar CHANGING ls_validacion.

  IF ls_validacion = 'X'. " Opcion para validar el registro con el proveedor.
    PERFORM f100_extraer_datos.
    IF gi_items > 0.
      PERFORM f300_config USING 1.
      PERFORM f9000_listar_datos. " Listar datos
    ENDIF.
  ENDIF.

*&--------------------------------------------------------------------&*
*&                I N I T I A L I Z A T I O N                         &*
*&--------------------------------------------------------------------&*

INITIALIZATION.