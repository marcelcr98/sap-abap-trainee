*&---------------------------------------------------------------------*
*&  Include           ZMCR0006_F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      FORM  F01_VALIDAR
*&---------------------------------------------------------------------*

" Rutina para validar días del mes (Primer/Ultimo)

FORM f01_validar changing cs_validacion.

  cs_validacion = ''.

  data:
    ls_primer TYPE sy-datum,
    ls_ultimo TYPE sy-datum.

  call function 'HR_JP_MONTH_BEGIN_END_DATE'
    exporting
      iv_date             = s_bldat-low
    importing
      ev_month_begin_date = ls_primer
      ev_month_end_date   = ls_ultimo.

  IF ls_primer <> s_bldat-low.
    message s000 display like 'E'.
    exit.
  ENDIF.

  IF ls_ultimo <> s_bldat-high.
    message s001 display like 'E'.
    exit.
  ENDIF.

  cs_validacion = 'X'.

ENDFORM.

*&---------------------------------------------------------------------*
*&      FORM  V002_VALIDA_SELECCION
*&---------------------------------------------------------------------*

" Validar proveedor seleccionado

FORM v002_valida_seleccion changing ch_lifnr.

  gf_validacion = ''.

  data:
    li_cant TYPE int4 value 0.

  field-symbols:
    <fs_cabpro> like line of gtd_cabpro.

  loop at gtd_cabpro assigning <fs_cabpro>  where check = 'X'.
    li_cant   = li_cant + 1.
    ch_lifnr  = <fs_cabpro>-lifnr.
  endloop.

  IF li_cant = 0.
    message s002. " Mensaje: Seleccionar un registro
    exit.
  ELSEIF li_cant > 1.
    message s002. " Mensaje: Seleccionar un registro
    exit.
  ENDIF.

  gf_validacion = 'X'.

ENDFORM.


*&---------------------------------------------------------------------*
*&      FORM  F100_EXTRAEE_DATOS
*&---------------------------------------------------------------------*


" Rutina de extraccion de data segun parametros de selección.

FORM f100_extraer_datos.

  TYPES:
    begin of lty_t003t,
      blart TYPE t003t-blart,
      ltext TYPE t003t-ltext,
    end of lty_t003t.

  data:
    lth_t003t TYPE hashed table of lty_t003t with unique key blart.

  field-symbols:
    <fs_cabpro>      like line of gtd_cabpro,
    <fs_datcompro>  like line of gth_datcompro,
    <fs_t003t>     like line of lth_t003t,
    <fs_out_dyn>   like line of gth_out_dyn.

  "Seleccion de los campos solicitados para el reporte

  select b~mandt b~lifnr b~belnr b~blart b~bldat b~budat
         b~waers b~shkzg b~wrbtr b~dmbtr l~name1
  into corresponding fields of table gtd_cabpro
    from bsak as b
    left join lfa1 as l
      on b~lifnr  = l~lifnr
    where b~bukrs = p_bukrs
      and b~bldat in s_bldat
      and b~belnr in s_belnr
      and b~blart in s_blart
      and b~lifnr in s_lifnr.

  describe table gtd_cabpro lines gi_items.

  IF gi_items <= 0.
    message i003. "No se encontraron registros
    exit.
  ENDIF.

  select *
    into table gth_datcompro
    from zmcr_datcompro.

  PERFORM f120_extrae_detalle. "Extraer  Detalle del proveedor

   loop at gtd_cabpro assigning <fs_cabpro>.

   IF <fs_cabpro>-blart = ''.
      <fs_cabpro>-icono = icon_red_light.
      <fs_cabpro>-rowcolor = 'C600'.
   ELSE .
      <fs_cabpro>-icono = icon_green_light.
   ENDIF.

    IF gw_out_dyn-smtp_addr = ''.
      <fs_cabpro>-icono = icon_red_light.
      <fs_cabpro>-rowcolor = 'C600'.
   ELSE .
      <fs_cabpro>-icono = icon_green_light.
   ENDIF.



   IF <fs_cabpro>-shkzg = 'H'.
      <fs_cabpro>-wrbtr = <fs_cabpro>-wrbtr * -1.
      <fs_cabpro>-dmbtr = <fs_cabpro>-dmbtr * -1.

      <fs_cabpro>-rowcolor = 'C600'.

    ENDIF.

    "IF gw_out_dyn-smtp_addr = ''.
    "IF gw_out_dyn-smtp_addr = ''.
    IF <fs_cabpro>-shkzg = 'H'.
       <fs_cabpro>-rowcolor = 'C600'.
    ELSE.
       <fs_cabpro>-rowcolor = 'C600'.



    ENDIF.

    read table lth_t003t assigning <fs_t003t> with table key blart = <fs_cabpro>-blart.

    IF sy-subrc = 0.
      <fs_cabpro>-ltext = <fs_t003t>-ltext.
    ENDIF.

  endloop.

