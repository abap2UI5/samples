CLASS z2ui5_cl_view DEFINITION
  FINAL
  CREATE PROTECTED.

  PUBLIC SECTION.

    data up type ref to z2ui5_cl_view.
    data down type ref to z2ui5_cl_view.

    CLASS-METHODS factory
      IMPORTING
        !tns          TYPE z2ui5_if_client=>ty_t_name_value OPTIONAL
        !client       TYPE REF TO z2ui5_if_client OPTIONAL
          PREFERRED PARAMETER client
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view.

    CLASS-METHODS factorypopup
      IMPORTING
        !tns          TYPE z2ui5_if_client=>ty_t_name_value OPTIONAL
        !client       TYPE REF TO z2ui5_if_client
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view.

    METHODS constructor.

    METHODS hlpgetsourcecodeurl
      RETURNING
        VALUE(result) TYPE string.

    METHODS hlpgetappurl
      IMPORTING
        VALUE(classname) TYPE string OPTIONAL
      RETURNING
        VALUE(result)    TYPE string.

    METHODS hlpgeturlparam
      IMPORTING
        !val          TYPE string
      RETURNING
        VALUE(result) TYPE string.

    METHODS hlpseturlparam
      IMPORTING
        !n TYPE clike
        !v TYPE clike.

    METHODS horizontallayout
      IMPORTING
        !class        TYPE clike OPTIONAL
        !width        TYPE clike OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view.

    METHODS dynamicpage
      IMPORTING
        !headerexpanded           TYPE clike OPTIONAL
        !showfooter               TYPE clike OPTIONAL
        !headerpinned             TYPE clike OPTIONAL
        !toggleheaderontitleclick TYPE clike OPTIONAL
      RETURNING
        VALUE(result)             TYPE REF TO z2ui5_cl_view.

    METHODS dynamicpagetitle
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view.

    METHODS dynamicpageheader
      IMPORTING
        !pinnable     TYPE clike OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view.

    METHODS illustratedmessage
      IMPORTING
        !enableverticalresponsiveness TYPE clike OPTIONAL
        !enableformattedtext          TYPE clike OPTIONAL
        !illustrationtype             TYPE clike OPTIONAL
        !title                        TYPE clike OPTIONAL
        !description                  TYPE clike OPTIONAL
        !illustrationsize             TYPE clike OPTIONAL
      RETURNING
        VALUE(result)                 TYPE REF TO z2ui5_cl_view.

    METHODS additionalcontent
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view.

    METHODS flexbox
      IMPORTING
        !class          TYPE clike OPTIONAL
        !rendertype     TYPE clike OPTIONAL
        !width          TYPE clike OPTIONAL
        !fitcontainer   TYPE clike OPTIONAL
        !height         TYPE clike OPTIONAL
        !alignitems     TYPE clike OPTIONAL
        !justifycontent TYPE clike OPTIONAL
        !wrap           TYPE clike OPTIONAL
        !visible        TYPE clike OPTIONAL
      RETURNING
        VALUE(result)   TYPE REF TO z2ui5_cl_view.

    METHODS popover
      IMPORTING
        !title         TYPE clike OPTIONAL
        !class         TYPE clike OPTIONAL
        !placement     TYPE clike OPTIONAL
        !initialfocus  TYPE clike OPTIONAL
        !contentwidth  TYPE clike OPTIONAL
        !contentheight TYPE clike OPTIONAL
      RETURNING
        VALUE(result)  TYPE REF TO z2ui5_cl_view.

    METHODS listitem
      IMPORTING
        !text           TYPE clike OPTIONAL
        !additionaltext TYPE clike OPTIONAL
      RETURNING
        VALUE(result)   TYPE REF TO z2ui5_cl_view.

    METHODS table
      IMPORTING
        !id                  TYPE clike OPTIONAL
        !items               TYPE clike OPTIONAL
        !growing             TYPE clike OPTIONAL
        !growingthreshold    TYPE clike OPTIONAL
        !growingscrolltoload TYPE clike OPTIONAL
        !headertext          TYPE clike OPTIONAL
        !sticky              TYPE clike OPTIONAL
        !mode                TYPE clike OPTIONAL
        !width               TYPE clike OPTIONAL
        !selectionchange     TYPE clike OPTIONAL
        !alternaterowcolors  TYPE clike OPTIONAL
        !autopopinmode       TYPE clike OPTIONAL
        !inset               TYPE clike OPTIONAL
        !showseparators      TYPE clike OPTIONAL
          PREFERRED PARAMETER items
      RETURNING
        VALUE(result)        TYPE REF TO z2ui5_cl_view.

    METHODS messagestrip
      IMPORTING
        !text         TYPE clike OPTIONAL
        !type         TYPE clike OPTIONAL
        !showicon     TYPE clike OPTIONAL
        !class        TYPE clike OPTIONAL
          PREFERRED PARAMETER text
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view.

    METHODS footer
      IMPORTING
        !ns           TYPE string OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view.

    METHODS messagepage
      IMPORTING
        !showheader          TYPE clike OPTIONAL
        !text                TYPE clike OPTIONAL
        !enableformattedtext TYPE clike OPTIONAL
        !description         TYPE clike OPTIONAL
        !icon                TYPE clike OPTIONAL
      RETURNING
        VALUE(result)        TYPE REF TO z2ui5_cl_view.

    METHODS objectpagelayout
      IMPORTING
        !showtitleinheadercontent TYPE clike OPTIONAL
        !showeditheaderbutton     TYPE clike OPTIONAL
        !editheaderbuttonpress    TYPE clike OPTIONAL
        !uppercaseanchorbar       TYPE clike OPTIONAL
      RETURNING
        VALUE(result)             TYPE REF TO z2ui5_cl_view.

    METHODS objectpagedynheadertitle
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view.

    METHODS generictile
      IMPORTING
        !class        TYPE clike OPTIONAL
        !mode         TYPE clike OPTIONAL
        !header       TYPE clike OPTIONAL
        !press        TYPE clike OPTIONAL
        !frametype    TYPE clike OPTIONAL
        !subheader    TYPE clike OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view.

    METHODS numericcontent
      IMPORTING
        !value        TYPE clike OPTIONAL
        !icon         TYPE clike OPTIONAL
        !withmargin   TYPE clike OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view.

    METHODS imagecontent
      IMPORTING
        !src          TYPE clike OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view.

    METHODS tilecontent
      IMPORTING
        !unit         TYPE clike OPTIONAL
        !footer       TYPE clike OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view.

    METHODS expandedheading
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view.

    METHODS snappedheading
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view.

    METHODS expandedcontent
      IMPORTING
        !ns           TYPE clike
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS snappedcontent
      IMPORTING
        !ns           TYPE clike
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS heading
      IMPORTING
        !ns           TYPE clike
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS actions
      IMPORTING
        !ns           TYPE clike
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS snappedtitleonmobile
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS header
      IMPORTING
        !ns           TYPE clike DEFAULT `f`
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS navigationactions
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS avatar
      IMPORTING
        !src          TYPE clike OPTIONAL
        !class        TYPE clike OPTIONAL
        !displaysize  TYPE clike OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS headertitle
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS sections
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS objectpagesection
      IMPORTING
        !titleuppercase TYPE clike OPTIONAL
        !title          TYPE clike OPTIONAL
        !importance     TYPE clike OPTIONAL
        !id             TYPE clike OPTIONAL
      RETURNING
        VALUE(result)   TYPE REF TO z2ui5_cl_view .
    METHODS subsections
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS objectpagesubsection
      IMPORTING
        !id           TYPE clike OPTIONAL
        !title        TYPE clike OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS shell
      IMPORTING
        !ns           TYPE clike OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS blocks
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS layoutdata
      IMPORTING
        !ns           TYPE clike OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS flexitemdata
      IMPORTING
        !growfactor       TYPE clike OPTIONAL
        !basesize         TYPE clike OPTIONAL
        !backgrounddesign TYPE clike OPTIONAL
        !styleclass       TYPE clike OPTIONAL
      RETURNING
        VALUE(result)     TYPE REF TO z2ui5_cl_view .
    METHODS codeeditor
      IMPORTING
        !value        TYPE clike OPTIONAL
        !type         TYPE clike OPTIONAL
        !height       TYPE clike OPTIONAL
        !width        TYPE clike OPTIONAL
        !editable     TYPE clike OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS suggestionitems
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS suggestioncolumns
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS suggestionrows
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS verticallayout
      IMPORTING
        !class        TYPE clike OPTIONAL
        !width        TYPE clike OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS multiinput
      IMPORTING
        !showclearicon    TYPE clike OPTIONAL
        !showvaluehelp    TYPE clike OPTIONAL
        !suggestionitems  TYPE clike OPTIONAL
        !tokenupdate      TYPE clike OPTIONAL
        !width            TYPE clike OPTIONAL
        !id               TYPE clike OPTIONAL
        !value            TYPE clike OPTIONAL
        !tokens           TYPE clike OPTIONAL
        !submit           TYPE clike OPTIONAL
        !valuehelprequest TYPE clike OPTIONAL
        !enabled          TYPE clike OPTIONAL
        !class            TYPE clike OPTIONAL
      RETURNING
        VALUE(result)     TYPE REF TO z2ui5_cl_view .
    METHODS tokens
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS token
      IMPORTING
        !key          TYPE clike OPTIONAL
        !text         TYPE clike OPTIONAL
        !selected     TYPE clike OPTIONAL
        !visible      TYPE clike OPTIONAL
        !editable     TYPE clike OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS input
      IMPORTING
        !id                           TYPE clike OPTIONAL
        !value                        TYPE clike OPTIONAL
        !placeholder                  TYPE clike OPTIONAL
        !type                         TYPE clike OPTIONAL
        !showclearicon                TYPE clike OPTIONAL
        !valuestate                   TYPE clike OPTIONAL
        !valuestatetext               TYPE clike OPTIONAL
        !showtablesuggestionvaluehelp TYPE clike OPTIONAL
        !description                  TYPE clike OPTIONAL
        !editable                     TYPE clike OPTIONAL
        !enabled                      TYPE clike OPTIONAL
        !suggestionitems              TYPE clike OPTIONAL
        !suggestionrows               TYPE clike OPTIONAL
        !showsuggestion               TYPE clike OPTIONAL
        !showvaluehelp                TYPE clike OPTIONAL
        !valuehelprequest             TYPE clike OPTIONAL
        !required                     TYPE clike OPTIONAL
        !suggest                      TYPE clike OPTIONAL
        !class                        TYPE clike OPTIONAL
        !visible                      TYPE clike OPTIONAL
        !submit                       TYPE clike OPTIONAL
        !valueliveupdate              TYPE clike OPTIONAL
        !autocomplete                 TYPE clike OPTIONAL
        !maxsuggestionwidth           TYPE clike OPTIONAL
        !fieldwidth                   TYPE clike OPTIONAL
        !valuehelponly                TYPE clike OPTIONAL
          PREFERRED PARAMETER value
      RETURNING
        VALUE(result)                 TYPE REF TO z2ui5_cl_view .
    METHODS dialog
      IMPORTING
        !title         TYPE clike OPTIONAL
        !icon          TYPE clike OPTIONAL
        !showheader    TYPE clike OPTIONAL
        !stretch       TYPE clike OPTIONAL
        !contentheight TYPE clike OPTIONAL
        !contentwidth  TYPE clike OPTIONAL
        !resizable     TYPE clike OPTIONAL
          PREFERRED PARAMETER title
      RETURNING
        VALUE(result)  TYPE REF TO z2ui5_cl_view .
    METHODS carousel
      IMPORTING
        !height       TYPE clike OPTIONAL
        !class        TYPE clike OPTIONAL
        !loop         TYPE clike OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS buttons
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS getroot
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS getparent
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .

    METHODS get
      IMPORTING
        name          TYPE string OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .

    METHODS getchild
      IMPORTING
        !index        TYPE i DEFAULT 1
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .


    METHODS columns
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS column
      IMPORTING
        !width          TYPE clike OPTIONAL
        !minscreenwidth TYPE clike OPTIONAL
        !demandpopin    TYPE clike OPTIONAL
        !halign         TYPE clike OPTIONAL
          PREFERRED PARAMETER width
      RETURNING
        VALUE(result)   TYPE REF TO z2ui5_cl_view .
    METHODS items
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS interactdonutchart
      IMPORTING
        !selectionchanged  TYPE clike OPTIONAL
        !errormessage      TYPE clike OPTIONAL
        !errormessagetitle TYPE clike OPTIONAL
        !showerror         TYPE clike OPTIONAL
        !displayedsegments TYPE clike OPTIONAL
        !press             TYPE clike OPTIONAL
      RETURNING
        VALUE(result)      TYPE REF TO z2ui5_cl_view .
    METHODS segments
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS interactdonutchartsegment
      IMPORTING
        !label          TYPE clike OPTIONAL
        !value          TYPE clike OPTIONAL
        !displayedvalue TYPE clike OPTIONAL
        !selected       TYPE clike OPTIONAL
      RETURNING
        VALUE(result)   TYPE REF TO z2ui5_cl_view .
    METHODS interactbarchart
      IMPORTING
        !selectionchanged  TYPE clike OPTIONAL
        !press             TYPE clike OPTIONAL
        !labelwidth        TYPE clike OPTIONAL
        !errormessage      TYPE clike OPTIONAL
        !errormessagetitle TYPE clike OPTIONAL
        !showerror         TYPE clike OPTIONAL
      RETURNING
        VALUE(result)      TYPE REF TO z2ui5_cl_view .
    METHODS bars
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS interactbarchartbar
      IMPORTING
        !label          TYPE clike OPTIONAL
        !value          TYPE clike OPTIONAL
        !displayedvalue TYPE clike OPTIONAL
        !selected       TYPE clike OPTIONAL
      RETURNING
        VALUE(result)   TYPE REF TO z2ui5_cl_view .
    METHODS interactlinechart
      IMPORTING
        !selectionchanged  TYPE clike OPTIONAL
        !press             TYPE clike OPTIONAL
        !precedingpoint    TYPE clike OPTIONAL
        !succeddingpoint   TYPE clike OPTIONAL
        !errormessage      TYPE clike OPTIONAL
        !errormessagetitle TYPE clike OPTIONAL
        !showerror         TYPE clike OPTIONAL
      RETURNING
        VALUE(result)      TYPE REF TO z2ui5_cl_view .
    METHODS points
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS interactlinechartpoint
      IMPORTING
        !label          TYPE clike OPTIONAL
        !value          TYPE clike OPTIONAL
        !secondarylabel TYPE clike OPTIONAL
        !displayedvalue TYPE clike OPTIONAL
        !selected       TYPE clike OPTIONAL
      RETURNING
        VALUE(result)   TYPE REF TO z2ui5_cl_view .
    METHODS radialmicrochart
      IMPORTING
        !sice         TYPE clike OPTIONAL
        !percentage   TYPE clike OPTIONAL
        !press        TYPE clike OPTIONAL
        !valuecolor   TYPE clike OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS columnlistitem
      IMPORTING
        !valign       TYPE clike OPTIONAL
        !selected     TYPE clike OPTIONAL
        !type         TYPE clike OPTIONAL
        !press        TYPE clike OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS cells
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS bar
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS contentleft
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS contentmiddle
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS contentright
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS customheader
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS headercontent
      IMPORTING
        !ns           TYPE clike OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS subheader
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS customdata
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS badgecustomdata
      IMPORTING
        !key          TYPE clike OPTIONAL
        !value        TYPE clike OPTIONAL
        !visible      TYPE clike OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS togglebutton
      IMPORTING
        !text         TYPE clike OPTIONAL
        !icon         TYPE clike OPTIONAL
        !type         TYPE clike OPTIONAL
        !enabled      TYPE clike OPTIONAL
        !press        TYPE clike OPTIONAL
        !class        TYPE clike OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS button
      IMPORTING
        !text         TYPE clike OPTIONAL
        !icon         TYPE clike OPTIONAL
        !type         TYPE clike OPTIONAL
        !enabled      TYPE clike OPTIONAL
        !visible      TYPE clike OPTIONAL
        !press        TYPE clike OPTIONAL
        !class        TYPE clike OPTIONAL
        !id           TYPE clike OPTIONAL
        !ns           TYPE clike OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS searchfield
      IMPORTING
        !search       TYPE clike OPTIONAL
        !width        TYPE clike OPTIONAL
        !value        TYPE clike OPTIONAL
        !id           TYPE clike OPTIONAL
        !change       TYPE clike OPTIONAL
        !livechange   TYPE clike OPTIONAL
        !autocomplete TYPE clike OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS messageview
      IMPORTING
        !items        TYPE clike OPTIONAL
        !groupitems   TYPE clike OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS messagepopover
      IMPORTING
        !items        TYPE clike OPTIONAL
        !groupitems   TYPE clike OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS messageitem
      IMPORTING
        !type              TYPE clike OPTIONAL
        !title             TYPE clike OPTIONAL
        !subtitle          TYPE clike OPTIONAL
        !description       TYPE clike OPTIONAL
        !groupname         TYPE clike OPTIONAL
        !markupdescription TYPE abap_bool OPTIONAL
      RETURNING
        VALUE(result)      TYPE REF TO z2ui5_cl_view .
    METHODS page
      IMPORTING
        !title          TYPE clike OPTIONAL
        !navbuttonpress TYPE clike OPTIONAL
        !shownavbutton  TYPE clike OPTIONAL
        !showheader     TYPE clike OPTIONAL
        !id             TYPE clike OPTIONAL
        !class          TYPE clike OPTIONAL
        !ns             TYPE clike OPTIONAL
          PREFERRED PARAMETER title
      RETURNING
        VALUE(result)   TYPE REF TO z2ui5_cl_view .
    METHODS panel
      IMPORTING
        !expandable   TYPE clike OPTIONAL
        !expanded     TYPE clike OPTIONAL
        !headertext   TYPE clike OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS vbox
      IMPORTING
        !height         TYPE clike OPTIONAL
        !justifycontent TYPE clike OPTIONAL
        !class          TYPE clike OPTIONAL
        !rendertype     TYPE clike OPTIONAL
        !aligncontent   TYPE clike OPTIONAL
        !alignitems     TYPE clike OPTIONAL
        !width          TYPE clike OPTIONAL
        !wrap           TYPE clike OPTIONAL
          PREFERRED PARAMETER class
      RETURNING
        VALUE(result)   TYPE REF TO z2ui5_cl_view .
    METHODS hbox
      IMPORTING
        !class          TYPE clike OPTIONAL
        !justifycontent TYPE clike OPTIONAL
        !aligncontent   TYPE clike OPTIONAL
        !alignitems     TYPE clike OPTIONAL
        !width          TYPE clike OPTIONAL
        !height         TYPE clike OPTIONAL
        !wrap           TYPE clike OPTIONAL
      RETURNING
        VALUE(result)   TYPE REF TO z2ui5_cl_view .
    METHODS scrollcontainer
      IMPORTING
        !height       TYPE clike OPTIONAL
        !width        TYPE clike OPTIONAL
        !vertical     TYPE clike OPTIONAL
        !horizontal   TYPE clike OPTIONAL
        !focusable    TYPE clike OPTIONAL
          PREFERRED PARAMETER height
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS simpleform
      IMPORTING
        !title        TYPE clike OPTIONAL
        !layout       TYPE clike OPTIONAL
        !editable     TYPE clike OPTIONAL
        !columnsxl    TYPE clike OPTIONAL
        !columnsl     TYPE clike OPTIONAL
        !columnsm     TYPE clike OPTIONAL
          PREFERRED PARAMETER title
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS zzplain
      IMPORTING
        !val          TYPE clike OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view.

    METHODS content
      IMPORTING
        !ns           TYPE clike OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view.

    METHODS title
      IMPORTING
        !ns           TYPE clike OPTIONAL
        !text         TYPE clike OPTIONAL
        !wrapping     TYPE clike OPTIONAL
        !level        TYPE clike OPTIONAL
          PREFERRED PARAMETER text
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS tabcontainer
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS tab
      IMPORTING
        !text         TYPE clike OPTIONAL
        !selected     TYPE clike OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS overflowtoolbar
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS overflowtoolbartogglebutton
      IMPORTING
        !text         TYPE clike OPTIONAL
        !icon         TYPE clike OPTIONAL
        !type         TYPE clike OPTIONAL
        !enabled      TYPE clike OPTIONAL
        !press        TYPE clike OPTIONAL
        !tooltip      TYPE clike OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS overflowtoolbarbutton
      IMPORTING
        !text         TYPE clike OPTIONAL
        !icon         TYPE clike OPTIONAL
        !type         TYPE clike OPTIONAL
        !enabled      TYPE clike OPTIONAL
        !press        TYPE clike OPTIONAL
        !tooltip      TYPE clike OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS overflowtoolbarmenubutton
      IMPORTING
        !text          TYPE clike OPTIONAL
        !icon          TYPE clike OPTIONAL
        !buttonmode    TYPE clike OPTIONAL
        !type          TYPE clike OPTIONAL
        !enabled       TYPE clike OPTIONAL
        !tooltip       TYPE clike OPTIONAL
        !defaultaction TYPE clike OPTIONAL
      RETURNING
        VALUE(result)  TYPE REF TO z2ui5_cl_view .
    METHODS menuitem
      IMPORTING
        !press        TYPE clike OPTIONAL
        !text         TYPE clike OPTIONAL
        !icon         TYPE clike OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS toolbarspacer
      IMPORTING
        !ns           TYPE clike OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS label
      IMPORTING
        !text         TYPE clike OPTIONAL
        !labelfor     TYPE clike OPTIONAL
        !design       TYPE clike OPTIONAL
          PREFERRED PARAMETER text
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view.

    METHODS image
      IMPORTING
        !src          TYPE clike OPTIONAL
        !class        TYPE clike OPTIONAL
        !height       TYPE clike OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS datepicker
      IMPORTING
        !value                 TYPE clike OPTIONAL
        !placeholder           TYPE clike OPTIONAL
        !displayformat         TYPE clike OPTIONAL
        !valueformat           TYPE clike OPTIONAL
        !required              TYPE clike OPTIONAL
        !valuestate            TYPE clike OPTIONAL
        !valuestatetext        TYPE clike OPTIONAL
        !enabled               TYPE clike OPTIONAL
        !showcurrentdatebutton TYPE clike OPTIONAL
          PREFERRED PARAMETER value
      RETURNING
        VALUE(result)          TYPE REF TO z2ui5_cl_view .
    METHODS timepicker
      IMPORTING
        !value         TYPE clike OPTIONAL
        !placeholder   TYPE clike OPTIONAL
        !enabled       TYPE clike OPTIONAL
        !valuestate    TYPE clike OPTIONAL
        !displayformat TYPE clike OPTIONAL
        !valueformat   TYPE clike OPTIONAL
          PREFERRED PARAMETER value
      RETURNING
        VALUE(result)  TYPE REF TO z2ui5_cl_view .
    METHODS datetimepicker
      IMPORTING
        !value        TYPE clike OPTIONAL
        !placeholder  TYPE clike OPTIONAL
        !enabled      TYPE clike OPTIONAL
        !valuestate   TYPE clike OPTIONAL
          PREFERRED PARAMETER value
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS link
      IMPORTING
        !text         TYPE clike OPTIONAL
        !href         TYPE clike OPTIONAL
        !target       TYPE clike OPTIONAL
        !enabled      TYPE clike OPTIONAL
        !press        TYPE clike OPTIONAL
        !id           TYPE clike OPTIONAL
        !ns           TYPE clike OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS list
      IMPORTING
        !headertext      TYPE clike OPTIONAL
        !items           TYPE clike OPTIONAL
        !mode            TYPE clike OPTIONAL
        !selectionchange TYPE clike OPTIONAL
        !nodata          TYPE clike OPTIONAL
      RETURNING
        VALUE(result)    TYPE REF TO z2ui5_cl_view .
    METHODS customlistitem
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS inputlistitem
      IMPORTING
        !label        TYPE clike OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS standardlistitem
      IMPORTING
        !title        TYPE clike OPTIONAL
        !description  TYPE clike OPTIONAL
        !icon         TYPE clike OPTIONAL
        !info         TYPE clike OPTIONAL
        !press        TYPE clike OPTIONAL
        !type         TYPE clike OPTIONAL
        !selected     TYPE clike OPTIONAL
        !counter      TYPE clike OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS item
      IMPORTING
        !key          TYPE clike OPTIONAL
        !text         TYPE clike OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS segmentedbuttonitem
      IMPORTING
        !icon         TYPE clike OPTIONAL
        !key          TYPE clike OPTIONAL
        !text         TYPE clike OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS combobox
      IMPORTING
        !selectedkey   TYPE clike OPTIONAL
        !showclearicon TYPE clike OPTIONAL
        !label         TYPE clike OPTIONAL
        !items         TYPE clike OPTIONAL
        !change        TYPE clike OPTIONAL
      RETURNING
        VALUE(result)  TYPE REF TO z2ui5_cl_view .
    METHODS multicombobox
      IMPORTING
        !selectionchange     TYPE clike OPTIONAL
        !selectionfinish     TYPE clike OPTIONAL
        !width               TYPE clike OPTIONAL
        !showclearicon       TYPE clike OPTIONAL
        !showsecondaryvalues TYPE clike OPTIONAL
        !showselectall       TYPE clike OPTIONAL
        !selectedkeys        TYPE clike OPTIONAL
        !items               TYPE clike OPTIONAL
      RETURNING
        VALUE(result)        TYPE REF TO z2ui5_cl_view .
    METHODS grid
      IMPORTING
        !class        TYPE clike OPTIONAL
        !defaultspan  TYPE clike OPTIONAL
          PREFERRED PARAMETER defaultspan
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS griddata
      IMPORTING
        !span         TYPE clike OPTIONAL
          PREFERRED PARAMETER span
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS textarea
      IMPORTING
        !value           TYPE clike OPTIONAL
        !rows            TYPE clike OPTIONAL
        !height          TYPE clike OPTIONAL
        !valueliveupdate TYPE clike OPTIONAL
        !width           TYPE clike OPTIONAL
        !editable        TYPE clike OPTIONAL
        !enabled         TYPE clike OPTIONAL
        !growing         TYPE clike OPTIONAL
        !growingmaxlines TYPE clike OPTIONAL
        !id              TYPE clike OPTIONAL
          PREFERRED PARAMETER value
      RETURNING
        VALUE(result)    TYPE REF TO z2ui5_cl_view.

    METHODS rangeslider
      IMPORTING
        !max           TYPE clike OPTIONAL
        !min           TYPE clike OPTIONAL
        !step          TYPE clike OPTIONAL
        !startvalue    TYPE clike OPTIONAL
        !endvalue      TYPE clike OPTIONAL
        !showtickmarks TYPE clike OPTIONAL
        !labelinterval TYPE clike OPTIONAL
        !width         TYPE clike OPTIONAL
        !class         TYPE clike OPTIONAL
        !id            TYPE clike OPTIONAL
      RETURNING
        VALUE(result)  TYPE REF TO z2ui5_cl_view.

    METHODS generictag
      IMPORTING
        !arialabelledby TYPE clike OPTIONAL
        !text           TYPE clike OPTIONAL
        !design         TYPE clike OPTIONAL
        !status         TYPE clike OPTIONAL
        !class          TYPE clike OPTIONAL
      RETURNING
        VALUE(result)   TYPE REF TO z2ui5_cl_view .
    METHODS objectattribute
      IMPORTING
        !title        TYPE clike OPTIONAL
        !text         TYPE clike OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view.

    METHODS objectnumber
      IMPORTING
        !state        TYPE clike OPTIONAL
        !emphasized   TYPE clike OPTIONAL
        !number       TYPE clike OPTIONAL
        !unit         TYPE clike OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .

    METHODS switch
      IMPORTING
        !state         TYPE clike OPTIONAL
        !customtexton  TYPE clike OPTIONAL
        !customtextoff TYPE clike OPTIONAL
        !enabled       TYPE clike OPTIONAL
        !change        TYPE clike OPTIONAL
        !type          TYPE clike OPTIONAL
      RETURNING
        VALUE(result)  TYPE REF TO z2ui5_cl_view .

    METHODS stepinput
      IMPORTING
        !value        TYPE clike OPTIONAL
        !min          TYPE clike OPTIONAL
        !max          TYPE clike OPTIONAL
        !step         TYPE clike OPTIONAL
        !valuestate   TYPE clike OPTIONAL
        !enabled      TYPE clike OPTIONAL
        !description  TYPE clike OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS progressindicator
      IMPORTING
        !class        TYPE clike OPTIONAL
        !percentvalue TYPE clike OPTIONAL
        !displayvalue TYPE clike OPTIONAL
        !showvalue    TYPE clike OPTIONAL
        !state        TYPE clike OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS segmentedbutton
      IMPORTING
        !selectedkey     TYPE clike
        !selectionchange TYPE clike OPTIONAL
      RETURNING
        VALUE(result)    TYPE REF TO z2ui5_cl_view .
    METHODS checkbox
      IMPORTING
        !text         TYPE clike OPTIONAL
        !selected     TYPE clike OPTIONAL
        !enabled      TYPE clike OPTIONAL
        !select       TYPE clike OPTIONAL
          PREFERRED PARAMETER selected
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS headertoolbar
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS toolbar
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS text
      IMPORTING
        !text         TYPE clike OPTIONAL
        !class        TYPE clike OPTIONAL
        !ns           TYPE clike OPTIONAL
          PREFERRED PARAMETER text
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS formattedtext
      IMPORTING
        !htmltext     TYPE clike OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view.

    METHODS c
      IMPORTING
        !n            TYPE clike
        !ns           TYPE clike OPTIONAL
        !p            TYPE z2ui5_if_client=>ty_t_name_value OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view.

    METHODS p
      IMPORTING
        n type clike
        v type clike
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view.

    METHODS pb
      IMPORTING
        n type clike
        v type clike
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view.

    METHODS ccfileuploader
      IMPORTING
        !value        TYPE clike OPTIONAL
        !path         TYPE clike OPTIONAL
        !placeholder  TYPE clike OPTIONAL
        !upload       TYPE clike OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .

    METHODS ccfileuploadergetjs
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .

    METHODS xmlget
      RETURNING
        VALUE(result) TYPE string .
    METHODS stringify
      RETURNING
        VALUE(result) TYPE string .
    METHODS treetable
      IMPORTING
        !rows                   TYPE clike
        !selectionmode          TYPE clike DEFAULT 'Single'
        !enablecolumnreordering TYPE clike DEFAULT 'false'
        !expandfirstlevel       TYPE clike DEFAULT 'false'
        !columnselect           TYPE clike OPTIONAL
        !rowselectionchange     TYPE clike OPTIONAL
        !selectionbehavior      TYPE clike DEFAULT 'RowSelector'
        !selectedindex          TYPE clike OPTIONAL
      RETURNING
        VALUE(result)           TYPE REF TO z2ui5_cl_view .
    METHODS treecolumns
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS treecolumn
      IMPORTING
        !label        TYPE clike
        !template     TYPE clike OPTIONAL
        !halign       TYPE clike DEFAULT 'Begin'
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS treetemplate
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS filterbar
      IMPORTING
        !usetoolbar   TYPE clike DEFAULT 'false'
        !search       TYPE clike OPTIONAL
        !filterchange TYPE clike OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS filtergroupitems
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS filtergroupitem
      IMPORTING
        !name               TYPE clike
        !label              TYPE clike
        !groupname          TYPE clike
        !visibleinfilterbar TYPE clike DEFAULT 'true'
      RETURNING
        VALUE(result)       TYPE REF TO z2ui5_cl_view .
    METHODS filtercontrol
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS flexiblecolumnlayout
      IMPORTING
        !layout       TYPE clike
        !id           TYPE clike
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS begincolumnpages
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS midcolumnpages
      IMPORTING
        !id           TYPE clike OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS endcolumnpages
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS uitable
      IMPORTING
        !rows                     TYPE clike OPTIONAL
        !columnheadervisible      TYPE clike OPTIONAL
        !editable                 TYPE clike OPTIONAL
        !enablecellfilter         TYPE clike OPTIONAL
        !enablegrouping           TYPE clike OPTIONAL
        !enableselectall          TYPE clike OPTIONAL
        !firstvisiblerow          TYPE clike OPTIONAL
        !fixedbottomrowcount      TYPE clike OPTIONAL
        !fixedcolumncount         TYPE clike OPTIONAL
        !fixedrowcount            TYPE clike OPTIONAL
        !minautorowcount          TYPE clike OPTIONAL
        !rowactioncount           TYPE clike OPTIONAL
        !rowheight                TYPE clike OPTIONAL
        !selectionmode            TYPE clike OPTIONAL
        !showcolumnvisibilitymenu TYPE clike OPTIONAL
        !shownodata               TYPE clike OPTIONAL
        !selectedindex            TYPE clike OPTIONAL
        !threshold                TYPE clike OPTIONAL
        !visiblerowcount          TYPE clike OPTIONAL
        !visiblerowcountmode      TYPE clike OPTIONAL
        !alternaterowcolors       TYPE clike OPTIONAL
        !footer                   TYPE clike OPTIONAL
        !filter                   TYPE clike OPTIONAL
        !sort                     TYPE clike OPTIONAL
        !rowselectionchange       TYPE clike OPTIONAL
        !customfilter             TYPE clike OPTIONAL
        !id                       TYPE clike OPTIONAL
          PREFERRED PARAMETER rows
      RETURNING
        VALUE(result)             TYPE REF TO z2ui5_cl_view .
    METHODS uicolumn
      IMPORTING
        !width               TYPE clike OPTIONAL
        !showsortmenuentry   TYPE clike OPTIONAL
        !sortproperty        TYPE clike OPTIONAL
        !filterproperty      TYPE clike OPTIONAL
        !showfiltermenuentry TYPE clike OPTIONAL
          PREFERRED PARAMETER width
      RETURNING
        VALUE(result)        TYPE REF TO z2ui5_cl_view .
    METHODS uicolumns
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS uiextension
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS uitemplate
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS currency
      IMPORTING
        !value        TYPE clike
        !currency     TYPE clike
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS uirowaction
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS uirowactiontemplate
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .

    METHODS uirowactionitem
      IMPORTING
        !icon         TYPE clike OPTIONAL
        !text         TYPE clike OPTIONAL
        !type         TYPE clike OPTIONAL
        !press        TYPE clike OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .
    METHODS radiobutton
      IMPORTING
        !activehandling TYPE clike OPTIONAL
        !editable       TYPE clike OPTIONAL
        !enabled        TYPE clike OPTIONAL
        !groupname      TYPE clike OPTIONAL
        !selected       TYPE clike OPTIONAL
        !text           TYPE clike OPTIONAL
        !textalign      TYPE clike OPTIONAL
        !textdirection  TYPE clike OPTIONAL
        !useentirewidth TYPE clike OPTIONAL
        !valuestate     TYPE clike OPTIONAL
        !width          TYPE clike OPTIONAL
      RETURNING
        VALUE(result)   TYPE REF TO z2ui5_cl_view .

    METHODS radiobuttongroup
      IMPORTING
        !id            TYPE clike OPTIONAL
        !columns       TYPE clike OPTIONAL
        !editable      TYPE clike OPTIONAL
        !enabled       TYPE clike OPTIONAL
        !selectedindex TYPE clike OPTIONAL
        !textdirection TYPE clike OPTIONAL
        !valuestate    TYPE clike OPTIONAL
        !width         TYPE clike OPTIONAL
      RETURNING
        VALUE(result)  TYPE REF TO z2ui5_cl_view .

    METHODS dynamicsidecontent
      IMPORTING
        !id                    TYPE clike OPTIONAL
        !class                 TYPE clike OPTIONAL
        !sidecontentvisibility TYPE clike OPTIONAL
        !showsidecontent       TYPE clike OPTIONAL
        !containerquery        TYPE clike OPTIONAL
          PREFERRED PARAMETER id
      RETURNING
        VALUE(result)          TYPE REF TO z2ui5_cl_view.

    METHODS sidecontent
      IMPORTING
        !width        TYPE clike OPTIONAL
          PREFERRED PARAMETER width
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view.

    METHODS planningcalendar
      IMPORTING
        !rows                      TYPE clike OPTIONAL
        !startdate                 TYPE clike OPTIONAL
        !appointmentsvisualization TYPE clike OPTIONAL
        !appointmentselect         TYPE clike OPTIONAL
        !showemptyintervalheaders  TYPE clike OPTIONAL
        !showweeknumbers           TYPE clike OPTIONAL
        !showdaynamesline          TYPE clike OPTIONAL
        !legend                    TYPE clike OPTIONAL
          PREFERRED PARAMETER rows
      RETURNING
        VALUE(result)              TYPE REF TO z2ui5_cl_view .

    METHODS planningcalendarrow
      IMPORTING
        !appointments                  TYPE clike OPTIONAL
        !intervalheaders               TYPE clike OPTIONAL
        !icon                          TYPE clike OPTIONAL
        !title                         TYPE clike OPTIONAL
        !key                           TYPE clike OPTIONAL
        !text                          TYPE clike OPTIONAL
        !enableappointmentscreate      TYPE clike OPTIONAL
        !enableappointmentsdraganddrop TYPE clike OPTIONAL
        !enableappointmentsresize      TYPE clike OPTIONAL
        !nonworkingdays                TYPE clike OPTIONAL
        !selected                      TYPE clike OPTIONAL
        !appointmentcreate             TYPE clike OPTIONAL
        !appointmentdragenter          TYPE clike OPTIONAL
        !appointmentdrop               TYPE clike OPTIONAL
        !appointmentresize             TYPE clike OPTIONAL
          PREFERRED PARAMETER appointments
      RETURNING
        VALUE(result)                  TYPE REF TO z2ui5_cl_view.

    METHODS planningcalendarlegend
      IMPORTING
        !items            TYPE clike OPTIONAL
        !id               TYPE clike OPTIONAL
        !appointmentitems TYPE clike OPTIONAL
        !standarditems    TYPE clike OPTIONAL
          PREFERRED PARAMETER items
      RETURNING
        VALUE(result)     TYPE REF TO z2ui5_cl_view .

    METHODS calendarlegenditem
      IMPORTING
        !text         TYPE clike OPTIONAL
        !type         TYPE clike OPTIONAL
        !tooltip      TYPE clike OPTIONAL
        !color        TYPE clike OPTIONAL
          PREFERRED PARAMETER text
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view.

    METHODS appointmentitems
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view.

    METHODS infolabel
      IMPORTING
        !id            TYPE clike OPTIONAL
        !text          TYPE clike OPTIONAL
        !rendermode    TYPE clike OPTIONAL
        !colorscheme   TYPE clike OPTIONAL
        !icon          TYPE clike OPTIONAL
        !displayonly   TYPE clike OPTIONAL
        !textdirection TYPE clike OPTIONAL
        !width         TYPE clike OPTIONAL
          PREFERRED PARAMETER text
      RETURNING
        VALUE(result)  TYPE REF TO z2ui5_cl_view .

    METHODS rows
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .

    METHODS appointments
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .

    METHODS calendarappointment
      IMPORTING
        !startdate    TYPE clike OPTIONAL
        !enddate      TYPE clike OPTIONAL
        !icon         TYPE clike OPTIONAL
        !title        TYPE clike OPTIONAL
        !text         TYPE clike OPTIONAL
        !type         TYPE clike OPTIONAL
        !tentative    TYPE clike OPTIONAL
        !key          TYPE clike OPTIONAL
          PREFERRED PARAMETER startdate
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .

    METHODS intervalheaders
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .

    METHODS blocklayout
      IMPORTING
        !background   TYPE clike OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .

    METHODS blocklayoutrow
      IMPORTING
        !rowcolorset  TYPE clike OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .

    METHODS blocklayoutcell
      IMPORTING
        !backgroundcolorset   TYPE clike OPTIONAL
        !backgroundcolorshade TYPE clike OPTIONAL
        !title                TYPE clike OPTIONAL
        !titlealignment       TYPE clike OPTIONAL
        !titlelevel           TYPE clike OPTIONAL
        !width                TYPE clike OPTIONAL
        !class                TYPE clike OPTIONAL
      RETURNING
        VALUE(result)         TYPE REF TO z2ui5_cl_view .

    METHODS objectidentifier
      IMPORTING
        !emptyindicatormode TYPE clike OPTIONAL
        !text               TYPE clike OPTIONAL
        !textdirection      TYPE clike OPTIONAL
        !title              TYPE clike OPTIONAL
        !titleactive        TYPE clike OPTIONAL
        !visible            TYPE clike OPTIONAL
        !titlepress         TYPE clike OPTIONAL
      RETURNING
        VALUE(result)       TYPE REF TO z2ui5_cl_view .

    METHODS objectstatus
      IMPORTING
        !active                TYPE clike OPTIONAL
        !emptyindicatormode    TYPE clike OPTIONAL
        !icon                  TYPE clike OPTIONAL
        !icondensityaware      TYPE clike OPTIONAL
        !inverted              TYPE clike OPTIONAL
        !state                 TYPE clike OPTIONAL
        !stateannouncementtext TYPE clike OPTIONAL
        !text                  TYPE clike OPTIONAL
        !textdirection         TYPE clike OPTIONAL
        !title                 TYPE clike OPTIONAL
        !press                 TYPE clike OPTIONAL
      RETURNING
        VALUE(result)          TYPE REF TO z2ui5_cl_view .

    METHODS tree
      IMPORTING
        !items                  TYPE clike OPTIONAL
        !headertext             TYPE clike OPTIONAL
        !footertext             TYPE clike OPTIONAL
        !mode                   TYPE clike OPTIONAL
        !includeiteminselection TYPE abap_bool OPTIONAL
        !inset                  TYPE abap_bool OPTIONAL
        !width                  TYPE clike OPTIONAL
      RETURNING
        VALUE(result)           TYPE REF TO z2ui5_cl_view .

    METHODS standardtreeitem
      IMPORTING
        !title        TYPE clike OPTIONAL
        !icon         TYPE clike OPTIONAL
        !press        TYPE clike OPTIONAL
        !detailpress  TYPE clike OPTIONAL
        !type         TYPE clike OPTIONAL
        !selected     TYPE clike OPTIONAL
        !counter      TYPE clike OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .

    METHODS icontabbar
      IMPORTING
        !class        TYPE clike OPTIONAL
        !select       TYPE clike OPTIONAL
        !expand       TYPE clike OPTIONAL
        !expandable   TYPE abap_bool OPTIONAL
        !expanded     TYPE abap_bool OPTIONAL
        !selectedkey  TYPE clike OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .

    METHODS icontabfilter
      IMPORTING
        !items        TYPE clike OPTIONAL
        !showall      TYPE abap_bool OPTIONAL
        !icon         TYPE clike OPTIONAL
        !iconcolor    TYPE clike OPTIONAL
        !count        TYPE clike OPTIONAL
        !text         TYPE clike OPTIONAL
        !key          TYPE clike OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .

    METHODS icontabseparator
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .


    METHODS ccexportspreadsheetgetjs
      IMPORTING
        !columnconfig TYPE clike
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .

    METHODS ccexportspreadsheet
      IMPORTING
        !tableid      TYPE clike
        !type         TYPE clike OPTIONAL
        !text         TYPE clike OPTIONAL
        !icon         TYPE clike OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .

    METHODS ganttchartcontainer
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .

    METHODS containertoolbar
      IMPORTING
        !showsearchbutton          TYPE clike OPTIONAL
        !aligncustomcontenttoright TYPE clike OPTIONAL
        !findmode                  TYPE clike OPTIONAL
        !infoofselectitems         TYPE clike OPTIONAL
        !showbirdeyebutton         TYPE clike OPTIONAL
        !showdisplaytypebutton     TYPE clike OPTIONAL
        !showlegendbutton          TYPE clike OPTIONAL
        !showsettingbutton         TYPE clike OPTIONAL
        !showtimezoomcontrol       TYPE clike OPTIONAL
        !stepcountofslider         TYPE clike OPTIONAL
        !zoomcontroltype           TYPE clike OPTIONAL
        !zoomlevel                 TYPE clike OPTIONAL
      RETURNING
        VALUE(result)              TYPE REF TO z2ui5_cl_view .

    METHODS ganttchartwithtable
      IMPORTING
        !id                 TYPE clike OPTIONAL
        !shapeselectionmode TYPE clike OPTIONAL
      RETURNING
        VALUE(result)       TYPE REF TO z2ui5_cl_view .

    METHODS axistimestrategy
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .

    METHODS proportionzoomstrategy
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .

    METHODS totalhorizon
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .

    METHODS timehorizon
      IMPORTING
        !starttime    TYPE clike OPTIONAL
        !endtime      TYPE clike OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .

    METHODS visiblehorizon
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .

    METHODS rowsettingstemplate
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .

    METHODS ganttrowsettings
      IMPORTING
        !rowid        TYPE clike OPTIONAL
        !shapes1      TYPE clike OPTIONAL
        !shapes2      TYPE clike OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .

    METHODS shapes1
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .

    METHODS shapes2
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .

    METHODS task
      IMPORTING
        !type         TYPE clike OPTIONAL
        !color        TYPE clike OPTIONAL
        !endtime      TYPE clike OPTIONAL
        !time         TYPE clike OPTIONAL
        !title        TYPE clike OPTIONAL
        !showtitle    TYPE clike OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .

    METHODS gantttable
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view .

    METHODS ratingindicator
      IMPORTING
        !maxvalue     TYPE clike OPTIONAL
        !enabled      TYPE clike OPTIONAL
        !class        TYPE clike OPTIONAL
        !value        TYPE clike OPTIONAL
        !iconsize     TYPE clike OPTIONAL
        !tooltip      TYPE clike OPTIONAL
        !displayonly  TYPE clike OPTIONAL
        !change       TYPE clike OPTIONAL
        !id           TYPE clike OPTIONAL
        !editable     TYPE clike OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view.

    METHODS gantttoolbar
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view.

    METHODS baserectangle
      IMPORTING
        !time                    TYPE clike OPTIONAL
        !endtime                 TYPE clike OPTIONAL
        !selectable              TYPE clike OPTIONAL
        !selectedfill            TYPE clike OPTIONAL
        !fill                    TYPE clike OPTIONAL
        !height                  TYPE clike OPTIONAL
        !title                   TYPE clike OPTIONAL
        !animationsettings       TYPE clike OPTIONAL
        !alignshape              TYPE clike OPTIONAL
        !color                   TYPE clike OPTIONAL
        !fontsize                TYPE clike OPTIONAL
        !connectable             TYPE clike OPTIONAL
        !fontfamily              TYPE clike OPTIONAL
        !filter                  TYPE clike OPTIONAL
        !transform               TYPE clike OPTIONAL
        !countinbirdeye          TYPE clike OPTIONAL
        !fontweight              TYPE clike OPTIONAL
        !showtitle               TYPE clike OPTIONAL
        !selected                TYPE clike OPTIONAL
        !resizable               TYPE clike OPTIONAL
        !horizontaltextalignment TYPE clike OPTIONAL
        !highlighted             TYPE clike OPTIONAL
        !highlightable           TYPE clike OPTIONAL
      RETURNING
        VALUE(result)            TYPE REF TO z2ui5_cl_view.

    METHODS toolpage
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view.

    METHODS toolheader
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view.

    METHODS icontabheader
      IMPORTING
        !selectedkey  TYPE clike OPTIONAL
        !items        TYPE clike OPTIONAL
        !select       TYPE clike OPTIONAL
        !mode         TYPE clike OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view.

    METHODS navcontainer
      IMPORTING
        !initialpage           TYPE clike OPTIONAL
        !id                    TYPE clike OPTIONAL
        !defaulttransitionname TYPE clike OPTIONAL
      RETURNING
        VALUE(result)          TYPE REF TO z2ui5_cl_view.

    METHODS pages
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view.


    METHODS maincontents
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view.

    METHODS tableselectdialog
      IMPORTING
        !confirmbuttontext  TYPE clike OPTIONAL
        !contentheight      TYPE clike OPTIONAL
        !contentwidth       TYPE clike OPTIONAL
        !draggable          TYPE clike OPTIONAL
        !growing            TYPE clike OPTIONAL
        !growingthreshold   TYPE clike OPTIONAL
        !multiselect        TYPE clike OPTIONAL
        !nodatatext         TYPE clike OPTIONAL
        !rememberselections TYPE clike OPTIONAL
        !resizable          TYPE clike OPTIONAL
        !searchplaceholder  TYPE clike OPTIONAL
        !showclearbutton    TYPE clike OPTIONAL
        !title              TYPE clike OPTIONAL
        !titlealignment     TYPE clike OPTIONAL
        !visible            TYPE clike OPTIONAL
        !items              TYPE clike OPTIONAL
        !livechange         TYPE clike OPTIONAL
        !cancel             TYPE clike OPTIONAL
        !search             TYPE clike OPTIONAL
        !confirm            TYPE clike OPTIONAL
        !selectionchange    TYPE clike OPTIONAL
      RETURNING
        VALUE(result)       TYPE REF TO z2ui5_cl_view.

    METHODS processflow
      IMPORTING
        !id            TYPE clike OPTIONAL
        !foldedcorners TYPE clike OPTIONAL
        !scrollable    TYPE clike OPTIONAL
        !showlabels    TYPE clike OPTIONAL
        !visible       TYPE clike OPTIONAL
        !wheelzoomable TYPE clike OPTIONAL
        !headerpress   TYPE clike OPTIONAL
        !labelpress    TYPE clike OPTIONAL
        !nodepress     TYPE clike OPTIONAL
        !onerror       TYPE clike OPTIONAL
        !lanes         TYPE clike OPTIONAL
        !nodes         TYPE clike OPTIONAL
      RETURNING
        VALUE(result)  TYPE REF TO z2ui5_cl_view.

    METHODS nodes
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view.

    METHODS lanes
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view.

    METHODS processflownode
      IMPORTING
        !laneid            TYPE clike OPTIONAL
        !nodeid            TYPE clike OPTIONAL
        !title             TYPE clike OPTIONAL
        !titleabbreviation TYPE clike OPTIONAL
        !children          TYPE clike OPTIONAL
        !state             TYPE clike OPTIONAL
        !statetext         TYPE clike OPTIONAL
        !texts             TYPE clike OPTIONAL
        !highlighted       TYPE clike OPTIONAL
        !focused           TYPE clike OPTIONAL
        !selected          TYPE clike OPTIONAL
        !tag               TYPE clike OPTIONAL
        !type              TYPE clike OPTIONAL
      RETURNING
        VALUE(result)      TYPE REF TO z2ui5_cl_view.

    METHODS processflowlaneheader
      IMPORTING
        !iconsrc      TYPE clike OPTIONAL
        !laneid       TYPE clike OPTIONAL
        !position     TYPE clike OPTIONAL
        !state        TYPE clike OPTIONAL
        !text         TYPE clike OPTIONAL
        !zoomlevel    TYPE clike OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_view.

  PROTECTED SECTION.

    DATA mvname  TYPE string.
    DATA mvns     TYPE string.
    DATA mtprop  TYPE z2ui5_if_client=>ty_t_name_value.

    DATA moroot   TYPE REF TO z2ui5_cl_view.
    DATA moprevious   TYPE REF TO z2ui5_cl_view.
    DATA moparent TYPE REF TO z2ui5_cl_view.
    DATA mtchild  TYPE STANDARD TABLE OF REF TO z2ui5_cl_view WITH EMPTY KEY.

    DATA miclient TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.


