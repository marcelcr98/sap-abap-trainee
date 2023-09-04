

FORM F9000_list_data .
  DATA:
    ltd_events   TYPE slis_t_event,
    ltd_sortcat  TYPE slis_t_sortinfo_alv,
    ltd_fieldcat TYPE slis_t_fieldcat_alv,
    lw_layout    TYPE slis_layout_alv,
    lw_vari      TYPE disvariant.

  PERFORM F9010_build_eventtab CHANGING ltd_events.
  PERFORM F9020_build_layout   CHANGING lw_layout.
  PERFORM F9030_build_sortcat  CHANGING ltd_sortcat.
  PERFORM F9040_init_fieldcat  CHANGING ltd_fieldcat.
  PERFORM F9050_set_variant    CHANGING lw_vari.
  PERFORM F9060_call_alv       USING ltd_events ltd_sortcat ltd_fieldcat lw_layout lw_vari.
ENDFORM.




FORM F9010_build_eventtab CHANGING ct_events TYPE slis_t_event.

  FIELD-SYMBOLS:
    <fs_event> TYPE slis_alv_event.

  CALL FUNCTION 'REUSE_ALV_EVENTS_GET'
    EXPORTING
      i_list_type = 0
    IMPORTING
      et_events   = ct_events.


  READ TABLE ct_events ASSIGNING <fs_event>
                       WITH KEY name = slis_ev_pf_status_set.
  IF sy-subrc = 0.
    MOVE gc_formname_pf_status TO <fs_event>-form.
  ENDIF.



  READ TABLE ct_events ASSIGNING <fs_event>
                       WITH KEY name = slis_ev_top_of_list.
  IF sy-subrc = 0.
    MOVE gc_formname_top_of_list TO <fs_event>-form.
  ENDIF.



  READ TABLE ct_events ASSIGNING <fs_event>
                       WITH KEY name = slis_ev_user_command.
  IF sy-subrc = 0.
    MOVE gc_formname_user_command TO <fs_event>-form.
  ENDIF.




ENDFORM.




FORM F9020_build_layout CHANGING cw_layout TYPE slis_layout_alv.

  cw_layout-zebra                = 'X'.
  cw_layout-detail_popup         = ' '.
  cw_layout-no_input             = 'X'.
  cw_layout-no_colhead           = ' '.
  cw_layout-lights_condense      = ' '.
  cw_layout-detail_titlebar      = ' '.
  cw_layout-colwidth_optimize    = 'X'.

ENDFORM.





FORM F9030_build_sortcat CHANGING ct_sortcat TYPE slis_t_sortinfo_alv.
  DATA:
    lw_sort     LIKE LINE OF ct_sortcat.


    lw_sort-spos      = 1.
    lw_sort-fieldname = 'BELNR'.
    lw_sort-up = 'X'.
    APPEND lw_sort TO ct_sortcat.

    lw_sort-spos      = 2.
    lw_sort-fieldname = 'BLDAT'.
    lw_sort-up = 'X'.
    APPEND lw_sort TO ct_sortcat.


ENDFORM.




FORM F9040_init_fieldcat CHANGING ct_fieldcat TYPE slis_t_fieldcat_alv.

  DATA:
    lwa_f LIKE LINE OF ct_fieldcat.

  FIELD-SYMBOLS:
    <fs_fcat> LIKE LINE OF ct_fieldcat.

  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
   EXPORTING
     I_PROGRAM_NAME               = sy-repid
     I_INTERNAL_TABNAME           = 'GTD_OUT'
     I_STRUCTURE_NAME             = 'ZMCR_STR'
    CHANGING
      CT_FIELDCAT                  = ct_fieldcat
    EXCEPTIONS
      INCONSISTENT_INTERFACE       = 1
      PROGRAM_ERROR                = 2
      OTHERS                       = 3.

  IF SY-SUBRC <> 0.
   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
           WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.


  CLEAR gi_index.

ENDFORM.




