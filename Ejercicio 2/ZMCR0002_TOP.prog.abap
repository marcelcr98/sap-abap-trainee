*&---------------------------------------------------------------------*
*&  Include           ZMCR0002_TOP
*&---------------------------------------------------------------------*

 TABLES ZTMCR_MOVBAN.

 TYPES:
       gtyd_movban TYPE ZTMCR_MOVBAN.

  DATA:
       gtd_movban TYPE STANDARD TABLE OF ZTMCR_MOVBAN,
       gi_saldo TYPE ztmcr_movban-saldo,
       gi_saldoc TYPE ztmcr_movban-saldo,
       gi_correl TYPE ztmcr_movban-correl.