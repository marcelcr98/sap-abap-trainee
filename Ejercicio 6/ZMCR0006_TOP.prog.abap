*&---------------------------------------------------------------------*
*&  Include           ZMCR0006_TOP
*&---------------------------------------------------------------------*


******** Tablas Transparentes ********

TABLES:
  bsak,
  lfa1.

******** TYPE - POOLS ********

TYPE-POOLS:
  slis.

TYPE-POOLS: icon.


******** Tipos Globales ********

TYPES:
  BEGIN OF gty_cabpro.
    INCLUDE STRUCTURE zmcr_cabpro.
TYPES: chkbox TYPE flag,
       rowcolor(4) TYPE c.
TYPES:
    check TYPE flag,
  END OF gty_cabpro.



TYPES:
  BEGIN OF gty_datcompro.
    INCLUDE STRUCTURE zmcr_datcompro.
TYPES:
  END OF gty_datcompro.

TYPES:
  BEGIN OF gty_out_dyn,
    lifnr       TYPE bsak-lifnr,
    title       TYPE tsad3-title,
    name1       TYPE adrc-name1,
    name2       TYPE adrc-name2,
    sort1       TYPE adrc-sort1,
    sort2       TYPE adrc-sort2,
    street      TYPE adrc-street,
    house_num1  TYPE adrc-house_num1,
    city2       TYPE adrc-city2,
    post_code1  TYPE adrc-post_code1,
    city1       TYPE adrc-city1,
    country     TYPE adrc-country,
    region      TYPE adrc-region,
    time_zone   TYPE adrc-time_zone,
    po_box      TYPE adrc-po_box,
    post_code2  TYPE adrc-post_code2,
    post_code3  TYPE adrc-post_code3,
    langu       TYPE adrc-langu,
    tel_number  TYPE adrc-tel_number,
    fax_number  TYPE adrc-fax_number,
    deflt_comm  TYPE adrc-deflt_comm,
    extension1  TYPE adrc-extension1,
    addrnumber  TYPE adrc-addrnumber,
    landx       TYPE t005t-landx,
    bezei       TYPE t005u-bezei,
    tel_number2 TYPE adr2-tel_number,
    smtp_addr   TYPE adr6-smtp_addr,
  END OF gty_out_dyn.

TYPES:
  BEGIN OF gty_config,
    tbname  TYPE slis_tabname,
    strname TYPE dd02l-tabname,
    order1  TYPE slis_fieldname,
    order2  TYPE slis_fieldname,
    key1    TYPE slis_fieldname,
    key2    TYPE slis_fieldname,
    title1  TYPE slis_entry,
    title2  TYPE slis_entry,
    title3  TYPE slis_entry,
    hotspot TYPE slis_fieldname,
    status  TYPE char100,
  END OF gty_config.



******** Tipos Tablas Globales ********

DATA:
  gi_items   TYPE int4,
  gf_validacion     TYPE flag,
  gi_index      TYPE sy-index,
  gf_moddyn     TYPE flag VALUE '',
  gs_okcode     TYPE syst-uname,
  gtd_config    TYPE STANDARD TABLE OF gty_config,
  gtd_cabpro      TYPE STANDARD TABLE OF gty_cabpro,
  gth_datcompro  TYPE HASHED   TABLE OF gty_datcompro WITH UNIQUE KEY lifnr,
  gth_out_dyn   TYPE HASHED   TABLE OF gty_out_dyn  WITH UNIQUE KEY LIFNR,
  gw_out_dyn    LIKE LINE OF gth_out_dyn,
  gw_datcompro  LIKE LINE OF gth_datcompro,
  gw_temp       LIKE LINE OF gth_datcompro,
  gtw_config    LIKE LINE OF gtd_config.


CONSTANTS:
  gc_formname_top_of_list  TYPE slis_formname VALUE 'F9090_TOP_OF_LIST',
  gc_formname_top_of_page  TYPE slis_formname VALUE 'F9090_TOP_OF_PAGE',
  gc_formname_user_command TYPE slis_formname VALUE 'F9090_USER_COMMAND',
  gc_formname_pf_status    TYPE slis_formname VALUE 'F9090_PF_STATUS_SET'.


******** Envío de Correo ********


DATA:
  gtd_otf      LIKE itcoo    OCCURS 100 WITH HEADER LINE,
  gtd_mess_att LIKE solisti1 OCCURS 0   WITH HEADER LINE,
  gtd_mess_bod LIKE solisti1 OCCURS 0   WITH HEADER LINE,
  gtd_pdf      LIKE tline    OCCURS 100 WITH HEADER LINE.