ENDCLASS.



CLASS z2ui5_cl_view IMPLEMENTATION.


  METHOD actions.
    result = c( n = `actions`
                       ns   = ns ).
  ENDMETHOD.


  METHOD additionalcontent.
    result = c( `additionalContent` ).
  ENDMETHOD.


  METHOD appointments.
    result = c( `appointments` ).
  ENDMETHOD.


  METHOD appointmentitems.
    result = c( n = `appointmentItems` ).
  ENDMETHOD.


  METHOD avatar.
    result = me.
    c( n   = `Avatar`
              p = VALUE #( ( n = `src`         v = src )
                                ( n = `class`       v = class )
                                ( n = `displaysize` v = displaysize ) ) ).
  ENDMETHOD.


  METHOD axistimestrategy.
    result = c( n = `axisTimeStrategy`
                       ns   = `gantt` ).
  ENDMETHOD.


  METHOD badgecustomdata.
    result = me.
    c( n   = `BadgeCustomData`
              p = VALUE #( ( n = `key`      v = key )
                                ( n = `value`    v = value )
                                ( n = `visible`  v = z2ui5_cl_fw_utility=>boolean_abap_2_json( visible ) ) ) ).
  ENDMETHOD.


  METHOD bar.
    result = c( `Bar` ).
  ENDMETHOD.


  METHOD bars.
    result = c( n = `bars`
                       ns   = `mchart` ).
  ENDMETHOD.


  METHOD baserectangle.

    result = c( n   = `BaseRectangle`
                       ns     = 'gantt'
                       p = VALUE #( ( n = `time`                      v = time )
                                         ( n = `endtime`                   v = endtime )
                                         ( n = `selectable`                v = z2ui5_cl_fw_utility=>boolean_abap_2_json( selectable ) )
                                         ( n = `selectedFill`              v = selectedfill )
                                         ( n = `fill`                      v = fill )
                                         ( n = `height`                    v = height )
                                         ( n = `title`                     v = title )
                                         ( n = `animationSettings`         v = animationsettings )
                                         ( n = `alignShape`                v = alignshape )
                                         ( n = `color`                     v = color   )
                                         ( n = `fontSize`                  v = fontsize )
                                         ( n = `connectable`               v = z2ui5_cl_fw_utility=>boolean_abap_2_json( connectable ) )
                                         ( n = `fontFamily`                v = fontfamily )
                                         ( n = `filter`                    v = filter )
                                         ( n = `transform`                 v = transform )
                                         ( n = `countInBirdEye`            v = z2ui5_cl_fw_utility=>boolean_abap_2_json( countinbirdeye ) )
                                         ( n = `fontWeight`                v = fontweight   )
                                         ( n = `showTitle`                 v = z2ui5_cl_fw_utility=>boolean_abap_2_json( showtitle ) )
                                         ( n = `selected`                  v = z2ui5_cl_fw_utility=>boolean_abap_2_json( selected ) )
                                         ( n = `resizable`                 v = z2ui5_cl_fw_utility=>boolean_abap_2_json( resizable ) )
                                         ( n = `horizontalTextAlignment`   v = horizontaltextalignment )
                                         ( n = `highlighted`               v = z2ui5_cl_fw_utility=>boolean_abap_2_json( highlighted ) )
                                         ( n = `highlightable`             v = z2ui5_cl_fw_utility=>boolean_abap_2_json( highlightable ) ) ) ).
  ENDMETHOD.


  METHOD begincolumnpages.
    " todo, implement method
    result = c( n = `beginColumnPages`
                       ns   = `f` ).

  ENDMETHOD.


  METHOD blocks.
    result = c( n = `blocks`
                       ns   = `uxap` ).
  ENDMETHOD.


  METHOD blocklayout.
    result = c( n   = `BlockLayout`
                       ns     = `layout`
                       p = VALUE #( ( n = `background` v = background ) ) ).
  ENDMETHOD.


  METHOD blocklayoutcell.

    result = c( n   = `BlockLayoutCell`
                ns  = `layout`
                p   = VALUE #( ( n = `backgroundColorSet` v = backgroundcolorset )
                               ( n = `backgroundColorShade` v = backgroundcolorshade )
                               ( n = `title` v = title )
                               ( n = `titleAlignment` v = titlealignment )
                               ( n = `width` v = width )
                               ( n = `class` v = class )
                               ( n = `titleLevel` v = titlelevel ) ) ).

  ENDMETHOD.


  METHOD blocklayoutrow.
    result = c( n   = `BlockLayoutRow`
                       ns     = `layout`
                       p = VALUE #( ( n = `rowColorSet` v = rowcolorset ) ) ).
  ENDMETHOD.


  METHOD button.

    result = me.
    c( n   = `Button`
              ns     = ns
              p = VALUE #( ( n = `press`   v = press )
                                ( n = `text`    v = text )
                                ( n = `enabled` v = z2ui5_cl_fw_utility=>boolean_abap_2_json( enabled ) )
                                ( n = `visible` v = z2ui5_cl_fw_utility=>boolean_abap_2_json( visible ) )
                                ( n = `icon`    v = icon )
                                ( n = `type`    v = type )
                                ( n = `id`      v = id )
                                ( n = `class`   v = class ) ) ).
  ENDMETHOD.


  METHOD buttons.
    result = c( `buttons` ).
  ENDMETHOD.


  METHOD calendarappointment.
    result = c( n   = `CalendarAppointment`
                       ns     = `u`
                       p = VALUE #(
                             ( n = `startDate`                 v = startdate )
                             ( n = `endDate`                   v = enddate )
                             ( n = `icon`                      v = icon )
                             ( n = `title`                     v = title )
                             ( n = `text`                      v = text )
                             ( n = `type`                      v = type )
                             ( n = `key`                       v = key )
                             ( n = `tentative`                 v = tentative ) ) ).
  ENDMETHOD.


  METHOD calendarlegenditem.
    result = c( n   = `CalendarLegendItem`
                       p = VALUE #(
                           ( n = `text`                   v = text )
                           ( n = `type`                   v = type )
                           ( n = `tooltip`                v = tooltip )
                           ( n = `color`                  v = color ) ) ).

  ENDMETHOD.


  METHOD carousel.

    result = c( n   = `Carousel`
                       p = VALUE #( ( n = `loop`  v = z2ui5_cl_fw_utility=>boolean_abap_2_json( loop ) )
                                         ( n = `class`  v = class )
                                         ( n = `height`  v = height )
               ) ).

  ENDMETHOD.


  METHOD ccexportspreadsheet.

    result = me.
    c( n   = `ExportSpreadsheet`
              ns     = `z2ui5`
              p = VALUE #( ( n = `tableId`  v = tableid )
                                ( n = `text`     v = text )
                                ( n = `icon`     v = icon )
                                ( n = `type`     v = type )
              ) ).

  ENDMETHOD.


  METHOD ccexportspreadsheetgetjs.

    DATA(js) = ` debugger; jQuery.sap.declare("z2ui5.ExportSpreadsheet");` && |\n| &&
                          |\n| &&
                          `        sap.ui.define([` && |\n| &&
                          `            "sap/ui/core/Control",` && |\n| &&
                          `            "sap/m/Button",` && |\n| &&
                          `            "sap/ui/export/Spreadsheet"` && |\n| &&
                          `        ], function (Control, Button, Spreadsheet) {` && |\n| &&
                          `            "use strict";` && |\n| &&
                          |\n| &&
                          `            return Control.extend("z2ui5.ExportSpreadsheet", {` && |\n| &&
                          |\n| &&
                          `                metadata: {` && |\n| &&
                          `                    properties: {` && |\n| &&
                          `                        tableId: {` && |\n| &&
                          `                            type: "string",` && |\n| &&
                          `                            defaultValue: ""` && |\n| &&
                          `                        },` && |\n| &&
                          `                        type: {` && |\n| &&
                          `                            type: "string",` && |\n| &&
                          `                            defaultValue: ""` && |\n| &&
                          `                        },` && |\n| &&
                          `                        icon: {` && |\n| &&
                          `                            type: "string",` && |\n| &&
                          `                            defaultValue: ""` && |\n| &&
                          `                        },` && |\n| &&
                          `                        text: {` && |\n| &&
                          `                            type: "string",` && |\n| &&
                          `                            defaultValue: ""` && |\n| &&
                          `                        }` && |\n| &&
                          `                    },` && |\n| &&
                          |\n| &&
                          |\n| &&
                          `                    aggregations: {` && |\n| &&
                          `                    },` && |\n| &&
                          `                    events: { },` && |\n| &&
                          `                    renderer: null` && |\n| &&
                          `                },` && |\n| &&
                          |\n| &&
                          `                renderer: function (oRm, oControl) {` && |\n| &&
                          |\n| &&
                          `                    oControl.oExportButton = new Button({` && |\n| &&
                          `                        text: oControl.getProperty("text"),` && |\n| &&
                          `                        icon: oControl.getProperty("icon"), ` && |\n| &&
                          `                        type: oControl.getProperty("type"), ` && |\n| &&
                          `                        press: function (oEvent) { ` && |\n| &&
                          |\n| &&
                          `                             var aCols =` && columnconfig  && `;` && |\n| &&
                          |\n| &&
                          `                             var oBinding, oSettings, oSheet, oTable, vTableId, vViewPrefix,vPrefixTableId;` && |\n| &&
                          `                             vTableId = oControl.getProperty("tableId")` && |\n| &&
                          `                          //   vViewPrefix = sap.z2ui5.oView.sId;` && |\n| &&
                          `                           //  vPrefixTableId = vViewPrefix + "--" + vTableId;` && |\n| &&
                          `                             vPrefixTableId = sap.z2ui5.oView.createId( vTableId );` && |\n| &&
                          `                             oTable = sap.ui.getCore().byId(vPrefixTableId);` && |\n| &&
                          `                             oBinding = oTable.getBinding("rows");` && |\n| &&
                          `                             if (oBinding == null) {` && |\n| &&
                          `                               oBinding = oTable.getBinding("items");` && |\n| &&
                          `                             };` && |\n| &&
                          `                             oSettings = {` && |\n| &&
                          `                               workbook: { columns: aCols },` && |\n| &&
                          `                               dataSource: oBinding` && |\n| &&
                          `                             };` && |\n| &&
                          `                             oSheet = new Spreadsheet(oSettings);` && |\n| &&
                          `                             oSheet.build()` && |\n| &&
                          `                               .then(function() {` && |\n| &&
                          `                               }).finally(function() {` && |\n| &&
                          `                                 oSheet.destroy();` && |\n| &&
                          `                               });` && |\n| &&
                          `                         }.bind(oControl)` && |\n| &&
                          `                  });` && |\n| &&
                          |\n| &&
                          `                    oRm.renderControl(oControl.oExportButton);` && |\n| &&
                          `                }` && |\n| &&
                          `            });` && |\n| &&
                          `        });`.

    result = zzplain( `<html:script>` && js && `</html:script>` ).

  ENDMETHOD.


  METHOD ccfileuploader.

    result = me.
    c( n   = `FileUploader`
              ns     = `z2ui5`
              p = VALUE #( (  n = `placeholder` v = placeholder )
                                (  n = `upload`      v = upload )
                                (  n = `path`        v = path )
                                (  n = `value`       v = value ) ) ).

  ENDMETHOD.


  METHOD ccfileuploadergetjs.

    DATA(js) = ` debugger; jQuery.sap.declare("z2ui5.FileUploader");` && |\n| &&
                          |\n| &&
                          `        sap.ui.define([` && |\n| &&
                          `            "sap/ui/core/Control",` && |\n| &&
                          `            "sap/m/Button",` && |\n| &&
                          `            "sap/ui/unified/FileUploader"` && |\n| &&
                          `        ], function (Control, Button, FileUploader) {` && |\n| &&
                          `            "use strict";` && |\n| &&
                          |\n| &&
                          `            return Control.extend("z2ui5.FileUploader", {` && |\n| &&
                          |\n| &&
                          `                metadata: {` && |\n| &&
                          `                    properties: {` && |\n| &&
                          `                        value: {` && |\n| &&
                          `                            type: "string",` && |\n| &&
                          `                            defaultValue: ""` && |\n| &&
                          `                        },` && |\n| &&
                          `                        path: {` && |\n| &&
                          `                            type: "string",` && |\n| &&
                          `                            defaultValue: ""` && |\n| &&
                          `                        },` && |\n| &&
                          `                        tooltip: {` && |\n| &&
                          `                            type: "string",` && |\n| &&
                          `                            defaultValue: ""` && |\n| &&
                          `                        },` && |\n| &&
                          `                        fileType: {` && |\n| &&
                          `                            type: "string",` && |\n| &&
                          `                            defaultValue: ""` && |\n| &&
                          `                        },` && |\n| &&
                          `                        placeholder: {` && |\n| &&
                          `                            type: "string",` && |\n| &&
                          `                            defaultValue: ""` && |\n| &&
                          `                        },` && |\n| &&
                          `                        buttonText: {` && |\n| &&
                          `                            type: "string",` && |\n| &&
                          `                            defaultValue: "Upload"` && |\n| &&
                          `                        },` && |\n| &&
                          `                        enabled: {` && |\n| &&
                          `                            type: "boolean",` && |\n| &&
                          `                            defaultValue: true` && |\n| &&
                          `                        },` && |\n| &&
                          `                        multiple: {` && |\n| &&
                          `                            type: "boolean",` && |\n| &&
                          `                            defaultValue: false` && |\n| &&
                          `                        }` && |\n| &&
                          `                    },` && |\n| &&
                          |\n| &&
                          |\n| &&
                          `                    aggregations: {` && |\n| &&
                          `                    },` && |\n| &&
                          `                    events: {` && |\n| &&
                          `                        "upload": {` && |\n| &&
                          `                            allowPreventDefault: true,` && |\n| &&
                          `                            parameters: {}` && |\n| &&
                          `                        }` && |\n| &&
                          `                    },` && |\n| &&
                          `                    renderer: null` && |\n| &&
                          `                },` && |\n| &&
                          |\n| &&
                          `                renderer: function (oRm, oControl) {` && |\n| &&
                          |\n| &&
                          `                    oControl.oUploadButton = new Button({` && |\n| &&
                          `                        text: oControl.getProperty("buttonText"),` && |\n| &&
                          `                        enabled: oControl.getProperty("path") !== "",` && |\n| &&
                          `                        press: function (oEvent) { ` && |\n| &&
                          |\n| &&
                          `                            this.setProperty("path", this.oFileUploader.getProperty("value"));` && |\n| &&
                          |\n| &&
                          `                            var file = sap.z2ui5.oUpload.oFileUpload.files[0];` && |\n| &&
                          `                            var reader = new FileReader();` && |\n| &&
                          |\n| &&
                          `                            reader.onload = function (evt) {` && |\n| &&
                          `                                var vContent = evt.currentTarget.result;` && |\n| &&
                          `                                this.setProperty("value", vContent);` && |\n| &&
                          `                                this.fireUpload();` && |\n| &&
                          `                                //this.getView().byId('picture' ).getDomRef().src = vContent;` && |\n| &&
                          `                            }.bind(this)` && |\n| &&
                          |\n| &&
                          `                            reader.readAsDataURL(file);` && |\n| &&
                          `                        }.bind(oControl)` && |\n| &&
                          `                    });` && |\n| &&
                          |\n| &&
                          `                    oControl.oFileUploader = new FileUploader({` && |\n| &&
                          `                        icon: "sap-icon://browse-folder",` && |\n| &&
                          `                        iconOnly: true,` && |\n| &&
                          `                        value: oControl.getProperty("path"),` && |\n| &&
                          `                        placeholder: oControl.getProperty("placeholder"),` && |\n| &&
                          `                        change: function (oEvent) {` && |\n| &&
                          `                            var value = oEvent.getSource().getProperty("value");` && |\n| &&
                          `                            this.setProperty("path", value);` && |\n| &&
                          `                            if (value) {` && |\n| &&
                          `                                this.oUploadButton.setEnabled();` && |\n| &&
                          `                            } else {` && |\n| &&
                          `                                this.oUploadButton.setEnabled(false);` && |\n| &&
                          `                            }` && |\n| &&
                          `                            this.oUploadButton.rerender();` && |\n| &&
                          `                            sap.z2ui5.oUpload = oEvent.oSource;` && |\n| &&
                          `                        }.bind(oControl)` && |\n| &&
                          `                    });` && |\n| &&
                          |\n| &&
                          `                    var hbox = new sap.m.HBox();` && |\n| &&
                          `                    hbox.addItem(oControl.oFileUploader);` && |\n| &&
                          `                    hbox.addItem(oControl.oUploadButton);` && |\n| &&
                          `                    oRm.renderControl(hbox);` && |\n| &&
                          `                }` && |\n| &&
                          `            });` && |\n| &&
                          `        });`.

    result = zzplain( `<html:script>` && js && `</html:script>` ).

  ENDMETHOD.


  METHOD cells.
    result = c( `cells` ).
  ENDMETHOD.


  METHOD checkbox.

    result = me.
    c( n   = `CheckBox`
              p = VALUE #( ( n = `text`     v = text )
                                ( n = `selected` v = selected )
                                ( n = `enabled`  v = z2ui5_cl_fw_utility=>boolean_abap_2_json( enabled ) )
                                ( n = `select`   v = select ) ) ).
  ENDMETHOD.


  METHOD codeeditor.
    result = me.
    c( n   = `CodeEditor`
              ns     = `editor`
              p = VALUE #( ( n = `value`   v = value )
                                ( n = `type`    v = type )
                                ( n = `editable`   v = z2ui5_cl_fw_utility=>boolean_abap_2_json( editable ) )
                                ( n = `height` v = height )
                                ( n = `width`  v = width ) ) ).
  ENDMETHOD.


  METHOD column.
    result = c( n   = `Column`
                       p = VALUE #( ( n = `width` v = width )
                                         ( n = `minScreenWidth` v = minscreenwidth )
                                         ( n = `halign` v = halign )
                                         ( n = `demandPopin` v = z2ui5_cl_fw_utility=>boolean_abap_2_json( demandpopin ) ) ) ).
  ENDMETHOD.


  METHOD columns.
    result = c( `columns` ).
  ENDMETHOD.


  METHOD columnlistitem.
    result = c( n   = `ColumnListItem`
                       p = VALUE #( ( n = `vAlign`   v = valign )
                                         ( n = `selected` v = selected )
                                         ( n = `type`     v = type )
                                         ( n = `press`    v = press ) ) ).
  ENDMETHOD.


  METHOD combobox.
    result = c( n   = `ComboBox`
                       p = VALUE #( (  n = `showClearIcon` v = z2ui5_cl_fw_utility=>boolean_abap_2_json( showclearicon ) )
                                         (  n = `selectedKey`   v = selectedkey )
                                         (  n = `items`         v = items )
                                         (  n = `label`         v = label )
                                         (  n = `change`        v = change ) ) ).
  ENDMETHOD.


  METHOD constructor.

    mtprop = VALUE #( ( n = `xmlns`           v = `sap.m` )
                       ( n = `xmlns:z2ui5`     v = `z2ui5` )
                       ( n = `xmlns:core`      v = `sap.ui.core` )
                       ( n = `xmlns:mvc`       v = `sap.ui.core.mvc` )
                       ( n = `xmlns:layout`    v = `sap.ui.layout` )