FORM F9041_add_fld USING pi_key           TYPE slis_fieldcat_alv-key
                        pi_tabname       TYPE slis_fieldcat_alv-tabname
                        pi_fieldname     TYPE slis_fieldcat_alv-fieldname
                        pi_ref_tabname   TYPE slis_fieldcat_alv-ref_tabname
                        pi_ref_fieldname TYPE slis_fieldcat_alv-ref_fieldname
                        pi_cfieldname    TYPE slis_fieldcat_alv-cfieldname
                        pi_outputlen     TYPE slis_fieldcat_alv-outputlen
                        pi_reptext       TYPE slis_fieldcat_alv-reptext_ddic
                        pi_just          TYPE slis_fieldcat_alv-just
                        pi_datatype      TYPE slis_fieldcat_alv-datatype
                        pi_do_sum        TYPE slis_fieldcat_alv-do_sum
                        pi_no_out        TYPE slis_fieldcat_alv-no_out
                        pi_hotspot       TYPE slis_fieldcat_alv-hotspot
                        pi_icon          TYPE slis_fieldcat_alv-icon
                CHANGING ct_fieldcat     TYPE slis_t_fieldcat_alv.

  DATA: ls_fieldcat TYPE slis_fieldcat_alv.

  gi_index = gi_index + 1.
  IF pi_no_out <> 'X'.
    ls_fieldcat-col_pos        = gi_index.
  ENDIF.
  ls_fieldcat-key            = pi_key.
  ls_fieldcat-tabname        = pi_tabname.
  ls_fieldcat-fieldname      = pi_fieldname.
  ls_fieldcat-ref_fieldname  = pi_ref_fieldname.
  ls_fieldcat-ref_tabname    = pi_ref_tabname.
  ls_fieldcat-cfieldname     = pi_cfieldname.
  IF pi_cfieldname <> space.
    ls_fieldcat-ctabname       = pi_tabname.
  ENDIF.
  ls_fieldcat-outputlen      = pi_outputlen.
  ls_fieldcat-reptext_ddic   = pi_reptext.
  ls_fieldcat-just           = pi_just.
  ls_fieldcat-datatype       = pi_datatype.
  ls_fieldcat-do_sum         = pi_do_sum.
  ls_fieldcat-no_out         = pi_no_out.
  ls_fieldcat-hotspot        = pi_hotspot.
  ls_fieldcat-icon           = pi_icon.

  APPEND ls_fieldcat TO ct_fieldcat.

ENDFORM.




FORM F9042_upd_fld USING pi_col_pos       TYPE slis_fieldcat_alv-col_pos
                        pi_key           TYPE slis_fieldcat_alv-key
                        pi_tabname       TYPE slis_fieldcat_alv-tabname
                        pi_fieldname     TYPE slis_fieldcat_alv-fieldname
                        pi_ref_tabname   TYPE slis_fieldcat_alv-ref_tabname
                        pi_ref_fieldname TYPE slis_fieldcat_alv-ref_fieldname
                        pi_cfieldname    TYPE slis_fieldcat_alv-cfieldname
                        pi_outputlen     TYPE slis_fieldcat_alv-outputlen
                        pi_reptext       TYPE slis_fieldcat_alv-reptext_ddic
                        pi_just          TYPE slis_fieldcat_alv-just
                        pi_datatype      TYPE slis_fieldcat_alv-datatype
                        pi_do_sum        TYPE slis_fieldcat_alv-do_sum
                        pi_no_out        TYPE slis_fieldcat_alv-no_out
                        pi_hotspot       TYPE slis_fieldcat_alv-hotspot
                        pi_icon          TYPE slis_fieldcat_alv-icon
               CHANGING ct_fieldcat      TYPE slis_t_fieldcat_alv.

  FIELD-SYMBOLS:
    <fs_fieldcat> LIKE LINE OF ct_fieldcat.

  READ TABLE ct_fieldcat ASSIGNING <fs_fieldcat> WITH KEY fieldname = pi_fieldname.
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
      <fs_fieldcat>-ctabname       = pi_tabname.
    ENDIF.
    <fs_fieldcat>-outputlen      = pi_outputlen.
    <fs_fieldcat>-reptext_ddic   = pi_reptext.
    <fs_fieldcat>-just           = pi_just.
    <fs_fieldcat>-datatype       = pi_datatype.
    <fs_fieldcat>-do_sum         = pi_do_sum.
    <fs_fieldcat>-no_out         = pi_no_out.
    <fs_fieldcat>-hotspot        = pi_hotspot.
    <fs_fieldcat>-icon           = pi_icon.
  ENDIF.

