" @keywords audio sound beep notification play_audio alert acoustic feedback data uri
" @summary Plays a sound in the browser with the play_audio follow-up action - a short beep the app carries as a data URI, so nothing is fetched.
CLASS z2ui5_cl_smp_app_531 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA log TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS play
      IMPORTING url TYPE string.
    METHODS beep_data_uri
      RETURNING VALUE(result) TYPE string.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_531 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      log = `Nothing played yet.`.
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `BEEP`.
        play( beep_data_uri( ) ).
        log = `Played the beep the app carries.`.

      WHEN `REFUSED`.
        " the frontend validates the source before it builds an Audio: only
        " http(s), data: and blob: reach the browser. Anything else is
        " refused and logged there - nothing plays, and the roundtrip is
        " unaffected, so an app cannot tell from ABAP whether a sound came
        " out. Open the browser console to see the refusal
        play( `javascript:alert(1)` ).
        log = `Sent a javascript: URL - refused in the frontend, see the browser console.`.

    ENDCASE.

    view_display( ).

  ENDMETHOD.


  METHOD play.

    client->follow_up_action( val   = client->cs_event-play_audio
                              t_arg = VALUE #( ( url ) ) ).

  ENDMETHOD.


  METHOD beep_data_uri.

    " A 70 ms 880 Hz tone, 8 kHz 8-bit mono WAV, fading out so it ends
    " without a click - 604 bytes, carried in the source so the sample needs
    " no MIME repository, no server and no network.
    result = `data:audio/wav;base64,` &&
        `UklGRlQCAABXQVZFZm10IBAAAAABAAEAQB8AAEAfAAABAAgAZGF0YTACAACAzPXoq1sbCi94xfHqsWIhCytxvu7rt2onDSdqtunsvHEtDyRkr+XswXk0EiJdqODrxX86FSBYodvqyYZBGB9SmtXpzY` &&
        `1HHB5Nk9Dnz5NOIB5JjMrl0plUJB5EhsTj1J5bKR5BgL7g1aNhLR89ebjd1qhoMiE6dLLZ161uOCI4bqzV17F0PSQ2aabR17R6Qic0ZKDN1riASCozX5rJ1bqFTS0yW5XE1L2KUzAyV4+/0r+PWDQy` &&
        `VIq60MGTXTcyUYS1zsKYYzszToCxy8OcaD80THusyMOfbUQ2SnanxcOickg4SHKiwcOld0w6R26dvsKoe1E8RmuYusGqf1U/RmeUt8CshFpBRmSPs76th15ERmKLr72ui2JIRl+Hq7uvjmdLR12Dp7` &&
        `iwkWtOSFx/o7awlG9SSlt8n7OwlnJVS1p5m7CvmHZZTVl2l66umnlcT1h0lKutm31gUVhxkKesnH9jVFlvjaSrnYJmVlluiqGpnoVqWVpsh56nnodtW1trhJulnolwXlxqgpijnopzYV1qgJWhnYx1` &&
        `ZF9pfZKenI14ZmFpfJCcm456aWNpeo2amo58bGVqeYuXmY9+bmdreIiVl49/cWlrd4aSlY6Bc2tsd4WQlI6CdW1udoOOko2Dd29vdoKMkI2DeXJxd4CJjouEenRyd4CIjIqEfHZ0eH+GiomEfXh2eX` &&
        `6EiIeDfnp4en6DhoaDf3t6e36ChISCf318fX+BgoKBgH5+fn+AgICAgA==`.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc` ).

    DATA(page) = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Browser - Play a Sound`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `The backend asks the browser to play a sound with follow_up_action( cs_event-play_audio ). ` &&
                   `Browsers only allow audio that a user gesture started, and a button press is one - a sound played on ` &&
                   `init alone would be blocked. The source is validated in the frontend: http(s), data: and blob: only.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    page->ele( `VBox`
        )->a( n = `class` v = `sapUiSmallMargin`

        )->tag( `Button`
            )->a( n = `press`   v = client->_event( `BEEP` )
            )->a( n = `text`    v = `play the beep`
            )->a( n = `icon`    v = `sap-icon://sound-loud`
            )->a( n = `type`    v = `Emphasized`
            )->a( n = `tooltip` v = `plays a short tone the app carries as a data URI`

        )->tag( `Button`
            )->a( n = `press`   v = client->_event( `REFUSED` )
            )->a( n = `text`    v = `send an unsafe URL`
            )->a( n = `icon`    v = `sap-icon://sound-off`
            )->a( n = `class`   v = `sapUiTinyMarginTop`
            )->a( n = `tooltip` v = `the frontend refuses it and logs - nothing plays`

        )->tag( `ObjectStatus`
            )->a( n = `title` v = `Last action`
            )->a( n = `text`  v = client->_bind( log )
            )->a( n = `class` v = `sapUiSmallMarginTop` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
