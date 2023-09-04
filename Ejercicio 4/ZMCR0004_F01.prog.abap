*&---------------------------------------------------------------------*
*&  Include           ZMCR0004_F01
*&---------------------------------------------------------------------*


FORM get_documents USING utd_bkpf TYPE gtyd_bkpf
                              utd_bseg TYPE gtyd_bseg.


   SELECT * FROM ztmcr_bkpf
      INTO TABLE utd_bkpf
      WHERE
       belnr IN s_ndoc AND
       blart IN s_clase AND
       bldat IN s_fecha AND
       waers IN s_money.

   SELECT * FROM ztmcr_bseg
    INTO TABLE utd_bseg
    FOR ALL ENTRIES IN utd_bkpf
    WHERE
     belnr = utd_bkpf-belnr AND
     hkont IN s_cmayor.

ENDFORM.




FORM get_data USING utd_bkpf TYPE gtyd_bkpf
                        utd_bseg TYPE gtyd_bseg.

  FIELD-SYMBOLS:
               <fs_bkpf> LIKE LINE OF utd_bkpf,
               <fs_bseg> LIKE LINE OF utd_bseg,
               <fs_out> LIKE LINE OF gtd_out.

  LOOP AT utd_bkpf ASSIGNING <fs_bkpf> .

     LOOP AT utd_bseg ASSIGNING <fs_bseg> WHERE bukrs = <fs_bkpf>-bukrs AND gjahr = <fs_bkpf>-gjahr AND belnr = <fs_bkpf>-belnr .

     APPEND INITIAL LINE TO gtd_out ASSIGNING <fs_out>.
     <fs_out>-bukrs = <fs_bkpf>-bukrs.
     <fs_out>-gjahr = <fs_bkpf>-gjahr.
     <fs_out>-belnr = <fs_bkpf>-belnr.
     <fs_out>-blart = <fs_bkpf>-blart.
     <fs_out>-bldat = <fs_bkpf>-bldat.
     <fs_out>-waers = <fs_bkpf>-waers.
     <fs_out>-buzei = <fs_bseg>-buzei.
     <fs_out>-hkont = <fs_bseg>-hkont.
     <fs_out>-dmbtr = <fs_bseg>-dmbtr.
     <fs_out>-sgtxt = <fs_bseg>-sgtxt.

    ENDLOOP.
  ENDLOOP.

ENDFORM.





FORM not_read_pos USING utd_bkpf TYPE gtyd_bkpf.

    FIELD-SYMBOLS:
               <fs_bkpf> LIKE LINE OF utd_bkpf,
               <fs_doc> LIKE LINE OF gtd_out.

    LOOP AT utd_bkpf ASSIGNING <fs_bkpf>.

     APPEND INITIAL LINE TO gtd_out ASSIGNING <fs_doc>.
     <fs_doc>-bukrs = <fs_bkpf>-bukrs.
     <fs_doc>-gjahr = <fs_bkpf>-gjahr.
     <fs_doc>-belnr = <fs_bkpf>-belnr.
     <fs_doc>-blart = <fs_bkpf>-blart.
     <fs_doc>-bldat = <fs_bkpf>-bldat.
     <fs_doc>-waers = <fs_bkpf>-waers.

    ENDLOOP.



ENDFORM.




FORM get_type_document USING utd_t003t TYPE gtyd_t003t
                                  utd_bkpf TYPE gtyd_bkpf.

  FIELD-SYMBOLS:
                 <fs_t003t> LIKE LINE OF utd_t003t,
                 <fs_bkpf> LIKE LINE OF utd_bkpf.

  DATA:
        lwa_t003t LIKE LINE OF utd_t003t,
        li_total TYPE i,
        li_ltext TYPE t003t-ltext,
        lc_blart TYPE ztmcr_bkpf-blart.

  SELECT mandt
          spras
          blart
          ltext
  INTO TABLE utd_t003t
  FROM t003t AS t
  FOR ALL ENTRIES IN utd_bkpf
  WHERE t~blart = utd_bkpf-blart AND spras = 'ES'.

  SORT utd_bkpf by blart.

  LOOP AT utd_bkpf ASSIGNING <fs_bkpf>.

     AT FIRST.
        li_total = 0.
        lc_blart =  <fs_bkpf>-blart.
     ENDAT.

     IF lc_blart <>  <fs_bkpf>-blart.
        READ TABLE utd_t003t INTO lwa_t003t WITH KEY blart = lc_blart.
        WRITE: li_total, lwa_t003t-blart, lwa_t003t-ltext, /.
        lc_blart =  <fs_bkpf>-blart.
        li_total = 0.
     ENDIF.
      li_total = li_total + 1.

     AT LAST.
       READ TABLE utd_t003t INTO lwa_t003t WITH KEY blart = lc_blart.
        WRITE: li_total, lwa_t003t-blart, lwa_t003t-ltext, /.
     ENDAT.

  ENDLOOP.



ENDFORM.