ENDFORM.



*&---------------------------------------------------------------------*
*&      FORM  F200_MUESTRA_DETALLE
*&---------------------------------------------------------------------*

" Rutina para llenar los campos en la Dynpro


*----------------------------------------------------------------------*
*  -->  US_LIFNR     CODIGO DE PROVEEDOR
*----------------------------------------------------------------------*

FORM f200_muestra_detalle using us_lifnr.

  field-symbols:
    <fs_out_dyn>  like line of gth_out_dyn,
    <fs_datcompro> like line of gth_datcompro.

  " Lectura de tabla de datos
  read table gth_out_dyn assigning <fs_out_dyn> with table key lifnr =  us_lifnr.

  IF sy-subrc = 0.
    gw_out_dyn = <fs_out_dyn>.
  ENDIF.

   " Lectura de tabla de datos
  read table gth_datcompro assigning <fs_datcompro> with table key lifnr = us_lifnr.

  IF sy-subrc = 0.
    gw_datcompro = <fs_datcompro>.
    gw_temp = <fs_datcompro>.
  ELSE.
    gw_datcompro-lifnr = us_lifnr.
    gw_temp-lifnr = us_lifnr.
  ENDIF.

  call screen 0100 starting at 35 20.

ENDFORM.


"  Datos de configuracion de reporte ALV

" us_Type => Tipo de reporte a mostrar

FORM f300_config using us_TYPE TYPE int1.

  clear gtw_config.

  case us_TYPE.
    when 1. " Datos para la cabecera del reporte
      gtw_config-tbname   = 'GTD_CABPRO'.
      gtw_config-strname  = 'ZMCR_CABPRO'.
      gtw_config-order1   = 'LIFNR'.
      gtw_config-order2   = 'NAME1'.
      gtw_config-key1     = 'LIFNR'.
      gtw_config-title1   = 'DATOS COMERCIALES'.
      gtw_config-title2   = '001'.
      gtw_config-title3   = 'DATOS FILTRADOS DE PROVEEDORES'.
      gtw_config-status   = 'STATUS1'.
    when others.
      exit.
  endcase.

ENDFORM.


*&---------------------------------------------------------------------*
*&      FORM  F120_EXTRAE_DETALLE
*&---------------------------------------------------------------------*

*------ Rutina de extraccipon de detalle para la dynpro---------*

