*&---------------------------------------------------------------------*
*&  Include           ZMCR0004_MAI
*&---------------------------------------------------------------------*

AT SELECTION-SCREEN OUTPUT.

START-OF-SELECTION.

DATA:
       ltd_bkpf TYPE gtyd_bkpf,
       ltd_bseg  TYPE gtyd_bseg,
       ltd_t003t  TYPE  gtyd_t003t.

PERFORM get_documents USING  ltd_bkpf ltd_bseg.


IF p_std = 'X'.
  PERFORM get_data USING  ltd_bkpf ltd_bseg.
  PERFORM get_type_document USING ltd_t003t ltd_bkpf.
ELSEIF p_std = ''.
   IF p_readp = 'X'.
     PERFORM get_data USING  ltd_bkpf ltd_bseg.
     PERFORM F9000_list_data.
   ELSEIF p_nreadp = 'X'.
     PERFORM not_read_pos USING  ltd_bkpf.
     PERFORM F9000_list_data.
   ENDIF.
ENDIF.