ENDFORM.



FORM F9050_set_variant CHANGING cw_vari TYPE disvariant.

  cw_vari-report      = sy-repid.
  cw_vari-handle      = space.
  cw_vari-log_group   = space.
  cw_vari-username    = space.
  cw_vari-variant     = p_vari.
  cw_vari-text        = space.
  cw_vari-dependvars  = space.

ENDFORM.

FORM F9090_pf_status_set USING pu_tab_excl_okcode
                          TYPE slis_t_extab. "#ECCALLED

  SET PF-STATUS 'ALVSET' EXCLUDING pu_tab_excl_okcode.
  SET TITLEBAR  'TITULO'.
ENDFORM.






FORM F9060_call_alv USING ut_events   TYPE slis_t_event
                          ut_sortcat  TYPE slis_t_sortinfo_alv
                          ut_fieldcat TYPE slis_t_fieldcat_alv
                          uw_layout   TYPE slis_layout_alv
                          uw_vari     TYPE disvariant.

   DATA:
    lw_is_print TYPE slis_print_alv.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program       = sy-repid
      i_save                   = 'A'
      i_structure_name         = 'GTD_OUT'
      it_fieldcat              = ut_fieldcat
      is_layout                = uw_layout
      is_variant               = uw_vari
      it_events                = ut_events
      it_sort                  = ut_sortcat
      is_print                 = lw_is_print
    TABLES
      t_outtab                 = gtd_out[]
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.

  IF sy-subrc <> 0.
    WRITE: 'SY-SUBRC: ', sy-subrc, 'REUSE_ALV_LIST_DISPLAY'.
  ENDIF.

ENDFORM.




FORM F9090_top_of_list.
  DATA:
    ltd_heading TYPE slis_t_listheader,
    lwa_heading  LIKE LINE OF ltd_heading.

  lwa_heading-typ  = 'S'.
  lwa_heading-key  = text-s05.
  lwa_heading-info = 'USER PRUEBA'.
  APPEND lwa_heading TO ltd_heading.

  lwa_heading-typ  = 'S'.
  lwa_heading-key  = text-s06.
  lwa_heading-info = sy-uzeit.
  APPEND lwa_heading TO ltd_heading.


  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = ltd_heading.

ENDFORM.




FORM F9090_top_of_page.
  DATA:
    ltd_heading TYPE slis_t_listheader,
    lwa_heading  LIKE LINE OF ltd_heading.

  lwa_heading-typ  = 'S'.
  lwa_heading-key  = 'Reportes'.
  lwa_heading-info = ''.
  APPEND lwa_heading TO ltd_heading.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = ltd_heading.

ENDFORM.




FORM F9090_before_line_output USING pi_lineinfo TYPE kkblo_lineinfo.

ENDFORM.



FORM F9090_after_line_output USING pi_lineinfo TYPE kkblo_lineinfo.

ENDFORM.                    "



FORM F9090_end_of_page.

ENDFORM.




FORM F9090_end_of_list.

ENDFORM.



FORM F9090_caller_exit USING ls_data TYPE slis_data_caller_exit.

ENDFORM.




FORM F9090_user_command USING r_ucomm LIKE sy-ucomm
                              rs_selfield TYPE  slis_selfield.

  DATA:
    ls_valido,
    lwa_out LIKE LINE OF gtd_out.

  CASE r_ucomm.

    WHEN '&IC1'.
      rs_selfield-refresh = 'X'.

      CHECK NOT rs_selfield-value IS INITIAL.

      IF  rs_selfield-sel_tab_field CS 'BELNR'.
        READ TABLE gtd_out INDEX rs_selfield-tabindex INTO lwa_out.


      ENDIF.


  ENDCASE.

ENDFORM.