FORM f120_extrae_detalle.

  TYPES:
    begin of lty_t005t,
      land1 TYPE t005t-land1,
      landx TYPE t005t-landx,
    end of lty_t005t,

    begin of lty_t005u,
      bland TYPE t005u-bland,
      bezei TYPE t005u-bezei,
    end of lty_t005u,

    begin of lty_adr2,
      addrnumber TYPE adr2-addrnumber,
      tel_number TYPE adr2-tel_number,
    end of lty_adr2,


    begin of lty_adr3,
      addrnumber TYPE adr2-addrnumber,
      tel_number TYPE adr2-tel_number,
    end of lty_adr3,

    begin of lty_adr6,
      addrnumber TYPE adr6-addrnumber,
      smtp_addr  TYPE adr6-smtp_addr,
    end of lty_adr6.

  data:
    lth_t005t TYPE hashed table of lty_t005t with unique key land1,
    lth_t005u TYPE hashed table of lty_t005u with unique key bland,
    lth_adr2  TYPE hashed table of lty_adr2  with unique key addrnumber,
    lth_adr3  TYPE hashed table of lty_adr3  with unique key addrnumber,
    lth_adr6  TYPE hashed table of lty_adr6  with unique key addrnumber.

  field-symbols:
    <fs_out_dyn> like line of gth_out_dyn,
    <fs_t005t>   like line of lth_t005t,
    <fs_t005u>   like line of lth_t005u,
    <fs_adr2>    like line of lth_adr2,
    <fs_adr6>    like line of lth_adr6.

 " Seleccion de campos  que se visualizaran en la dynpro

  select b~lifnr      a~title      a~name1      a~name2      a~sort1      a~sort2
         a~street     a~house_num1 a~city2      a~post_code1 a~city1      a~country
         a~region     a~time_zone  a~po_box     a~post_code2 a~post_code3 a~langu
         a~tel_number a~fax_number a~deflt_comm a~extension1 a~addrnumber
    into table gth_out_dyn
    from bsak  as b
    inner join lfa1 as l
       on b~lifnr = l~lifnr
    inner join adrc as a
       on l~adrnr = a~addrnumber
    for all entries in gtd_cabpro
    where b~lifnr = gtd_cabpro-lifnr.

    select land1 landx
      into table lth_t005t
      from t005t
      for all entries in gth_out_dyn
      where land1 = gth_out_dyn-country
        and spras = sy-langu.

    select bland bezei
      into table lth_t005u
      from t005u
      for all entries in gth_out_dyn
      where spras = sy-langu
        and land1 = gth_out_dyn-country
        and bland = gth_out_dyn-region.

   select addrnumber tel_number
     into table lth_adr2
     from adr2
     for all entries in gth_out_dyn
     where addrnumber = gth_out_dyn-addrnumber.


 "   select addrnumber
  "   delete from lth_adr3
   "  where addrnumber = gth_out_dyn-addrnumber.


   select addrnumber smtp_addr
     into table lth_adr6
     from adr6
     for all entries in gth_out_dyn
     where addrnumber = gth_out_dyn-addrnumber.

  loop at gth_out_dyn assigning <fs_out_dyn> .
    read table lth_t005t assigning <fs_t005t> with table key land1 = <fs_out_dyn>-country.
    IF sy-subrc = 0.
      <fs_out_dyn>-landx = <fs_t005t>-landx.
    ENDIF.

    read table lth_t005u assigning <fs_t005u> with table key bland = <fs_out_dyn>-region.
    IF sy-subrc = 0.
       <fs_out_dyn>-bezei = <fs_t005u>-bezei .
    ENDIF.

    read table lth_adr2 assigning <fs_adr2> with table key addrnumber = <fs_out_dyn>-addrnumber.
    IF sy-subrc = 0.
      <fs_out_dyn>-tel_number = <fs_adr2>-tel_number .
    ENDIF.

    read table lth_adr6 assigning <fs_adr6> with table key addrnumber = <fs_out_dyn>-addrnumber.
    IF sy-subrc = 0.
      <fs_out_dyn>-smtp_addr = <fs_adr6>-smtp_addr.
    ENDIF.
  endloop.

ENDFORM.

*------ eventos dynpro---------*

*&---------------------------------------------------------------------*
*&      FORM  F400_USER_COMMAND
*&---------------------------------------------------------------------*

" Captura de eventos para la dynpro

" us_okcode => Codigo de user command

FORM f400_user_command  using  us_okcode.

  data:
    lc_answer TYPE c,
    ls_prov   TYPE so_obj_nam,
    ls_addr   TYPE somlreci1-receiver,
    ls_addr1  TYPE somlreci1-receiver.

  field-symbols:
    <fs_datcompro> like line of gth_datcompro.

  " Validar Modificacion

  PERFORM v003_valida_modIF using gf_moddyn.

  case us_okcode.

    when '&SAVE'.
      IF gf_moddyn <> 'X'.
        message i015 . " Mensaje : No se encontraron cambios
        exit.
        leave to screen 0.
      ENDIF.
      call function 'POPUP_TO_CONFIRM'
        exporting
          titlebar                    = text-d01 " Mensaje confirmacion
          text_question               = text-d02 " Opciones Aceptar o Cancelar
          display_cancel_button       = ''
       importing
          answer                      = lc_answer.
      case lc_answer.
        when '1'. "Guardar cambios
          read table gth_datcompro assigning <fs_datcompro> with table key lifnr = gw_datcompro-lifnr.
          IF sy-subrc = 0.
            gw_datcompro-uname_upd = sy-uname.
            gw_datcompro-datum_upd = sy-datum.
            gw_datcompro-uzeit_upd = sy-uzeit.
            update zmcr_datcompro from gw_datcompro.
            message i011.
            exit.
            leave to screen 0.

          ELSE.
            gw_datcompro-uname = sy-uname.
            gw_datcompro-datum = sy-datum.
            gw_datcompro-uzeit = sy-uzeit.
            insert into zmcr_datcompro values gw_datcompro.
            message i013.
            exit.
            leave to screen 0.
          ENDIF.
          gw_temp = gw_datcompro.
        when '2'. "No guardar cambios.
          exit.
        when others.
          exit.
      endcase.

    when '&OK'.
      PERFORM f500_exit_command.

    when '&CORREO'. "Enviar Corrreo
      ls_prov = gw_out_dyn-lifnr.
      ls_addr = gw_out_dyn-smtp_addr.
      ls_addr1 = sy-uname.
      PERFORM f410_envio_correo using ls_prov ls_addr ls_addr1.

    when others.
      exit.
  endcase.

