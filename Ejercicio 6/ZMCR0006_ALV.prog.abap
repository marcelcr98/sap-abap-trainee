*&---------------------------------------------------------------------*
*&  Include           ZMCR0006_ALV
*&---------------------------------------------------------------------*


*&---------------------------------------------------------------------*
*&      FORM  f9000_listar_datos
*&---------------------------------------------------------------------*

FORM f9000_listar_datos.

  DATA:
    ltd_events    TYPE slis_t_event,
    ltd_sortcat   TYPE slis_t_sortinfo_alv,
    ltd_fieldcat  TYPE slis_t_fieldcat_alv,
    lw_layout     TYPE slis_layout_alv,
    lw_vari       TYPE disvariant,
    lw_keyinfo    TYPE slis_keyinfo_alv.

  PERFORM f9010_build_eventtab CHANGING ltd_events.
  PERFORM f9020_build_layout   CHANGING lw_layout.
  PERFORM f9030_build_sortcat  CHANGING ltd_sortcat.
  PERFORM f9050_set_variant    CHANGING lw_vari.
  PERFORM f9040_init_fieldcat  CHANGING ltd_fieldcat.
  PERFORM f9060_call_alv       USING ltd_events ltd_sortcat ltd_fieldcat lw_layout lw_vari.

ENDFORM. " Listar Datos de tabla

FORM f9010_build_eventtab CHANGING ct_events TYPE slis_t_event.

  FIELD-SYMBOLS:
    <fs_event> TYPE slis_alv_event.

  CALL FUNCTION 'REUSE_ALV_EVENTS_GET'
    EXPORTING
      I_LIST_TYPE = 0
    IMPORTING
      ET_EVENTS   = CT_EVENTS.


  READ TABLE ct_events ASSIGNING <fs_event>
                       WITH KEY NAME = SLIS_EV_USER_COMMAND.
  IF sy-subrc = 0.
    MOVE gc_formname_user_command TO <fs_event>-form.
  ENDIF.


  READ TABLE ct_events ASSIGNING <fs_event>
                       WITH KEY name = slis_ev_pf_status_set.
  IF SY-SUBRC = 0.
    MOVE GC_FORMNAME_PF_STATUS TO <FS_EVENT>-FORM.
  ENDIF.


  READ TABLE CT_EVENTS ASSIGNING <FS_EVENT>
                       WITH KEY NAME = SLIS_EV_TOP_OF_PAGE.
  IF SY-SUBRC = 0.
    MOVE GC_FORMNAME_TOP_OF_PAGE  TO <FS_EVENT>-FORM.
  ENDIF.


  READ TABLE CT_EVENTS ASSIGNING <FS_EVENT>
                       WITH KEY NAME = SLIS_EV_TOP_OF_LIST.
  IF SY-SUBRC = 0.
    MOVE GC_FORMNAME_TOP_OF_LIST TO <FS_EVENT>-FORM.
  ENDIF.

ENDFORM.

*---------------------------------------------------------------------*
*      FORM  f9020_build_layout
*---------------------------------------------------------------------*

" Campos de marca

FORM f9020_build_layout changing cw_layout TYPE slis_layout_alv.
  cw_layout-zebra                = 'X'.
  cw_layout-detail_popup         = ' '.
  cw_layout-no_input             = 'X'.
  cw_layout-no_colhead           = ' '.
  cw_layout-lights_condense      = ' '.
  cw_layout-detail_titlebar      = ' '.
  cw_layout-colwidth_optimize    = 'X'.
  cw_layout-box_fieldname      = 'CHECK'.
ENDFORM.

FORM f9030_build_sortcat changing ct_sortcat TYPE slis_t_sortinfo_alv.
  DATA:
    lw_sort     like line of ct_sortcat.
    clear lw_sort.
    lw_sort-spos      = 1.
    lw_sort-fieldname = gtw_config-order1. " Primer Ordenmiento
    lw_sort-up = 'X'.
    append lw_sort to ct_sortcat.

    lw_sort-spos      = 2.
    lw_sort-fieldname = gtw_config-order2. "  Segundo Ordenamiento
    lw_sort-up = 'X'.
    append lw_sort to ct_sortcat.

ENDFORM.



*---------------------------------------------------------------------*
*      FORM  f9040_init_fieldcat
*---------------------------------------------------------------------*

" Creación de catalogo de campos

