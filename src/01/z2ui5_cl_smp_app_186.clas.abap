" @keywords export save base64 attachment xstring document
" @summary Sends a file to the browser as a download - an xstring encoded as base64, handed over as an attachment.
" @docs https://abap2ui5.github.io/docs/cookbook/device_capabilities/upload_download
CLASS z2ui5_cl_smp_app_186 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA file_content_64 TYPE string.
    DATA file_name TYPE string.
    DATA mime_type TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS initialize.
    METHODS on_event.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_186 IMPLEMENTATION.

  METHOD initialize.

    file_name = `Default_File_Name.jpg`.
    mime_type = `text/plain`.
    file_content_64 = `data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAApgAAA` &&
      `KYB3X3/OAAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAANCSURBVEiJtZZPbBtFFMZ/M7ubXdtdb1xSFyeilBapySVU8h8OoFaooFSqiihIVIp` &&
      `QBKci6KEg9Q6H9kovIHoCIVQJJCKE1ENFjnAgcaSGC6rEnxBwA04Tx43t2FnvDAfjkNibxgHxnWb2e/u992bee7tCa00YFsffekFY+nUzFtjW0LrvjRXrCDIAaPLlW` &&
      `0nHL0SsZtVoaF98mLrx3pdhOqLtYPHChahZcYYO7KvPFxvRl5XPp1sN3adWiD1ZAqD6XYK1b/dvE5IWryTt2udLFedwc1+9kLp+vbbpoDh+6TklxBeAi9TL0taeWpd` &&
      `mZzQDry0AcO+jQ12RyohqqoYoo8RDwJrU+qXkjWtfi8Xxt58BdQuwQs9qC/afLwCw8tnQbqYAPsgxE1S6F3EAIXux2oQFKm0ihMsOF71dHYx+f3NND68ghCu1YIoeP` &&
      `PQN1pGRABkJ6Bus96CutRZMydTl+TvuiRW1m3n0eDl0vRPcEysqdXn+jsQPsrHMquGeXEaY4Yk4wxWcY5V/9scqOMOVUFthatyTy8QyqwZ+kDURKoMWxNKr2EeqVKc` &&
      `TNOajqKoBgOE28U4tdQl5p5bwCw7BWquaZSzAPlwjlithJtp3pTImSqQRrb2Z8PHGigD4RZuNX6JYj6wj7O4TFLbCO/Mn/m8R+h6rYSUb3ekokRY6f/YukArN979jc` &&
      `W+V/S8g0eT/N3VN3kTqWbQ428m9/8k0P/1aIhF36PccEl6EhOcAUCrXKZXXWS3XKd2vc/TRBG9O5ELC17MmWubD2nKhUKZa26Ba2+D3P+4/MNCFwg59oWVeYhkzgN/` &&
      `JDR8deKBoD7Y+ljEjGZ0sosXVTvbc6RHirr2reNy1OXd6pJsQ+gqjk8VWFYmHrwBzW/n+uMPFiRwHB2I7ih8ciHFxIkd/3Omk5tCDV1t+2nNu5sxxpDFNx+huNhVT3` &&
      `/zMDz8usXC3ddaHBj1GHj/As08fwTS7Kt1HBTmyN29vdwAw+/wbwLVOJ3uAD1wi/dUH7Qei66PfyuRj4Ik9is+hglfbkbfR3cnZm7chlUWLdwmprtCohX4HUtlOcQj` &&
      `LYCu+fzGJH2QRKvP3UNz8bWk1qMxjGTOMThZ3kvgLI5AzFfo379UAAAAASUVORK5CYII=`.

  ENDMETHOD.


  METHOD on_event.
      DATA temp1 TYPE string_table.

    IF client->check_on_event( `BUTTON_DOWNLOAD` ) IS NOT INITIAL.
      
      CLEAR temp1.
      INSERT file_content_64 INTO TABLE temp1.
      INSERT file_name INTO TABLE temp1.
      client->follow_up_action(
          val   = client->cs_event-download_b64_file
          t_arg = temp1 ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core` ).

    
    page = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - File - Download to the Browser`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `The download_b64_file front-end action hands a base64 encoded file to the browser, which saves it ` &&
                   `under the given name - no ICF download service and no extra request needed.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    page->ele( `FlexBox`
        )->a( n = `width`          v = `100%`
        )->a( n = `height`         v = `600px`
        )->a( n = `alignItems`     v = `Center`
        )->a( n = `justifyContent` v = `SpaceAround`
        )->ele( `VBox`
            )->tag( `Text`
                )->a( n = `text` v = `Base64 String:`
            )->tag( `TextArea`
                )->a( n = `value`    v = client->_bind( file_content_64 )
                )->a( n = `rows`     v = `20`
                )->a( n = `width`    v = `800px`
                )->a( n = `wrapping` v = `Soft`
        )->end(
        )->ele( `VBox`
            )->a( n = `justifyContent` v = `Center`
            )->a( n = `alignItems`     v = `Center`
            )->tag( `Text`
                )->a( n = `text` v = `fill filename:`
            )->tag( `Input`
                )->a( n = `value` v = client->_bind( file_name )
                )->a( n = `class` v = `sapUiLargeMarginBottom`
                )->a( n = `width` v = `15rem`
            )->tag( `Button`
                )->a( n = `press` v = client->_event( `BUTTON_DOWNLOAD` )
                )->a( n = `text`  v = `Open Download Popup`
                )->a( n = `type`  v = `Emphasized` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.

      initialize( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).

    ENDIF.

    on_event( ).

  ENDMETHOD.

ENDCLASS.