ENDFORM.


*------ rutina para salir de la dynpro---------*

*&---------------------------------------------------------------------*
*&      FORM  F500_EXIT_COMMAND
*&---------------------------------------------------------------------*

" Rutina al ejecutar para salir de la Dynpro


FORM f500_exit_command.

  data:
    lc_answer TYPE c.

  PERFORM v003_valida_modIF using gf_moddyn.

  IF gf_moddyn <> 'X'. " Opcionar salir
    message s005 . " Mensaje: No se encontraron cambios.
    leave to screen 0.
  ENDIF.
   " Permitir confirmación al salir.
   call function 'POPUP_TO_CONFIRM'
     exporting
       titlebar              = text-d03 "'CONFIRMAR DESCARTE'
       text_question         = text-d04 "'Opciones Aceptar y Cancelar.
       display_cancel_button = ''
     importing
       answer                = lc_answer.

    case lc_answer.
      when '1'.     "si
        clear gw_datcompro.
        clear gw_out_dyn.
        leave to screen 0.
      when others.
        exit.
    endcase.

ENDFORM.

*------ envío de correo---------*

*&---------------------------------------------------------------------*
*&      FORM  f410_envio_correo
*&---------------------------------------------------------------------*


*----------------------------------------------------------------------*
*  -->  us_proveedor        Codigo de proveedor
*  -->  us_emaildest        Correo destino
*  -->  us_emailfuente      Correo fuente*
*----------------------------------------------------------------------*