FORM f9040_init_fieldcat changing ct_fieldcat  TYPE slis_t_fieldcat_alv.

  DATA:
    lwa_f like line of ct_fieldcat.

  field-symbols:
    <fs_fcat> like line of ct_fieldcat.

  call function 'REUSE_ALV_FIELDCATALOG_MERGE'
    exporting
      i_program_name          = sy-repid
      i_internal_tabname      = gtw_config-tbname
      i_structure_name        = gtw_config-strname
    changing
      ct_fieldcat             = ct_fieldcat
    exceptions
      inconsistent_interface  = 1
      program_error           = 2
    others                    = 3.

  IF sy-subrc <> 0.
    message id sy-msgid
          TYPE sy-msgty
        number sy-msgno
          with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  read table ct_fieldcat assigning <fs_fcat> with key fieldname = gtw_config-hotspot.
  IF sy-subrc = 0.
    <fs_fcat>-hotspot = 'X'.
  ENDIF.

  read table ct_fieldcat assigning <fs_fcat> with key fieldname = gtw_config-key1.
  IF sy-subrc = 0.
    <fs_fcat>-key = 'X'.
  ENDIF.

  read table ct_fieldcat assigning <fs_fcat> with key fieldname = gtw_config-key2.
  IF sy-subrc = 0.
    <fs_fcat>-key = 'X'.
  ENDIF.

  read table ct_fieldcat assigning <fs_fcat> with key fieldname = 'DMBTR'.
  IF sy-subrc = 0.
    <fs_fcat>-do_sum = 'X'.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      FORM  f9041_add_fld
*&---------------------------------------------------------------------*

" ADD ALV : Añadir los registros al reporte

FORM f9041_add_fld using pi_key           TYPE slis_fieldcat_alv-key
                         pi_tabname       TYPE slis_fieldcat_alv-tabname
                         pi_fieldname     TYPE slis_fieldcat_alv-fieldname
                         pi_ref_tabname   TYPE slis_fieldcat_alv-ref_tabname
                         pi_ref_fieldname TYPE slis_fieldcat_alv-ref_fieldname
                         pi_cfieldname    TYPE slis_fieldcat_alv-cfieldname
                         pi_outputlen     TYPE slis_fieldcat_alv-outputlen
                         pi_reptext       TYPE slis_fieldcat_alv-reptext_ddic
                         pi_just          TYPE slis_fieldcat_alv-just
                         pi_DATATYPE      TYPE slis_fieldcat_alv-DATATYPE
                         pi_do_sum        TYPE slis_fieldcat_alv-do_sum
                         pi_no_out        TYPE slis_fieldcat_alv-no_out
                         pi_hotspot       TYPE slis_fieldcat_alv-hotspot
                         pi_icon          TYPE slis_fieldcat_alv-icon
                changing ct_fieldcat     TYPE slis_t_fieldcat_alv.

  DATA:
    ls_fieldcat TYPE slis_fieldcat_alv.

  gi_index = gi_index + 1.

  IF pi_no_out <> 'X'.
    ls_fieldcat-col_pos       = gi_index.
  ENDIF.
    ls_fieldcat-key           = pi_key.
    ls_fieldcat-tabname       = pi_tabname.
    ls_fieldcat-fieldname     = pi_fieldname.
    ls_fieldcat-ref_fieldname = pi_ref_fieldname.
    ls_fieldcat-ref_tabname   = pi_ref_tabname.
    ls_fieldcat-cfieldname    = pi_cfieldname.

  IF pi_cfieldname <> space.
    ls_fieldcat-ctabname      = pi_tabname.
  ENDIF.

  ls_fieldcat-outputlen       = pi_outputlen.
  ls_fieldcat-reptext_ddic    = pi_reptext.
  ls_fieldcat-just            = pi_just.
  ls_fieldcat-DATATYPE        = pi_DATATYPE.
  ls_fieldcat-do_sum          = pi_do_sum.
  ls_fieldcat-no_out          = pi_no_out.
  ls_fieldcat-hotspot         = pi_hotspot.
  ls_fieldcat-icon            = pi_icon.

  append ls_fieldcat to ct_fieldcat.

ENDFORM.

*&---------------------------------------------------------------------*
*&      FORM  f9041_upd_fld
*&---------------------------------------------------------------------*

FORM f9042_upd_fld using pi_col_pos       TYPE slis_fieldcat_alv-col_pos
                         pi_key           TYPE slis_fieldcat_alv-key
                         pi_tabname       TYPE slis_fieldcat_alv-tabname
                         pi_fieldname     TYPE slis_fieldcat_alv-fieldname
                         pi_ref_tabname   TYPE slis_fieldcat_alv-ref_tabname
                         pi_ref_fieldname TYPE slis_fieldcat_alv-ref_fieldname
                         pi_cfieldname    TYPE slis_fieldcat_alv-cfieldname
                         pi_outputlen     TYPE slis_fieldcat_alv-outputlen
                         pi_reptext       TYPE slis_fieldcat_alv-reptext_ddic
                         pi_just          TYPE slis_fieldcat_alv-just
                         pi_DATATYPE      TYPE slis_fieldcat_alv-DATATYPE
                         pi_do_sum        TYPE slis_fieldcat_alv-do_sum
                         pi_no_out        TYPE slis_fieldcat_alv-no_out
                         pi_hotspot       TYPE slis_fieldcat_alv-hotspot
                         pi_icon          TYPE slis_fieldcat_alv-icon
                changing ct_fieldcat      TYPE slis_t_fieldcat_alv.

  field-symbols:
    <fs_fieldcat> like line of ct_fieldcat.

  read table ct_fieldcat assigning <fs_fieldcat> with key fieldname = pi_fieldname.
  IF sy-subrc = 0.
    IF pi_no_out <> 'X'.
      <fs_fieldcat>-col_pos        = pi_col_pos.
    ENDIF.

    <fs_fieldcat>-key            = pi_key.
    <fs_fieldcat>-tabname        = pi_tabname.
    <fs_fieldcat>-fieldname      = pi_fieldname.
    <fs_fieldcat>-ref_fieldname  = pi_ref_fieldname.
    <fs_fieldcat>-ref_tabname    = pi_ref_tabname.
    <fs_fieldcat>-cfieldname     = pi_cfieldname.

    IF pi_cfieldname <> space.
      <fs_fieldcat>-ctabname     = pi_tabname.
    ENDIF.

    <fs_fieldcat>-outputlen      = pi_outputlen.
    <fs_fieldcat>-reptext_ddic   = pi_reptext.
    <fs_fieldcat>-just           = pi_just.
    <fs_fieldcat>-DATATYPE       = pi_DATATYPE.
    <fs_fieldcat>-do_sum         = pi_do_sum.
    <fs_fieldcat>-no_out         = pi_no_out.
    <fs_fieldcat>-hotspot        = pi_hotspot.
    <fs_fieldcat>-icon           = pi_icon.
  ENDIF.

