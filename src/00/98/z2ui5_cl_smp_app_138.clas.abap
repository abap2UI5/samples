CLASS z2ui5_cl_smp_app_138 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA:
      BEGIN OF ms_data,
        BEGIN OF ms_data2,
          BEGIN OF ms_data2,
            BEGIN OF ms_data2,
              BEGIN OF ms_data2,
                BEGIN OF ms_data2,
                  val TYPE string,
                  BEGIN OF ms_data2,
                    val TYPE string,
                  END OF ms_data2,
                END OF ms_data2,
                val TYPE string,
              END OF ms_data2,
              val TYPE string,
            END OF ms_data2,
            val TYPE string,
          END OF ms_data2,
          val TYPE string,
        END OF ms_data2,
        val2 TYPE string,
      END OF ms_data.

    DATA quantity TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_138 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      ms_data-ms_data2-ms_data2-ms_data2-ms_data2-ms_data2-ms_data2-val  = `tomato`.
      quantity = `500`.

      DATA(view) = z2ui5_cl_ui5_view_builder=>factory( )->ele( n = `View` ns = `mvc`
          )->a( n = `displayBlock` v = `true`
          )->a( n = `height`       v = `100%`
          )->a( n = `xmlns`        v = `sap.m`
          )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
          )->a( n = `xmlns:core`   v = `sap.ui.core`
          )->a( n = `xmlns:form`   v = `sap.ui.layout.form` ).
      client->view_display( view->ele( `Shell` )->ele( `Page`
                )->a( n = `title`          v = `abap2UI5 - First Example`
                )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
                )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) )->ele( n = `SimpleForm` ns = `form`
                    )->a( n = `title`    v = `Form Title`
                    )->a( n = `editable` b = abap_true )->ele( n = `content` ns = `form` )->tag( `Title`
                            )->a( n = `text` v = `Input` )->tag( `Label`
                            )->a( n = `text` v = `quantity` )->tag( `Input`
                            )->a( n = `value` v = client->_bind( quantity ) )->tag( `Label`
                            )->a( n = `text` v = `product` )->tag( `Input`
                            )->a( n = `value` v = client->_bind( ms_data-ms_data2-ms_data2-ms_data2-ms_data2-ms_data2-ms_data2-val ) )->tag( `Button`
                            )->a( n = `press` v = client->_event( `BUTTON_POST` )
                            )->a( n = `text`  v = `post` )->stringify( ) ).

    ENDIF.

    CASE client->get_event( ).

      WHEN `BUTTON_POST`.
        client->message_toast_display( |{ quantity } - send to the server| ).
    ENDCASE.

  ENDMETHOD.

ENDCLASS.