*                       ( n = `core:require` v = `{ MessageToast: 'sap/m/MessageToast' }` )
*                       ( n = `core:require` v = `{ URLHelper: 'sap/m/library/URLHelper' }` )
                       ( n = `xmlns:table `    v = `sap.ui.table` )
                       ( n = `xmlns:f`         v = `sap.f` )
                       ( n = `xmlns:form`      v = `sap.ui.layout.form` )
                       ( n = `xmlns:editor`    v = `sap.ui.codeeditor` )
                       ( n = `xmlns:mchart`    v = `sap.suite.ui.microchart` )
                       ( n = `xmlns:webc`      v = `sap.ui.webc.main` )
                       ( n = `xmlns:uxap`      v = `sap.uxap` )
                       ( n = `xmlns:sap`       v = `sap` )
                       ( n = `xmlns:text`      v = `sap.ui.richtextedito` )
                       ( n = `xmlns:html`      v = `http://www.w3.org/1999/xhtml` )
                       ( n = `xmlns:fb`        v = `sap.ui.comp.filterbar` )
                       ( n = `xmlns:u`         v = `sap.ui.unified` )
                       ( n = `xmlns:gantt`     v = `sap.gantt.simple` )
                       ( n = `xmlns:axistime`  v = `sap.gantt.axistime` )
                       ( n = `xmlns:config`    v = `sap.gantt.config` )
                       ( n = `xmlns:shapes`    v = `sap.gantt.simple.shapes` )
                       ( n = `xmlns:commons`   v = `sap.suite.ui.commons` )
                       ( n = `xmlns:tnt `      v = `sap.tnt` ) ).

  ENDMETHOD.


  METHOD containertoolbar.
    result = c( n   = `ContainerToolbar`
                       ns     = `gantt`
                       p = VALUE #( ( n = `showSearchButton`          v = showsearchbutton )
                                         ( n = `alignCustomContentToRight` v = z2ui5_cl_fw_utility=>boolean_abap_2_json( aligncustomcontenttoright ) )
                                         ( n = `findMode`                  v = findmode )
                                         ( n = `infoOfSelectItems`         v = infoofselectitems )
                                         ( n = `showBirdEyeButton`         v = z2ui5_cl_fw_utility=>boolean_abap_2_json( showbirdeyebutton ) )
                                         ( n = `showDisplayTypeButton`     v = z2ui5_cl_fw_utility=>boolean_abap_2_json( showdisplaytypebutton ) )
                                         ( n = `showLegendButton`          v = z2ui5_cl_fw_utility=>boolean_abap_2_json( showlegendbutton ) )
                                         ( n = `showSettingButton`         v = z2ui5_cl_fw_utility=>boolean_abap_2_json( showsettingbutton ) )
                                         ( n = `showTimeZoomControl`       v = z2ui5_cl_fw_utility=>boolean_abap_2_json( showtimezoomcontrol ) )
                                         ( n = `stepCountOfSlider`         v = stepcountofslider )
                                         ( n = `zoomControlType`           v = zoomcontroltype )
                                         ( n = `zoomLevel`                 v = zoomlevel )
                                       ) ).
  ENDMETHOD.


  METHOD content.

    result = c( ns   = ns
                       n = `content` ).

  ENDMETHOD.


  METHOD contentleft.
    result = c( `contentLeft` ).
  ENDMETHOD.


  METHOD contentmiddle.
    result = c( `contentMiddle` ).
  ENDMETHOD.


  METHOD contentright.
    result = c( `contentRight` ).
  ENDMETHOD.


  METHOD currency.
    result = c( n = `Currency`
                       ns   = 'u'
                    p  = VALUE #(
                          ( n = `value` v = value )
                          ( n = `currency`  v = currency ) ) ).

  ENDMETHOD.


  METHOD customdata.
    result = c( `customData` ).
  ENDMETHOD.


  METHOD customheader.
    result = c( `customHeader` ).
  ENDMETHOD.


  METHOD customlistitem.
    result = c( `CustomListItem` ).
  ENDMETHOD.


  METHOD datepicker.
    result = me.
    c( n   = `DatePicker`
              p = VALUE #( ( n = `value`                 v = value )
                                ( n = `displayFormat`         v = displayformat )
                                ( n = `valueFormat`           v = valueformat )
                                ( n = `required`              v = z2ui5_cl_fw_utility=>boolean_abap_2_json( required ) )
                                ( n = `valueState`            v = valuestate )
                                ( n = `valueStateText`        v = valuestatetext )
                                ( n = `placeholder`           v = placeholder )
                                ( n = `enabled`               v = z2ui5_cl_fw_utility=>boolean_abap_2_json( enabled ) )
                                ( n = `showCurrentDateButton` v = z2ui5_cl_fw_utility=>boolean_abap_2_json( showcurrentdatebutton ) ) ) ).
  ENDMETHOD.


  METHOD datetimepicker.
    result = me.
    c( n   = `DateTimePicker`
              p = VALUE #( ( n = `value` v = value )
                                ( n = `placeholder`  v = placeholder )
                                ( n = `enabled` v = z2ui5_cl_fw_utility=>boolean_abap_2_json( enabled ) )
                                ( n = `valueState` v = valuestate ) ) ).
  ENDMETHOD.


  METHOD dialog.

    result = c( n   = `Dialog`
                       p = VALUE #( ( n = `title`  v = title )
                                         ( n = `icon`  v = icon )
                                         ( n = `stretch`  v = stretch )
                                         ( n = `showHeader`  v = showheader )
                                         ( n = `contentWidth`  v = contentwidth )
                                         ( n = `contentHeight`  v = contentheight )
                                         ( n = `resizable`  v = z2ui5_cl_fw_utility=>boolean_abap_2_json( resizable ) ) ) ).

  ENDMETHOD.


  METHOD dynamicpage.
    result = c( n   = `DynamicPage`
                       ns     = `f`
                       p = VALUE #(
                           (  n = `headerExpanded`           v = z2ui5_cl_fw_utility=>boolean_abap_2_json( headerexpanded ) )
                           (  n = `headerPinned`           v = z2ui5_cl_fw_utility=>boolean_abap_2_json( headerpinned ) )
                           (  n = `showFooter`           v = z2ui5_cl_fw_utility=>boolean_abap_2_json( showfooter ) )
                           (  n = `toggleHeaderOnTitleClick` v = toggleheaderontitleclick ) ) ).
  ENDMETHOD.


  METHOD dynamicpageheader.
    result = c(
                 n   = `DynamicPageHeader`
                 ns     = `f`
                 p = VALUE #( (  n = `pinnable`           v = z2ui5_cl_fw_utility=>boolean_abap_2_json( pinnable ) ) ) ).
  ENDMETHOD.


  METHOD dynamicpagetitle.
    result = c( n = `DynamicPageTitle`
                       ns   = `f` ).
  ENDMETHOD.


  METHOD dynamicsidecontent.
    result = c( n   = `DynamicSideContent`
                       ns     = 'layout'
                       p = VALUE #(
                           ( n = `id`                              v = id )
                           ( n = `class`                           v = class )
                           ( n = `sideContentVisibility`           v = sidecontentvisibility )
                           ( n = `showSideContent`                 v = showsidecontent )
                           ( n = `containerQuery`                  v = containerquery ) ) ).

  ENDMETHOD.


  METHOD endcolumnpages.
    " todo, implement method
    result = me.
  ENDMETHOD.


  METHOD expandedcontent.
    result = c( n = `expandedContent`
                       ns   = ns ).
  ENDMETHOD.


  METHOD expandedheading.
    result = c( n = `expandedHeading`
                       ns   = `uxap` ).
  ENDMETHOD.


  METHOD factory.

    result = NEW #( ).

    IF tns IS NOT INITIAL.
      result->mtprop = tns.
    ENDIF.

    result->miclient = client.
    result->mtprop  = VALUE #( BASE result->mtprop
                                (  n = 'displayBlock'   v = 'true' )
                                (  n = 'height'         v = '100%' ) ).

    result->mvname   = `View`.
    result->mvns     = `mvc`.
    result->moroot   = result.
    result->moparent = result.

  ENDMETHOD.


  METHOD factorypopup.

    result = NEW #( ).

    IF tns IS NOT INITIAL.
      result->mtprop = tns.
    ENDIF.

    result->miclient = client.
    result->mvname   = `FragmentDefinition`.
    result->mvns     = `core`.
    result->moroot   = result.
    result->moparent = result.

  ENDMETHOD.


  METHOD filterbar.

    result = c( n   = `FilterBar`
                       ns     = 'fb'
                       p = VALUE #( ( n = 'useToolbar'    v = usetoolbar )
                                         ( n = 'search'        v = search )
                                         ( n = 'filterChange'  v = filterchange ) ) ).
  ENDMETHOD.


  METHOD filtercontrol.
    result = c( n = `control`
                       ns   = 'fb' ).
  ENDMETHOD.


  METHOD filtergroupitem.
    result = c( n   = `FilterGroupItem`
                       ns     = 'fb'
                       p = VALUE #( ( n = 'name'                v  = name )
                                         ( n = 'label'               v  = label )
                                         ( n = 'groupName'           v  = groupname )
                                         ( n = 'visibleInFilterBar'  v  = visibleinfilterbar ) ) ).
  ENDMETHOD.


  METHOD filtergroupitems.
    result = c( n = `filterGroupItems`
                       ns   = 'fb' ).
  ENDMETHOD.


  METHOD flexiblecolumnlayout.

    result = c( n   = `FlexibleColumnLayout`
                       ns     = `f`
                       p = VALUE #(
                        (  n = `layout` v = layout )
                        (  n = `id` v = id )
                        ) ).

  ENDMETHOD.


  METHOD flexbox.
    result = c( n   = `FlexBox`
                       p = VALUE #( ( n = `class`  v = class )
                                         ( n = `renderType`  v = rendertype )
                                         ( n = `width`  v = width )
                                         ( n = `height`  v = height )
                                         ( n = `alignItems`  v = alignitems )
                                         ( n = `fitContainer`  v = z2ui5_cl_fw_utility=>boolean_abap_2_json( fitcontainer ) )
                                         ( n = `justifyContent`  v = justifycontent )
                                         ( n = `wrap`  v = wrap )
                                         ( n = `visible`  v = visible ) ) ).
  ENDMETHOD.


  METHOD flexitemdata.
    result = me.

    c( n   = `FlexItemData`
              p = VALUE #( ( n = `growFactor`  v = growfactor )
                                ( n = `baseSize`   v = basesize )
                                ( n = `backgroundDesign`   v = backgrounddesign )
                                ( n = `styleClass`   v = styleclass ) ) ).
  ENDMETHOD.


  METHOD footer.
    result = c( ns   = ns
                       n = `footer` ).
  ENDMETHOD.


  METHOD formattedtext.
    result = me.
    c( n   = `FormattedText`
              p = VALUE #( ( n = `htmlText` v = htmltext ) ) ).
  ENDMETHOD.


  METHOD ganttchartcontainer.
    result = c( n = `GanttChartContainer`
                       ns   = `gantt` ).
  ENDMETHOD.


  METHOD ganttchartwithtable.
    result = c( n   = `GanttChartWithTable`
                       ns     = `gantt`
                       p = VALUE #( ( n = `id` v = id )
                                       ( n = `shapeSelectionMode` v = shapeselectionmode ) ) ).
  ENDMETHOD.


  METHOD ganttrowsettings.
    result = c( n   = `GanttRowSettings`
                       ns     = `gantt`
                       p = VALUE #( ( n = `rowId` v = rowid )
                                   ( n = `shapes1` v = shapes1 )
                                   ( n = `shapes2` v = shapes2 ) ) ).
  ENDMETHOD.


  METHOD gantttable.
    result = c( n = `table`
                       ns   = `gantt` ).
  ENDMETHOD.


  METHOD gantttoolbar.
    result = c( n = `toolbar`
                       ns   = 'gantt' ).
  ENDMETHOD.


  METHOD generictag.

    result = c( n   = `GenericTag`
                       p = VALUE #( ( n = `ariaLabelledBy`           v = arialabelledby )
                                         ( n = `class`        v = class )
                                         ( n = `design`          v = design )
                                         ( n = `status`  v = status )
                                         ( n = `text`   v = text ) ) ).

  ENDMETHOD.


  METHOD generictile.

    result = me.
    c(
      n   = `GenericTile`
      ns     = ``
      p = VALUE #(
                ( n = `class`      v = class )
                ( n = `header`     v = header )
                ( n = `mode`     v = mode )
                ( n = `press`      v = press )
                ( n = `frameType`  v = frametype )
                ( n = `subheader`  v = subheader ) ) ).

  ENDMETHOD.


  METHOD get.

    IF name IS INITIAL.
      result = moroot->moprevious.
      RETURN.
    ENDIF.

    IF moparent->mvname = name.
      result = moparent.
    ELSE.
      IF moroot = me.
        RAISE EXCEPTION TYPE z2ui5_cx_fw_error
          EXPORTING
            val = `NOCONTROLFOUNDWITHNAME` && name.
      ENDIF.
      result = moparent->get( name ).
    ENDIF.

  ENDMETHOD.


  METHOD getchild.
    result = mtchild[ index ].
  ENDMETHOD.


  METHOD getparent.
    result = moparent.
  ENDMETHOD.


  METHOD getroot.
    result = moroot.
  ENDMETHOD.


  METHOD grid.

    result = c( n   = `Grid`
                       ns     = `layout`
                       p = VALUE #( ( n = `defaultSpan` v = defaultspan )
                                         ( n = `class`       v = class ) ) ).
  ENDMETHOD.


  METHOD griddata.
    result = me.
    c( n   = `GridData`
              ns     = `layout`
              p = VALUE #( ( n = `span` v = span ) ) ).
  ENDMETHOD.


  METHOD hbox.
    result = c( n   = `HBox`
                       p = VALUE #( ( n = `class`          v = class )
                                         ( n = `alignContent`   v = aligncontent )
                                         ( n = `alignItems`     v = alignitems )
                                         ( n = `width`          v = width )
                                         ( n = `height`         v = height )
                                         ( n = `wrap`           v = wrap )
                                         ( n = `justifyContent` v = justifycontent ) ) ).

  ENDMETHOD.


  METHOD header.
    result = c( n = `header`
                       ns   = ns ).
  ENDMETHOD.


  METHOD headercontent.
    result = c( n = `headerContent`
                       ns   = ns ).
  ENDMETHOD.


  METHOD headertitle.
    result = c( n = `headerTitle`
                       ns   = `uxap` ).
  ENDMETHOD.


  METHOD headertoolbar.
    result = c( `headerToolbar` ).
  ENDMETHOD.


  METHOD heading.

    result = me.
    result = c( n = `heading`
                       ns   = ns ).

  ENDMETHOD.


  METHOD hlpgetappurl.

    IF classname IS NOT SUPPLIED.
      classname = z2ui5_cl_fw_utility=>rtti_get_classname_by_ref( miclient->get( )-s_draft-app ).
    ENDIF.

    DATA(lvurl) = to_lower( miclient->get( )-s_config-origin && miclient->get( )-s_config-pathname ) && `?`.
    DATA(ltparam) = z2ui5_cl_fw_utility=>url_param_get_tab( miclient->get( )-s_config-search ).
    DELETE ltparam WHERE n = `appstart`.
    INSERT VALUE #( n = `appstart` v = to_lower( classname ) ) INTO TABLE ltparam.

    result = lvurl && z2ui5_cl_fw_utility=>url_param_create_url( ltparam ).

  ENDMETHOD.


  METHOD hlpgetsourcecodeurl.

    DATA(lsdraft) = moroot->miclient->get( )-s_draft.
    DATA(lsconfig) = moroot->miclient->get( )-s_config.

    result = lsconfig-origin && `/sap/bc/adt/oo/classes/`
       && z2ui5_cl_fw_utility=>rtti_get_classname_by_ref( lsdraft-app ) && `/source/main`.

  ENDMETHOD.


  METHOD hlpgeturlparam.

    result = z2ui5_cl_fw_utility=>url_param_get(
      val = val
      url = miclient->get( )-s_config-search ).

  ENDMETHOD.


  METHOD hlpseturlparam.

    DATA(result) = z2ui5_cl_fw_utility=>url_param_set(
      url   = miclient->get( )-s_config-search
      name  = n
      value = v ).

    miclient->url_param_set( result ).

  ENDMETHOD.


  METHOD horizontallayout.
    result = c( n   = `HorizontalLayout`
                       ns     = `layout`
                       p = VALUE #( ( n = `class`  v = class )
                                         ( n = `width`  v = width ) ) ).
  ENDMETHOD.


  METHOD icontabbar.

    result = c( n   = `IconTabBar`
                       p = VALUE #( ( n = `class`       v = class )
                                       ( n = `select`      v = select )
                                       ( n = `expand`      v = expand )
                                       ( n = `expandable`  v = expandable )
                                       ( n = `expanded`    v = expanded )
                                       ( n = `selectedKey` v = selectedkey ) ) ).
  ENDMETHOD.


  METHOD icontabfilter.

    result = c( n   = `IconTabFilter`
                       p = VALUE #( ( n = `icon`        v = icon )
                                       (  n = `items`    v = items )
                                       ( n = `iconColor`   v = iconcolor )
                                       ( n = `showAll`     v = showall )
                                       ( n = `count`       v = count )
                                       ( n = `text`        v = text )
                                       ( n = `key`         v = key ) ) ).
  ENDMETHOD.


  METHOD icontabheader.

    result = c( n   = `IconTabHeader`
                       p = VALUE #( (  n = `selectedKey`     v = selectedkey )
                                         (  n = `items`           v = items )
                                         (  n = `select`          v = select )
                                         (  n = `mode`            v = mode  ) ) ).

  ENDMETHOD.


  METHOD icontabseparator.

    result = c( `IconTabSeparator` ).

  ENDMETHOD.


  METHOD illustratedmessage.

    result = c( n   = `IllustratedMessage`
                       p = VALUE #( ( n = `enableVerticalResponsiveness` v = enableverticalresponsiveness )
                       ( n = `illustrationType`             v = illustrationtype )
                       ( n = `enableFormattedText`             v = z2ui5_cl_fw_utility=>boolean_abap_2_json( enableformattedtext ) )
                       ( n = `illustrationSize`             v = illustrationsize )
                       ( n = `description`             v = description )
                       ( n = `title`             v = title )
                       ) ).
  ENDMETHOD.


  METHOD image.
    result = me.
    c( n   = `Image`
              p = VALUE #(
                ( n = `src` v = src )
                ( n = class v = class )
                ( n = `height` v = height )
                 ) ).
  ENDMETHOD.


  METHOD imagecontent.

    result = c( n   = `ImageContent`
                       p = VALUE #( ( n = `src` v = src ) ) ).


  ENDMETHOD.


  METHOD infolabel.
    result = c( n   = `InfoLabel`
                       ns     = 'tnt'
                       p = VALUE #(
                           ( n = `id`                   v = id )
                           ( n = `text`                 v = text )
                           ( n = `renderMode `          v = rendermode  )
                           ( n = `colorScheme`          v = colorscheme )
                           ( n = `displayOnly`          v = displayonly )
                           ( n = `icon`                 v = icon )
                           ( n = `textDirection`        v = textdirection )
                           ( n = `width`                v = width ) ) ).

  ENDMETHOD.


  METHOD input.
    result = me.
    c( n   = `Input`
              p = VALUE #( ( n = `id`               v = id )
                                ( n = `placeholder`      v = placeholder )
                                ( n = `type`             v = type )
                                ( n = `showClearIcon`    v = z2ui5_cl_fw_utility=>boolean_abap_2_json( showclearicon ) )
                                ( n = `description`      v = description )
                                ( n = `editable`         v = z2ui5_cl_fw_utility=>boolean_abap_2_json( editable ) )
                                ( n = `enabled`          v = z2ui5_cl_fw_utility=>boolean_abap_2_json( enabled ) )
                                ( n = `visible`          v = z2ui5_cl_fw_utility=>boolean_abap_2_json( visible ) )
                                ( n = `showTableSuggestionValueHelp`          v = z2ui5_cl_fw_utility=>boolean_abap_2_json( showtablesuggestionvaluehelp ) )
                                ( n = `valueState`       v = valuestate )
                                ( n = `valueStateText`   v = valuestatetext )
                                ( n = `value`            v = value )
                                ( n = `required`          v = z2ui5_cl_fw_utility=>boolean_abap_2_json( required ) )
                                ( n = `suggest`          v = suggest )
                                ( n = `suggestionItems`  v = suggestionitems )
                                ( n = `suggestionRows`   v = suggestionrows )
                                ( n = `showSuggestion`   v = z2ui5_cl_fw_utility=>boolean_abap_2_json( showsuggestion ) )
                                ( n = `valueHelpRequest` v = valuehelprequest )
                                ( n = `autocomplete`     v = z2ui5_cl_fw_utility=>boolean_abap_2_json( autocomplete ) )
                                ( n = `valueLiveUpdate`  v = z2ui5_cl_fw_utility=>boolean_abap_2_json( valueliveupdate ) )
                                ( n = `submit`           v = z2ui5_cl_fw_utility=>boolean_abap_2_json( submit ) )
                                ( n = `showValueHelp`    v = z2ui5_cl_fw_utility=>boolean_abap_2_json( showvaluehelp ) )
                                ( n = `valueHelpOnly`    v = z2ui5_cl_fw_utility=>boolean_abap_2_json( valuehelponly ) )
                                ( n = `class`            v = class )
                                ( n = `maxSuggestionWidth` v = maxsuggestionwidth )
                                ( n = `fieldWidth`          v = fieldwidth ) ) ).
  ENDMETHOD.


  METHOD inputlistitem.
    result = c( n   = `InputListItem`
                       p = VALUE #( ( n = `label` v = label ) ) ).
  ENDMETHOD.


  METHOD interactbarchart.
    result = c( n   = `InteractiveBarChart`
                       ns     = `mchart`
                       p = VALUE #( ( n = `selectionChanged`  v = selectionchanged )
                                         ( n = `showError`         v = showerror )
                                         ( n = `press`             v = press )
                                         ( n = `labelWidth`        v = labelwidth )
                                         ( n = `errorMessageTitle` v = errormessagetitle )
                                         ( n = `errorMessage`      v = errormessage ) ) ).
  ENDMETHOD.


  METHOD interactbarchartbar.
    result = c( n   = `InteractiveBarChartBar`
                       ns     = `mchart`
                       p = VALUE #( ( n = `label`          v = label )
                                         ( n = `displayedValue` v = displayedvalue )
                                         ( n = `value`          v = value )
                                         ( n = `selected`       v = selected ) ) ).
  ENDMETHOD.


  METHOD interactdonutchart.
    result = c( n   = `InteractiveDonutChart`
                       ns     = `mchart`
                       p = VALUE #( ( n = `selectionChanged`  v = selectionchanged )
                                         ( n = `showError`         v = z2ui5_cl_fw_utility=>boolean_abap_2_json( showerror ) )
                                         ( n = `errorMessageTitle` v = errormessagetitle )
                                         ( n = `errorMessage`      v = errormessage )
                                         ( n = `displayedSegments` v = displayedsegments )
                                         ( n = `press`             v = press ) ) ).
  ENDMETHOD.


  METHOD interactdonutchartsegment.
    result = c( n   = `InteractiveDonutChartSegment`
                       ns     = `mchart`
                       p = VALUE #( ( n = `label`          v = label )
                                         ( n = `displayedValue` v = displayedvalue )
                                         ( n = `value`          v = value )
                                         ( n = `selected`       v = selected ) ) ).
  ENDMETHOD.


  METHOD interactlinechart.
    result = c( n   = `InteractiveLineChart`
                       ns     = `mchart`
                       p = VALUE #( ( n = `selectionChanged`  v = selectionchanged )
                                         ( n = `showError`         v = z2ui5_cl_fw_utility=>boolean_abap_2_json( showerror ) )
                                         ( n = `press`             v = press )
                                         ( n = `errorMessageTitle` v = errormessagetitle )
                                         ( n = `errorMessage`      v = errormessage )
                                         ( n = `precedingPoint`    v = precedingpoint )
                                         ( n = `succeedingPoint`   v = succeddingpoint ) ) ).
  ENDMETHOD.


  METHOD interactlinechartpoint.
    result = c( n   = `InteractiveLineChartPoint`
                       ns     = `mchart`
                       p = VALUE #( ( n = `label`          v = label )
                                         ( n = `secondaryLabel` v = secondarylabel )
                                         ( n = `value`          v = value )
                                         ( n = `displayedValue` v = displayedvalue )
                                         ( n = `selected`       v = z2ui5_cl_fw_utility=>boolean_abap_2_json( selected ) ) ) ).
  ENDMETHOD.


  METHOD intervalheaders.
    result = c( `intervalHeaders` ).
  ENDMETHOD.


  METHOD item.
    result = me.
    c( n   = `Item`
              ns     = `core`
              p = VALUE #( ( n = `key`  v = key )
                                ( n = `text` v = text ) ) ).
  ENDMETHOD.


  METHOD items.
    result = c( `items` ).
  ENDMETHOD.


  METHOD label.
    result = me.
    c( n   = `Label`
              p = VALUE #( ( n = `text`     v = text )
                                ( n = `design`   v = design )
                                ( n = `labelFor` v = labelfor ) ) ).
  ENDMETHOD.


  METHOD lanes.
    result = c( n = `lanes`
                       ns   = `commons` ).
  ENDMETHOD.


  METHOD layoutdata.
    result = c( ns   = ns
                       n = `layoutData` ).
  ENDMETHOD.


  METHOD link.
    result = me.
    c( n   = `Link`
              ns     = ns
              p = VALUE #( ( n = `text`    v = text )
                                ( n = `target`  v = target )
                                ( n = `href`    v = href )
                                ( n = `press`   v = press )
                                ( n = `id`      v = id )
                                ( n = `enabled` v = z2ui5_cl_fw_utility=>boolean_abap_2_json( enabled ) ) ) ).
  ENDMETHOD.


  METHOD list.
    result = c( n   = `List`
                       p = VALUE #( ( n = `headerText`      v = headertext )
                                         ( n = `items`           v = items )
                                         ( n = `mode`            v = mode )
                                         ( n = `selectionChange` v = selectionchange )
                                         ( n = `noData` v = nodata ) ) ).
  ENDMETHOD.


  METHOD listitem.
    result = me.
    c( n   = `ListItem`
              ns     = `core`
              p = VALUE #( ( n = `text` v = text )
                                ( n = `additionalText` v = additionaltext ) ) ).
  ENDMETHOD.


  METHOD maincontents.
    result = c( n   = `mainContents`
                       ns     = `tnt` ).

  ENDMETHOD.


  METHOD menuitem.
    result = me.
    c( n   = `MenuItem`
              p = VALUE #( ( n = `press`   v = press )
                                ( n = `text`    v = text )
                                ( n = `icon`    v = icon ) ) ).
  ENDMETHOD.


  METHOD messageitem.
    result = c( n   = `MessageItem`
                       p = VALUE #( ( n = `type`        v = type )
                                         ( n = `title`       v = title )
                                         ( n = `subtitle`    v = subtitle )
                                         ( n = `description` v = description )
                                         ( n = `groupName`   v = groupname )
                                         ( n = `markupDescription`   v = z2ui5_cl_fw_utility=>boolean_abap_2_json( markupdescription ) ) ) ).
  ENDMETHOD.


  METHOD messagepage.
    result = c( n   = `MessagePage`
                       p = VALUE #(
                           ( n = `showHeader`          v = z2ui5_cl_fw_utility=>boolean_abap_2_json( showheader ) )
                           ( n = `description`         v = description )
                           ( n = `icon`                v = icon )
                           ( n = `text`                v = text )
                           ( n = `enableFormattedText` v = z2ui5_cl_fw_utility=>boolean_abap_2_json( enableformattedtext ) )
                            ) ).
  ENDMETHOD.


  METHOD messagepopover.
    result = c( n   = `MessagePopover`
                       p = VALUE #( ( n = `items`      v = items )
                                         ( n = `groupItems` v = z2ui5_cl_fw_utility=>boolean_abap_2_json( groupitems ) ) ) ).
  ENDMETHOD.


  METHOD messagestrip.
    result = me.
    c( n   = `MessageStrip`
              p = VALUE #( ( n = `text`     v = text )
                                ( n = `type`     v = type )
                                ( n = `showIcon` v = z2ui5_cl_fw_utility=>boolean_abap_2_json( showicon ) )
                                ( n = `class`    v = class ) ) ).
  ENDMETHOD.


  METHOD messageview.

    result = c( n   = `MessageView`
                       p = VALUE #( ( n = `items`      v = items )
                                         ( n = `groupItems` v = z2ui5_cl_fw_utility=>boolean_abap_2_json( groupitems ) ) ) ).
  ENDMETHOD.


  METHOD midcolumnpages.

    result = c( n   = `midColumnPages`
                       ns     = `f`
                       p = VALUE #( ( n = `id` v = id ) ) ).

  ENDMETHOD.


  METHOD multicombobox.
    result = c( n   = `ComboBox`
                       p = VALUE #( (  n = `selectionChange`     v = selectionchange )
                                         (  n = `selectedKeys`        v = selectedkeys )
                                         (  n = `items`               v = items )
                                         (  n = `selectionFinish`     v = selectionfinish )
                                         (  n = `width`               v = width )
                                         (  n = `showClearIcon`       v = showclearicon )
                                         (  n = `showSecondaryValues` v = showsecondaryvalues )
                                         (  n = `showSelectAll`       v = showselectall ) ) ).
  ENDMETHOD.


  METHOD multiinput.
    result = c( n   = `MultiInput`
                       p = VALUE #( ( n = `tokens` v = tokens )
                                         ( n = `showClearIcon` v = z2ui5_cl_fw_utility=>boolean_abap_2_json( showclearicon ) )
                                         ( n = `showValueHelp` v = z2ui5_cl_fw_utility=>boolean_abap_2_json( showvaluehelp ) )
                                         ( n = `enabled` v = z2ui5_cl_fw_utility=>boolean_abap_2_json( enabled ) )
                                         ( n = `suggestionItems` v = suggestionitems )
                                         ( n = `tokenUpdate` v = tokenupdate )
                                         ( n = `submit` v = submit )
                                         ( n = `width` v = width )
                                         ( n = `value` v = value )
                                         ( n = `id` v = id )
                                         ( n = `valueHelpRequest` v = valuehelprequest )
                                         ( n = `class` v = class ) ) ).
  ENDMETHOD.


  METHOD navigationactions.
    result = c( n = `navigationActions`
                       ns   = `f` ).
  ENDMETHOD.


  METHOD navcontainer.
    result = c( n   = `NavContainer`
                       p = VALUE #(
                        (  n = `initialPage`  v = initialpage  )
                        (  n = `id`           v = id  )
                        (  n = `defaultTransitionName`   v = defaulttransitionname  )
                        )  ).

  ENDMETHOD.


  METHOD nodes.
    result = c( n = `nodes`
                       ns   = `commons` ).
  ENDMETHOD.


  METHOD numericcontent.

    result = c( n   = `NumericContent`
                       p = VALUE #( ( n = `value`      v = value )
                                         ( n = `icon`       v = icon )
                                         ( n = `withMargin` v = z2ui5_cl_fw_utility=>boolean_abap_2_json( withmargin ) ) ) ).

  ENDMETHOD.


  METHOD objectattribute.
    result = me.

    c( n   = `ObjectAttribute`
              p = VALUE #( (  n = `title`       v = title )
                                (  n = `text`           v = text ) ) ).
  ENDMETHOD.


  METHOD objectidentifier.
    result = c( n   = `ObjectIdentifier`
                       p = VALUE #( ( n = `emptyIndicatorMode` v = emptyindicatormode )
                                         ( n = `text` v = text )
                                         ( n = `textDirection` v = textdirection )
                                         ( n = `title` v = title )
                                         ( n = `titleActive` v = titleactive )
                                         ( n = `visible` v = visible )
                                         ( n = `titlePress` v = titlepress ) ) ).
  ENDMETHOD.


  METHOD objectnumber.
    result = me.
    c( n   = `ObjectNumber`
              p = VALUE #( ( n = `emphasized`  v = z2ui5_cl_fw_utility=>boolean_abap_2_json( emphasized ) )
                                ( n = `number`      v = number )
                                ( n = `state`       v = state )
                                ( n = `unit`        v = unit ) ) ).
  ENDMETHOD.


  METHOD objectpagedynheadertitle.
    result = c( n = `ObjectPageDynamicHeaderTitle`
                       ns   = `uxap` ).
  ENDMETHOD.


  METHOD objectpagelayout.
    result = c(
                 n   = `ObjectPageLayout`
                 ns     = `uxap`
                 p = VALUE #(
                     ( n = `showTitleInHeaderContent` v = z2ui5_cl_fw_utility=>boolean_abap_2_json( showtitleinheadercontent ) )
                     ( n = `showEditHeaderButton`     v = z2ui5_cl_fw_utility=>boolean_abap_2_json( showeditheaderbutton ) )
                     ( n = `editHeaderButtonPress`    v = editheaderbuttonpress )
                     ( n = `upperCaseAnchorBar`       v = uppercaseanchorbar ) ) ).
  ENDMETHOD.


  METHOD objectpagesection.
    result = c( n   = `ObjectPageSection`
                       ns     = `uxap`
                       p = VALUE #( ( n = `titleUppercase`  v = z2ui5_cl_fw_utility=>boolean_abap_2_json( titleuppercase ) )
                                         ( n = `title`           v = title )
                                         ( n = `id`              v = id )
                                         ( n = `importance`      v = importance ) ) ).
  ENDMETHOD.


  METHOD objectpagesubsection.
    result = c( n   = `ObjectPageSubSection`
                       ns     = `uxap`
                       p = VALUE #( ( n = `id`    v = id )
                                         ( n = `title` v = title ) ) ).
  ENDMETHOD.


  METHOD objectstatus.
    result = c( n   = `ObjectStatus`
                       p = VALUE #( ( n = `active` v = active )
                                         ( n = `emptyIndicatorMode` v = emptyindicatormode )
                                         ( n = `icon` v = icon )
                                         ( n = `iconDensityAware` v = icondensityaware )
                                         ( n = `inverted` v = inverted )
                                         ( n = `state` v = state )
                                         ( n = `stateAnnouncementText` v = stateannouncementtext )
                                         ( n = `text` v = text )
                                         ( n = `textDirection` v = textdirection )
                                         ( n = `title` v = title )
                                         ( n = `press` v = press ) ) ).
  ENDMETHOD.


  METHOD overflowtoolbar.
    result = c( `OverflowToolbar` ).
  ENDMETHOD.


  METHOD overflowtoolbarbutton.
    result = me.
    c( n   = `OverflowToolbarButton`
              p = VALUE #( ( n = `press`   v = press )
                                ( n = `text`    v = text )
                                ( n = `enabled` v = z2ui5_cl_fw_utility=>boolean_abap_2_json( enabled ) )
                                ( n = `icon`    v = icon )
                                ( n = `type`    v = type )
                                ( n = `tooltip` v = tooltip ) ) ).
  ENDMETHOD.


  METHOD overflowtoolbarmenubutton.
    result = c( n   = `OverflowToolbarMenuButton`
                       p = VALUE #( ( n = `buttonMode` v = buttonmode )
                                         ( n = `defaultAction` v = defaultaction )
                                         ( n = `text`    v = text )
                                         ( n = `enabled` v = z2ui5_cl_fw_utility=>boolean_abap_2_json( enabled ) )
                                         ( n = `icon`    v = icon )
                                         ( n = `type`    v = type )
                                         ( n = `tooltip` v = tooltip ) ) ).
  ENDMETHOD.


  METHOD overflowtoolbartogglebutton.
    result = me.
    c( n   = `OverflowToolbarToggleButton`
              p = VALUE #( ( n = `press`   v = press )
                                ( n = `text`    v = text )
                                ( n = `enabled` v = z2ui5_cl_fw_utility=>boolean_abap_2_json( enabled ) )
                                ( n = `icon`    v = icon )
                                ( n = `type`    v = type )
                                ( n = `tooltip` v = tooltip ) ) ).
  ENDMETHOD.


  METHOD page.
    result = c( n   = `Page`
                       ns     = ns
                       p = VALUE #( ( n = `title` v = title )
                                         ( n = `showNavButton`  v = z2ui5_cl_fw_utility=>boolean_abap_2_json( shownavbutton ) )
                                         ( n = `navButtonPress` v = navbuttonpress )
                                         ( n = `showHeader` v = z2ui5_cl_fw_utility=>boolean_abap_2_json( showheader ) )
                                         ( n = `class` v = class )
                                         ( n = `id` v = id ) ) ).
  ENDMETHOD.


  METHOD pages.
    result = c( n   = `pages`  ).

  ENDMETHOD.


  METHOD panel.
    result = c( n   = `Panel`
                       p = VALUE #( ( n = `expandable` v = expandable )
                                         ( n = `expanded`   v = expanded )
                                         ( n = `headerText` v = headertext ) ) ).
  ENDMETHOD.


  METHOD planningcalendar.
    result = c( n   = `PlanningCalendar`
                       p = VALUE #(
                           ( n = `rows`                      v = rows )
                           ( n = `startDate`                 v = startdate )
                           ( n = `appointmentsVisualization` v = appointmentsvisualization )
                           ( n = `appointmentSelect`         v = appointmentselect )
                           ( n = `showEmptyIntervalHeaders`  v = showemptyintervalheaders )
                           ( n = `showWeekNumbers`           v = showweeknumbers )
                           ( n = `legend`                    v = legend )
                           ( n = `showDayNamesLine`          v = showdaynamesline ) ) ).
  ENDMETHOD.


  METHOD planningcalendarlegend.
    result = c( n   = `PlanningCalendarLegend`
                       p = VALUE #(
                           ( n = `id`                              v = id )
                           ( n = `items`                           v = items )
                           ( n = `appointmentItems`                v = appointmentitems )
                           ( n = `standardItems`                   v = standarditems ) ) ).

  ENDMETHOD.


  METHOD planningcalendarrow.
    result = c( n   = `PlanningCalendarRow`
                       p = VALUE #(
                           ( n = `appointments`                    v = appointments )
                           ( n = `intervalHeaders`                 v = intervalheaders )
                           ( n = `icon`                            v = icon )
                           ( n = `title`                           v = title )
                           ( n = `key`                             v = key )
                           ( n = `enableAppointmentsCreate`        v = enableappointmentscreate )
                           ( n = `appointmentResize`               v = appointmentresize )
                           ( n = `appointmentDrop`                 v = appointmentdrop )
                           ( n = `appointmentDragEnter`            v = appointmentdragenter )
                           ( n = `appointmentCreate`               v = appointmentcreate )
                           ( n = `selected`                        v = selected )
                           ( n = `nonWorkingDays`                  v = nonworkingdays )
                           ( n = `enableAppointmentsResize`        v = enableappointmentsresize )
                           ( n = `enableAppointmentsDragAndDrop`   v = enableappointmentsdraganddrop )
                           ( n = `text`                            v = text ) ) ).

  ENDMETHOD.


  METHOD points.
    result = c( n = `points`
                       ns   = `mchart` ).
  ENDMETHOD.


  METHOD popover.
    result = c( n   = `Popover`
                       p = VALUE #( ( n = `title`         v = title )
                                         ( n = `class`         v = class )
                                         ( n = `placement`     v = placement )
                                         ( n = `initialFocus`  v = initialfocus )
                                         ( n = `contentHeight` v = contentheight )
                                         ( n = `contentWidth`  v = contentwidth ) ) ).
  ENDMETHOD.


  METHOD processflow.
    result = c( n   = `ProcessFlow`
                   ns     = 'commons'
                   p = VALUE #( ( n = `id`               v = id )
                                     ( n = `foldedCorners`    v = z2ui5_cl_fw_utility=>boolean_abap_2_json( foldedcorners ) )
                                     ( n = `scrollable`       v = z2ui5_cl_fw_utility=>boolean_abap_2_json( scrollable ) )
                                     ( n = `showLabels`       v = z2ui5_cl_fw_utility=>boolean_abap_2_json( showlabels ) )
                                     ( n = `visible`          v = z2ui5_cl_fw_utility=>boolean_abap_2_json( visible ) )
                                     ( n = `wheelZoomable`    v = z2ui5_cl_fw_utility=>boolean_abap_2_json( wheelzoomable ) )
                                     ( n = `headerPress`      v = headerpress )
                                     ( n = `labelPress`       v = labelpress )
                                     ( n = `nodePress`        v = nodepress )
                                     ( n = `onError`          v = onerror )
                                     ( n = `lanes`            v = lanes )
                                     ( n = `nodes`            v = nodes ) ) ).
  ENDMETHOD.


  METHOD processflowlaneheader.

    result = c( n   = `ProcessFlowLaneHeader`
                   ns     = 'commons'
                   p = VALUE #( ( n = `iconSrc`          v = iconsrc )
                                     ( n = `laneId`           v = laneid )
                                     ( n = `position`         v = position )
                                     ( n = `state`            v = state )
                                     ( n = `text`             v = text )
                                     ( n = `zoomLevel`        v = zoomlevel ) ) ).
  ENDMETHOD.


  METHOD processflownode.
    result = c( n   = `ProcessFlowNode`
                   ns     = 'commons'
                   p = VALUE #( ( n = `laneId`               v = laneid )
                                     ( n = `nodeId`               v = nodeid )
                                     ( n = `title`                v = title )
                                     ( n = `titleAbbreviation`    v = titleabbreviation )
                                     ( n = `children`             v = children )
                                     ( n = `state`                v = state )
                                     ( n = `stateText`            v = statetext )
                                     ( n = `texts`                v = texts )
                                     ( n = `highlighted`          v = z2ui5_cl_fw_utility=>boolean_abap_2_json( highlighted )  )
                                     ( n = `focused`              v = z2ui5_cl_fw_utility=>boolean_abap_2_json( focused ) )
                                     ( n = `selected`             v = z2ui5_cl_fw_utility=>boolean_abap_2_json( selected ) )
                                     ( n = `tag`                  v = tag )
                                     ( n = `texts`                v = texts )
                                     ( n = `type`                 v = type ) ) ).
  ENDMETHOD.


  METHOD progressindicator.
    result = me.
    c( n   = `ProgressIndicator`
              p = VALUE #( ( n = `class`        v = class )
                                ( n = `percentValue` v = percentvalue )
                                ( n = `displayValue` v = displayvalue )
                                ( n = `showValue`    v = z2ui5_cl_fw_utility=>boolean_abap_2_json( showvalue ) )
                                ( n = `state`        v = state ) ) ).
  ENDMETHOD.


  METHOD proportionzoomstrategy.
    result = c( n = `ProportionZoomStrategy`
                       ns   = `axistime` ).
  ENDMETHOD.


  METHOD radialmicrochart.
    result = me.
    c( n   = `RadialMicroChart`
              ns     = `mchart`
              p = VALUE #( ( n = `percentage`  v = percentage )
                                ( n = `press`       v = press )
                                ( n = `sice`        v = sice )
                                ( n = `valueColor`  v = valuecolor ) ) ).
  ENDMETHOD.


  METHOD radiobutton.
    result = c( n = `RadioButton`
                   p   = VALUE #( ( n = `activeHandling`  v = z2ui5_cl_fw_utility=>boolean_abap_2_json( activehandling ) )
                                     ( n = `editable`        v = z2ui5_cl_fw_utility=>boolean_abap_2_json( editable ) )
                                     ( n = `enabled`         v = z2ui5_cl_fw_utility=>boolean_abap_2_json( enabled ) )
                                     ( n = `selected`        v = z2ui5_cl_fw_utility=>boolean_abap_2_json( selected ) )
                                     ( n = `useEntireWidth`  v = z2ui5_cl_fw_utility=>boolean_abap_2_json( useentirewidth ) )
                                     ( n = `text`            v = text )
                                     ( n = `textDirection`   v = textdirection )
                                     ( n = `textAlign`       v = textalign )
                                     ( n = `groupName`       v = groupname )
                                     ( n = `valueState`      v = valuestate )
                                     ( n = `width`           v = width )
           ) ).
  ENDMETHOD.


  METHOD radiobuttongroup.
    result = c( n   = `RadioButtonGroup`
                       p = VALUE #( ( n = `id`             v = id )
                                         ( n = `columns`        v = columns )
                                         ( n = `editable`       v = z2ui5_cl_fw_utility=>boolean_abap_2_json( editable ) )
                                         ( n = `enabled`        v = z2ui5_cl_fw_utility=>boolean_abap_2_json( enabled ) )
                                         ( n = `selectedIndex`  v = selectedindex )
                                         ( n = `textDirection`  v = textdirection )
                                         ( n = `valueState`     v = valuestate )
                                         ( n = `width`          v = width )
                       ) ).
  ENDMETHOD.


  METHOD rangeslider.
    result = me.
    c( n   = `RangeSlider`
              ns     = `webc`
              p = VALUE #( ( n = `class`           v = class )
                                ( n = `endValue`        v = endvalue )
                                ( n = `id`          v = id )
                                ( n = `labelInterval`  v = labelinterval )
                                ( n = `max`   v = max )
                                ( n = `min`   v = min )
                                ( n = `showTickmarks`   v = z2ui5_cl_fw_utility=>boolean_abap_2_json( showtickmarks ) )
                                ( n = `startValue`   v = startvalue )
                                ( n = `step`   v = step )
                                ( n = `width`   v = width ) ) ).
  ENDMETHOD.


  METHOD ratingindicator.

    result = c( n   = `RatingIndicator`
                       p = VALUE #( ( n = `class`        v = class )
                                         ( n = `maxValue`     v = maxvalue )
                                         ( n = `displayOnly`  v = displayonly )
                                         ( n = `editable`     v = editable )
                                         ( n = `iconSize`     v = iconsize )
                                         ( n = `value`        v = value )
                                         ( n = `id`           v = id )
                                         ( n = `change`       v = change )
                                         ( n = `enabled`      v = enabled )
                                         ( n = `tooltip`      v = tooltip ) ) ).

  ENDMETHOD.


  METHOD rows.
    result = c( `rows` ).
  ENDMETHOD.


  METHOD rowsettingstemplate.
    result = c( n = `rowSettingsTemplate`
                       ns   = `table` ).
  ENDMETHOD.


  METHOD scrollcontainer.
    result = c( n   = `ScrollContainer`
                       p = VALUE #( ( n = `height`      v = height )
                                         ( n = `width`       v = width )
                                         ( n = `vertical`    v = z2ui5_cl_fw_utility=>boolean_abap_2_json( vertical ) )
                                         ( n = `horizontal`  v = z2ui5_cl_fw_utility=>boolean_abap_2_json( horizontal ) )
                                         ( n = `focusable`   v = z2ui5_cl_fw_utility=>boolean_abap_2_json( focusable ) ) ) ).
  ENDMETHOD.


  METHOD searchfield.
    result = me.
    c( n   = `SearchField`
              p = VALUE #( ( n = `width`  v = width )
                                ( n = `search` v = search )
                                ( n = `value`  v = value )
                                ( n = `id`     v = id )
                                ( n = `change` v = change )
                                ( n = `autocomplete` v = z2ui5_cl_fw_utility=>boolean_abap_2_json( autocomplete ) )
                                ( n = `liveChange` v = livechange ) ) ).
  ENDMETHOD.


  METHOD sections.
    result = c( n = `sections`
                       ns   = `uxap` ).
  ENDMETHOD.


  METHOD segmentedbutton.
    result = c( n   = `SegmentedButton`
                       p = VALUE #( ( n = `selectedKey` v = selectedkey )
                                         ( n = `selectionChange` v = selectionchange ) ) ).
  ENDMETHOD.


  METHOD segmentedbuttonitem.
    result = me.
    c( n   = `SegmentedButtonItem`
              p = VALUE #( ( n = `icon`  v = icon )
                                ( n = `key`   v = key )
                                ( n = `text`  v = text ) ) ).
  ENDMETHOD.


  METHOD segments.
    result = c( n = `segments`
                       ns   = `mchart` ).
  ENDMETHOD.


  METHOD shapes1.
    result = c( n = `shapes1`
                       ns   = `gantt` ).
  ENDMETHOD.


  METHOD shapes2.
    result = c( n = `shapes2`
                       ns   = `gantt` ).
  ENDMETHOD.


  METHOD shell.
    result = c( n = `Shell`
                       ns   = ns ).
  ENDMETHOD.


  METHOD sidecontent.
    result = c( n   = `sideContent`
                       ns     = 'layout'
                       p = VALUE #(
                           ( n = `width`                           v = width ) ) ).

  ENDMETHOD.


  METHOD simpleform.
    result = c( n   = `SimpleForm`
                       ns     = `form`
                       p = VALUE #( ( n = `title`    v = title )
                                         ( n = `layout`   v = layout )
                                         ( n = `columnsXL`   v = columnsxl )
                                         ( n = `columnsL`   v = columnsl )
                                         ( n = `columnsM`   v = columnsm )
                                         ( n = `editable` v = z2ui5_cl_fw_utility=>boolean_abap_2_json( editable ) ) ) ).
  ENDMETHOD.


  METHOD snappedcontent.
    result = c( n = `snappedContent`
                       ns   = ns ).
  ENDMETHOD.


  METHOD snappedheading.
    result = me.
    result = c( n = `snappedHeading`
                       ns   = `uxap` ).
  ENDMETHOD.


  METHOD snappedtitleonmobile.
    result = c( n = `snappedTitleOnMobile`
                       ns   = `uxap` ).
  ENDMETHOD.


  METHOD standardlistitem.
    result = me.
    c( n   = `StandardListItem`
              p = VALUE #( ( n = `title`       v = title )
                                ( n = `description` v = description )
                                ( n = `icon`        v = icon )
                                ( n = `info`        v = info )
                                ( n = `press`       v = press )
                                ( n = `type`        v = type )
                                ( n = `counter`     v = counter )
                                ( n = `selected`    v = selected ) ) ).
  ENDMETHOD.


  METHOD standardtreeitem.
    result = me.
    c( n   = `StandardTreeItem`
              p = VALUE #( ( n = `title`       v = title )
                                ( n = `icon`        v = icon )
                                ( n = `press`       v = press )
                                ( n = `detailPress` v = detailpress )
                                ( n = `type`        v = type )
                                ( n = `counter`     v = counter )
                                ( n = `selected`    v = selected ) ) ).

  ENDMETHOD.


  METHOD stepinput.
    result = me.
    c( n   = `StepInput`
              p = VALUE #( ( n = `max`  v = max )
                                ( n = `min`  v = min )
                                ( n = `step` v = step )
                                ( n = `value` v = value )
                                ( n = `valueState` v = valuestate )
                                ( n = `enabled` v = z2ui5_cl_fw_utility=>boolean_abap_2_json( enabled ) )
                                ( n = `description` v = description ) ) ).
  ENDMETHOD.


  METHOD stringify.

    result = getroot( )->xmlget( ).

  ENDMETHOD.


  METHOD subheader.
    result = c( n  = `subHeader`
                ns = `tnt` ).
  ENDMETHOD.


  METHOD subsections.
    result = me.
    result = c( n = `subSections`
                       ns   = `uxap` ).
  ENDMETHOD.


  METHOD suggestioncolumns.
    result = c( `suggestionColumns` ).
  ENDMETHOD.


  METHOD suggestionitems.
    result = c( `suggestionItems` ).
  ENDMETHOD.


  METHOD suggestionrows.
    result = c( `suggestionRows` ).
  ENDMETHOD.


  METHOD switch.
    result = me.
    c( n   = `Switch`
              p = VALUE #( ( n = `type`           v = type )
                                ( n = `enabled`        v = z2ui5_cl_fw_utility=>boolean_abap_2_json( enabled ) )
                                ( n = `state`          v = state )
                                ( n = `change`         v = change )
                                ( n = `customTextOff`  v = customtextoff )
                                ( n = `customTextOn`   v = customtexton ) ) ).
  ENDMETHOD.


  METHOD tab.
    result = c( n   = `Tab`
                       ns     = `webc`
                       p = VALUE #( ( n = `text`     v = text )
                                         ( n = `selected` v = selected ) ) ).
  ENDMETHOD.


  METHOD table.
    result = c( n   = `Table`
                       p = VALUE #(
                           ( n = `items`            v = items )
                           ( n = `headerText`       v = headertext )
                           ( n = `growing`          v = growing )
                           ( n = `growingThreshold` v = growingthreshold )
                           ( n = `growingScrollToLoad` v = growingscrolltoload )
                           ( n = `sticky`           v = sticky )
                           ( n = `showSeparators`           v = showseparators )
                           ( n = `mode`             v = mode )
                           ( n = `inset`             v = inset )
                           ( n = `width`            v = width )
                           ( n = `id`            v = id )
                           ( n = `selectionChange`  v = selectionchange )
                           ( n = `alternateRowColors`  v = z2ui5_cl_fw_utility=>boolean_abap_2_json( alternaterowcolors ) )
                           ( n = `autoPopinMode`  v = z2ui5_cl_fw_utility=>boolean_abap_2_json( autopopinmode ) ) ) ).
  ENDMETHOD.


  METHOD tableselectdialog.

    result = c( n   = `TableSelectDialog`
               p = VALUE #( ( n = `confirmButtonText`    v = confirmbuttontext )
                                 ( n = `contentHeight`        v = contentheight )
                                 ( n = `contentWidth`         v = contentwidth )
                                 ( n = `draggable`            v = z2ui5_cl_fw_utility=>boolean_abap_2_json( draggable ) )
                                 ( n = `growing`              v = z2ui5_cl_fw_utility=>boolean_abap_2_json( growing ) )
                                 ( n = `growingThreshold`     v = growingthreshold )
                                 ( n = `multiSelect`          v = z2ui5_cl_fw_utility=>boolean_abap_2_json( multiselect ) )
                                 ( n = `noDataText`           v = nodatatext )
                                 ( n = `rememberSelections`   v = z2ui5_cl_fw_utility=>boolean_abap_2_json( rememberselections ) )
                                 ( n = `resizable`            v = z2ui5_cl_fw_utility=>boolean_abap_2_json( resizable ) )
                                 ( n = `searchPlaceholder`    v = searchplaceholder )
                                 ( n = `showClearButton`      v = z2ui5_cl_fw_utility=>boolean_abap_2_json( showclearbutton ) )
                                 ( n = `title`                v = title )
                                 ( n = `titleAlignment`       v = titlealignment )
                                 ( n = `items`                v = items )
                                 ( n = `search`               v = search )
                                 ( n = `confirm`              v = confirm )
                                 ( n = `cancel`               v = cancel )
                                 ( n = `liveChange`           v = livechange )
                                 ( n = `selectionChange`      v = selectionchange )
                                 ( n = `visible`              v = z2ui5_cl_fw_utility=>boolean_abap_2_json( visible ) ) ) ).
  ENDMETHOD.


  METHOD tabcontainer.
    result = c( n = `TabContainer`
                       ns   = `webc` ).
  ENDMETHOD.


  METHOD task.
    result = c( n   = `Task`
                       ns     = `shapes`
                       p = VALUE #( ( n = `time` v = time )
                                         ( n = `endTime` v = endtime )
                                         ( n = `type` v = type )
                                         ( n = `title` v = title )
                                         ( n = `showTitle` v = z2ui5_cl_fw_utility=>boolean_abap_2_json( showtitle ) )
                                         ( n = `color` v = color ) ) ).
  ENDMETHOD.


  METHOD text.
    result = me.
    c( n   = `Text`
              ns     = ns
              p = VALUE #( ( n = `text`  v = text )
                                ( n = `class` v = class ) ) ).
  ENDMETHOD.


  METHOD textarea.
    result = me.
    c( n   = `TextArea`
              p = VALUE #( ( n = `value` v = value )
                                ( n = `rows` v = rows )
                                ( n = `valueLiveUpdate` v = z2ui5_cl_fw_utility=>boolean_abap_2_json( valueliveupdate ) )
                                ( n = `height` v = height )
                                ( n = `width` v = width )
                                ( n = `editable` v = z2ui5_cl_fw_utility=>boolean_abap_2_json( editable ) )
                                ( n = `enabled` v = z2ui5_cl_fw_utility=>boolean_abap_2_json( enabled ) )
                                ( n = `id` v = id )
                                ( n = `growing` v = z2ui5_cl_fw_utility=>boolean_abap_2_json( growing ) )
                                ( n = `growingMaxLines` v = growingmaxlines ) ) ).
  ENDMETHOD.


  METHOD tilecontent.

    result = c( n   = `TileContent`
                       ns     = ``
                       p = VALUE #(
                                ( n = `unit`   v = unit )
                                ( n = `footer` v = footer ) ) ).

  ENDMETHOD.


  METHOD timehorizon.
    result = c( n   = `TimeHorizon`
                       ns     = `config`
                       p = VALUE #( ( n = `startTime` v = starttime )
                                         ( n = `endTime`   v = endtime )
                                       ) ).
  ENDMETHOD.


  METHOD timepicker.
    result = me.
    c( n   = `TimePicker`
              p = VALUE #( ( n = `value` v = value )
                                ( n = `placeholder`  v = placeholder )
                                ( n = `enabled` v = z2ui5_cl_fw_utility=>boolean_abap_2_json( enabled ) )
                                ( n = `valueState` v = valuestate )
                                ( n = `displayFormat` v = displayformat )
                                ( n = `valueFormat` v = valueformat ) ) ).
  ENDMETHOD.


  METHOD title.
    DATA(lvname) = COND #( WHEN ns = 'f' THEN 'title' ELSE `Title` ).

    result = me.
        c( ns     = ns
              n   = lvname
              p = VALUE #( ( n = `text`     v = text )
                                ( n = `wrapping` v = z2ui5_cl_fw_utility=>boolean_abap_2_json( wrapping ) )
                                ( n = `level` v = level ) ) ).
  ENDMETHOD.


  METHOD togglebutton.

    result = me.
    c( n   = `ToggleButton`
              p = VALUE #( ( n = `press`   v = press )
                                ( n = `text`    v = text )
                                ( n = `enabled` v = z2ui5_cl_fw_utility=>boolean_abap_2_json( enabled ) )
                                ( n = `icon`    v = icon )
                                ( n = `type`    v = type )
                                ( n = `class`   v = class ) ) ).
  ENDMETHOD.


  METHOD token.

    result = me.
    c( n   = `Token`
              p = VALUE #( ( n = `key`      v = key )
                                ( n = `text`     v = text )
                                ( n = `selected` v = selected )
                                ( n = `visible`  v = visible )
                                ( n = `editable`  v = editable ) ) ).
  ENDMETHOD.


  METHOD tokens.

    result = c( `tokens` ).

  ENDMETHOD.


  METHOD toolbar.

    result = c( `Toolbar` ).

  ENDMETHOD.


  METHOD toolbarspacer.

    result = me.
    c( n = `ToolbarSpacer`
              ns   = ns ).

  ENDMETHOD.


  METHOD toolheader.
    result = c( n = `ToolHeader`
                       ns   = `tnt` ).
  ENDMETHOD.


  METHOD toolpage.
    result = c( n = `ToolPage`
                       ns   = `tnt` ).
  ENDMETHOD.


  METHOD totalhorizon.
    result = c( n = `totalHorizon`
                       ns   = `axistime` ).
  ENDMETHOD.


  METHOD tree.
    result = c( n   = `Tree`
                       p = VALUE #(
                           ( n = `items`            v = items )
                           ( n = `headerText`       v = headertext )
                           ( n = `footerText`       v = footertext )
                           ( n = `mode`             v = mode )
                           ( n = `width`            v = width )
                           ( n = `includeItemInSelection`  v = z2ui5_cl_fw_utility=>boolean_abap_2_json( includeiteminselection ) )
                           ( n = `inset`  v = z2ui5_cl_fw_utility=>boolean_abap_2_json( inset ) )
             ) ).
  ENDMETHOD.


  METHOD treecolumn.

    result = c( n = `Column`
                  ns        = `table`
                  p    = VALUE #(
                          ( n = `label`      v = label )
                          ( n = `template`   v = template )
                          ( n = `hAlign`     v = halign ) ) ).

  ENDMETHOD.


  METHOD treecolumns.

    result = c( n = `columns`
                       ns   = `table` ).

  ENDMETHOD.


  METHOD treetable.

    result = c( n  = `TreeTable`
                      ns     = `table`
                      p = VALUE #(
                                        ( n = `rows`                    v = rows )
                                        ( n = `selectionMode`           v = selectionmode )
                                        ( n = `enableColumnReordering`  v = enablecolumnreordering )
                                        ( n = `expandFirstLevel`        v = expandfirstlevel )
                                        ( n = `columnSelect`            v = columnselect )
                                        ( n = `rowSelectionChange`      v = rowselectionchange )
                                        ( n = `selectionBehavior`       v = selectionbehavior )
                                        ( n = `selectedIndex`           v = selectedindex ) ) ).
  ENDMETHOD.


  METHOD treetemplate.

    result = c( n = `template`
                       ns   = `table` ).

  ENDMETHOD.


  METHOD uicolumn.
    result = c( n   = `Column`
                       ns     = 'table'
                       p = VALUE #(
                          ( n = `width` v = width )
                          ( n = `showSortMenuEntry`    v = showsortmenuentry )
                          ( n = `sortProperty`         v = sortproperty )
                          ( n = `showFilterMenuEntry`  v = showfiltermenuentry )
                          ( n = `filterProperty`       v = filterproperty ) ) ).
  ENDMETHOD.


  METHOD uicolumns.
    result = c( n = `columns`
                       ns   = 'table' ).
  ENDMETHOD.


  METHOD uiextension.

    result = c( n = `extension`
                       ns   = 'table' ).
  ENDMETHOD.


  METHOD uirowaction.
    result = c( n = `RowAction`
                       ns   = `table` ).
  ENDMETHOD.


  METHOD uirowactionitem.
    result = c( n   = `RowActionItem`
                       ns     = `table`
                       p = VALUE #(
                          ( n = `icon`     v = icon )
                          ( n = `text`     v = text )
                          ( n = `type`     v = type )
                          ( n = `press`    v = press ) ) ).
  ENDMETHOD.


  METHOD uirowactiontemplate.
    result = c( n = `rowActionTemplate`
                       ns   = `table` ).
  ENDMETHOD.


  METHOD uitable.

    result = c( n   = `Table`
                       ns     = `table`
                       p = VALUE #(
                           ( n = `rows`                      v = rows )
                           ( n = `alternateRowColors`        v = z2ui5_cl_fw_utility=>boolean_abap_2_json( alternaterowcolors ) )
                           ( n = `columnHeaderVisible`       v = columnheadervisible )
                           ( n = `editable`                  v = z2ui5_cl_fw_utility=>boolean_abap_2_json( editable ) )
                           ( n = `enableCellFilter`          v = z2ui5_cl_fw_utility=>boolean_abap_2_json( enablecellfilter ) )
                           ( n = `enableGrouping`            v = z2ui5_cl_fw_utility=>boolean_abap_2_json( enablegrouping ) )
                           ( n = `senableSelectAll`          v = z2ui5_cl_fw_utility=>boolean_abap_2_json( enableselectall ) )
                           ( n = `firstVisibleRow`           v = firstvisiblerow )
                           ( n = `fixedBottomRowCount`       v = fixedbottomrowcount )
                           ( n = `fixedColumnCount`          v = fixedcolumncount )
                           ( n = `rowActionCount`            v = rowactioncount )
                           ( n = `fixedRowCount`             v = fixedrowcount )
                           ( n = `minAutoRowCount`           v = minautorowcount )
                           ( n = `minAutoRowCount`           v = minautorowcount )
                           ( n = `rowHeight`                 v = rowheight )
                           ( n = `selectedIndex`             v = selectedindex )
                           ( n = `selectionMode`             v = selectionmode )
                           ( n = `showColumnVisibilityMenu`  v = z2ui5_cl_fw_utility=>boolean_abap_2_json( showcolumnvisibilitymenu ) )
                           ( n = `showNoData`                v = z2ui5_cl_fw_utility=>boolean_abap_2_json( shownodata ) )
                           ( n = `threshold`                 v = threshold )
                           ( n = `visibleRowCount`           v = visiblerowcount )
                           ( n = `visibleRowCountMode`       v = visiblerowcountmode )
                           ( n = `footer`                    v = footer )
                           ( n = `filter`                    v = filter )
                           ( n = `sort`                      v = sort )
                           ( n = `customFilter`              v = customfilter )
                           ( n = `id`              v = id )
                           ( n = `rowSelectionChange`        v = rowselectionchange )
                            ) ).

  ENDMETHOD.


  METHOD uitemplate.

    result = c( n = `template`
                       ns   = 'table' ).

  ENDMETHOD.


  METHOD vbox.

    result = c( n   = `VBox`
                       p = VALUE #( ( n = `height`          v = height )
                                         ( n = `justifyContent`  v = justifycontent )
                                         ( n = `renderType`      v = rendertype )
                                         ( n = `alignContent`    v = aligncontent )
                                         ( n = `alignItems`      v = alignitems )
                                         ( n = `width`           v = width )
                                         ( n = `wrap`            v = wrap )
                                         ( n = `class`           v = class ) ) ).

  ENDMETHOD.


  METHOD verticallayout.

    result = c( n   = `VerticalLayout`
                       ns     = `layout`
                       p = VALUE #( ( n = `class`  v = class )
                                         ( n = `width`  v = width ) ) ).
  ENDMETHOD.


  METHOD visiblehorizon.
    result = c( n = `visibleHorizon`
                       ns   = `axistime` ).
  ENDMETHOD.


  METHOD xmlget.

    CASE mvname.
      WHEN `ZZPLAIN`.
        result = mtprop[ n = `VALUE` ]-v.
        RETURN.
    ENDCASE.

    DATA(lvtmp2) = COND #( WHEN mvns <> `` THEN |{ mvns }:| ).
    DATA(lvtmp3) = REDUCE #( INIT val = `` FOR row IN mtprop WHERE ( v <> `` )
                          NEXT val = |{ val } { row-n }="{ escape(
                                                               val    = COND string( WHEN row-v = abap_true
                                                                                     THEN `true`
                                                                                     ELSE row-v )
                                                               format = cl_abap_format=>e_xml_attr ) }" \n | ).

    result = |{ result } <{ lvtmp2 }{ mvname } \n { lvtmp3 }|.

    IF mtchild IS INITIAL.
      result = |{ result }/>|.
      RETURN.
    ENDIF.

    result = |{ result }>|.

    LOOP AT mtchild INTO DATA(lrchild).
      result = result && CAST z2ui5_cl_view( lrchild )->xmlget( ).
    ENDLOOP.

    DATA(lvns) = COND #( WHEN mvns <> || THEN |{ mvns }:| ).
    result = |{ result }</{ lvns }{ mvname }>|.

  ENDMETHOD.


  METHOD zzplain.
    result = me.
    c( n   = `ZZPLAIN`
              p = VALUE #( ( n = `VALUE` v = val ) ) ).
  ENDMETHOD.


  METHOD c.

    DATA(result2) = NEW z2ui5_cl_view( ).
    result2->mvname   = n.
    result2->mvns     = ns.
    result2->mtprop  = p.
    result2->moparent = me.
    result2->moroot   = moroot.
    INSERT result2 INTO TABLE mtchild.

    moroot->moprevious = result2.
    result = result2.

  ENDMETHOD.

  METHOD pb.

    INSERT value #( n = n v = z2ui5_cl_fw_utility=>boolean_abap_2_json( v ) ) INTO TABLE mtprop.
    result = me.

  ENDMETHOD.

  METHOD p.

    INSERT value #( n = n v = v ) INTO TABLE mtprop.
    result = me.

  ENDMETHOD.
ENDCLASS.