FORM f410_envio_correo using us_proveedor   TYPE so_obj_nam
                             us_emaildest   TYPE somlreci1-receiver
                             us_emailfuente TYPE somlreci1-receiver.

  field-symbols:
    <fs_cabpro> like line of gtd_cabpro.

  data:
    li_cnt                 TYPE i,
    ls_attachment_desc     TYPE so_obj_nam,
    ls_attachment_name     TYPE so_obj_des,
    ls_attdescription      TYPE so_obj_nam ,
    ls_attfilename         TYPE so_obj_des ,
    ls_email               like somlreci1-receiver,
    ls_format              TYPE so_obj_tp ,
    ls_sender_address      like soextreci1-receiver,
    ls_sender_address_TYPE like soextreci1-adr_typ,
    ls_sender_TYPE         like soextreci1-adr_typ,
    ls_sent_all(1)         TYPE c,
    ls_subject             like sodocchgi1-obj_descr,
    ls_ret_receiver        like sy-subrc,
    ltd_packing_list       like sopcklsti1 occurs 0 with header line,
    ltd_receivers          like somlreci1  occurs 0 with header line,
    ltd_attachment         like solisti1   occurs 0 with header line,
    lwa_doc_data           like sodocchgi1,
    lc_dmbtr               TYPE char15.

  " Formulario para enviar el correo en el proveedor seleccionado.

  refresh gtd_mess_bod.

  concatenate 'Pago proveedor-'us_proveedor into ls_subject.
  ls_attachment_desc = 'Pago proveedor'.
  move '<html><body>' to gtd_mess_bod.
  append gtd_mess_bod.

  concatenate '<p>' 'Estimado proveedor' '-' gw_out_dyn-name1 '</p>'
  into gtd_mess_bod separated by space.
  append gtd_mess_bod.

  concatenate '<p>' 'Usted dispone de los siguientes documentos pagados: ' '</p>'
  into gtd_mess_bod separated by space.
  append gtd_mess_bod.

  gtd_mess_bod = '<table>'.
  append gtd_mess_bod.

  concatenate'<tr><td><strong>'     'N° doc'    '</strong></td>'    into gtd_mess_bod separated by space..
  append gtd_mess_bod.
  concatenate'<td><strong>' ' | ' 'Fecha doc' '</strong></td>'      into gtd_mess_bod separated by space..
  append gtd_mess_bod.
  concatenate'<td><strong>' ' | ' 'Monto'     '</strong></td></tr>' into gtd_mess_bod separated by space..
  append gtd_mess_bod.

  loop at gtd_cabpro assigning <fs_cabpro> where lifnr = us_proveedor.
    concatenate '<tr><td>' <fs_cabpro>-belnr '</td>'       into gtd_mess_bod separated by space..
    append gtd_mess_bod.

    concatenate '<td>' ' | ' <fs_cabpro>-bldat '</td>'     into gtd_mess_bod separated by space..
    append gtd_mess_bod.

    lc_dmbtr = <fs_cabpro>-dmbtr.

    concatenate '<td>' ' | ' lc_dmbtr       '</td></tr>' into gtd_mess_bod separated by space..
    append gtd_mess_bod.
  endloop.

  gtd_mess_bod = '</table>'.
  append gtd_mess_bod.

  move  '</body></html>' to gtd_mess_bod.
  append gtd_mess_bod.

  clear us_emailfuente.
  IF us_emailfuente eq space.
    ls_sender_type  = space.
  ELSE.
    ls_sender_type = 'INT'.
  ENDIF.

  ls_email               = us_emaildest.
  ls_format              = 'html'.
  ls_attdescription      = ls_attachment_desc.
  ls_attfilename         = ls_attachment_name.
  ls_sender_address      = us_emailfuente.
  ls_sender_address_TYPE = ls_sender_TYPE.

  clear lwa_doc_data.
  read table gtd_mess_att index li_cnt.
  lwa_doc_data-doc_size   = ( li_cnt - 1 ) * 255 + strlen( gtd_mess_att ).
  lwa_doc_data-obj_langu  = sy-langu.
  lwa_doc_data-obj_name   = 'SAPRPT'.
  lwa_doc_data-obj_descr  = ls_subject.
  lwa_doc_data-sensitivty = 'f'.
  clear ltd_attachment.
  refresh ltd_attachment.
  ltd_attachment[] = gtd_mess_att[].

  clear ltd_packing_list.
  refresh ltd_packing_list.

  ltd_packing_list-transf_bin = space.
  ltd_packing_list-head_start = 1.
  ltd_packing_list-head_num = 0.
  ltd_packing_list-body_start = 1.

  describe table gtd_mess_bod lines ltd_packing_list-body_num.

  ltd_packing_list-doc_TYPE = 'htm'.
  append ltd_packing_list.

  clear ltd_receivers.
  refresh ltd_receivers.

  ltd_receivers-receiver = ls_email.
  ltd_receivers-rec_TYPE = 'U'.
  ltd_receivers-com_TYPE = 'int'.
  append ltd_receivers.

  ltd_receivers-receiver = us_emailfuente.
  ltd_receivers-rec_TYPE = 'U'.
  ltd_receivers-com_TYPE = 'int'.
  ltd_receivers-copy = 'X'.
  append ltd_receivers.

  call function 'SO_DOCUMENT_SEND_API1'
     exporting
       document_data              = lwa_doc_data
       put_in_outbox              = 'x'
       sender_address             = ls_sender_address
       sender_address_TYPE        = ls_sender_address_TYPE
       commit_work                = 'x'
     importing
       sent_to_all                = ls_sent_all
     tables
       packing_list               = ltd_packing_list
       contents_bin               = ltd_attachment
       contents_txt               = gtd_mess_bod
       receivers                  = ltd_receivers
     exceptions
       too_many_receivers         = 1
       document_not_sent          = 2
       document_type_not_exist    = 3
       operation_no_authorization = 4
       parameter_error            = 5
       x_error                    = 6
       enqueue_error              = 7
       others                     = 8.

*------ messages de correo (enviado o no enviado)---------*

  IF sy-subrc = 0.
    message i009. "Envío de correo exitoso
  ELSE.
    message i006. "No se pudo enviar el correo
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      FORM  v003_valida_modif
*&---------------------------------------------------------------------*

*------ validar modIFicacion---------*



FORM v003_valida_modif using us_moddyn.

  IF gw_temp = gw_datcompro.
    us_moddyn = ''.
  ELSE.
    us_moddyn = 'X'.
  ENDIF.

ENDFORM.

*------ muestra y oculta boton de enviar correo---------*


FORM v004_valida_correo.

  IF gw_out_dyn-smtp_addr cp '*@*.*' and gw_out_dyn-smtp_addr <> ' '.
    set pf-status 'D0100_DETALLEC'.
  ELSE.
    set pf-status 'D0100_DETALLE'.
  ENDIF.

ENDFORM.