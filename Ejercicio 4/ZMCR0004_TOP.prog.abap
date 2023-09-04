*&---------------------------------------------------------------------*
*&  Include           ZMCR0004_TOP
*&---------------------------------------------------------------------*


 TABLES:
       ztmcr_bkpf,
       ztmcr_bseg,
       t003t.


TYPE-POOLS:
  kkblo,
  slis.



 TYPES: "estructura interna para alv rep.
      gtyd_bkpf TYPE STANDARD TABLE OF ztmcr_bkpf,
      gtyd_bseg TYPE STANDARD TABLE OF ztmcr_bseg,
      gtyd_t003t TYPE STANDARD TABLE OF t003t .


  TYPES:
       BEGIN OF gty_doc.
       INCLUDE STRUCTURE ZMCR_STR.
  TYPES:
       END OF gty_doc.

   TYPES:
      gtyd_doc TYPE STANDARD TABLE OF gty_doc.

  DATA:
      gtd_out TYPE STANDARD TABLE OF gty_doc.


  DATA:
       gr_numdoc TYPE RANGE OF ztmcr_bkpf-belnr,
       gr_cladoc TYPE RANGE OF ztmcr_bkpf-blart,
       gr_fecdoc TYPE RANGE OF ztmcr_bkpf-bldat,
       gr_moneda TYPE RANGE OF ztmcr_bkpf-waers,
       gr_ctmayo TYPE RANGE OF ztmcr_bseg-hkont,
       gi_index TYPE sy-index,
       gc_estad TYPE char100.

  CONSTANTS:
    gc_zdet                  TYPE syst-ucomm  VALUE '&ZDET',
    gc_zref                  TYPE syst-ucomm  VALUE '&ZREF',
    gc_formname_top_of_list  TYPE slis_formname VALUE 'F9090_TOP_OF_LIST',
    gc_formname_top_of_page  TYPE slis_formname VALUE 'F9090_TOP_OF_PAGE',
    gc_formname_user_command TYPE slis_formname VALUE 'F9090_USER_COMMAND',
    gc_formname_pf_status    TYPE slis_formname VALUE 'F9090_PF_STATUS_SET'.




  "ZMCR_STR STANDARD TABLE