ENDFORM.

*---------------------------------------------------------------------*
*       FORM f9050_set_variant
*---------------------------------------------------------------------*

FORM f9050_set_variant changing cw_vari TYPE disvariant.

  cw_vari-report      = sy-repid.
  cw_vari-handle      = space.
  cw_vari-log_group   = space.
  cw_vari-username    = space.
  cw_vari-variant     = p_vari.
  cw_vari-text        = space.
  cw_vari-dependvars  = space.

ENDFORM.

FORM f9090_pf_status_set using pu_tab_excl_okcode
                          TYPE slis_t_extab.

  set pf-status gtw_config-status excluding pu_tab_excl_okcode.
  set titlebar  'D0100'.

ENDFORM.

*---------------------------------------------------------------------*
*       FORM f9060_call_alv
*---------------------------------------------------------------------*

FORM f9060_call_alv using ut_events   TYPE slis_t_event
                          ut_sortcat  TYPE slis_t_sortinfo_alv
                          ut_fieldcat TYPE slis_t_fieldcat_alv
                          uw_layout   TYPE slis_layout_alv
                          uw_vari     TYPE disvariant.

  DATA:
    lw_is_print   TYPE slis_print_alv.

  call function 'REUSE_ALV_GRID_DISPLAY'
    exporting
      i_callback_program = sy-repid
      i_save             = 'A'
      i_structure_name   = gtw_config-strname
      it_fieldcat        = ut_fieldcat
      is_layout          = uw_layout
      is_variant         = uw_vari
      it_events          = ut_events
      it_sort            = ut_sortcat
      is_print           = lw_is_print
    tables
      t_outtab           = gtd_cabpro[]
    exceptions
      program_error      = 1
    others               = 2.

 " Llamado de función para listar reporte.

  IF sy-subrc <> 0.
    write: 'SY-SUBRC: ', sy-subrc, 'REUSE_ALV_LIST_DISPLAY'.
  ENDIF.

ENDFORM.

*---------------------------------------------------------------------*
*       FORM f9090_top_of_page.
*---------------------------------------------------------------------*

FORM f9090_top_of_page.

  DATA:
    ltd_heading TYPE slis_t_listheader,
    lwa_heading like line of ltd_heading.

    lwa_heading-typ  = 'H'.
    lwa_heading-info = gtw_config-title1.
    append lwa_heading to ltd_heading.

    lwa_heading-typ  = 'S'.
    lwa_heading-key  = 'REPORTE'.
    lwa_heading-info = gtw_config-title2.
    append lwa_heading to ltd_heading.

    lwa_heading-typ  = 'A'.
    lwa_heading-info = gtw_config-title3.
    append lwa_heading to ltd_heading.

  call function 'REUSE_ALV_COMMENTARY_WRITE'
    exporting
      it_list_commentary = ltd_heading.

  clear lwa_heading.

ENDFORM.

*---------------------------------------------------------------------*
*       FORM f9090_user_command
*---------------------------------------------------------------------*

FORM f9090_user_command using r_ucomm like sy-ucomm
                          rs_selfield TYPE slis_selfield.

  DATA:
    lwa_cabpro TYPE gty_cabpro,
    lc_lifnr TYPE lifnr.

  case r_ucomm.
    WHEN '&PROV'. " Muestra detalle del proveedor seleccionado
      PERFORM v002_valida_seleccion changing lc_lifnr.

      IF gf_validacion = 'X'.
        PERFORM  f200_muestra_detalle using lc_lifnr.
        PERFORM f100_extraer_datos. "Actualizar el contenido de la tabla
        rs_selfield-refresh = 'X'.
      ENDIF.
  ENDCASE.

ENDFORM.