module Examples.Checkbox exposing (Msg, State, example)

{-|

@docs Msg, State, example

-}

import Category exposing (Category(..))
import CheckboxIcons
import Css exposing (Style)
import Debug.Control as Control exposing (Control)
import Debug.Control.View as ControlView
import Example exposing (Example)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css)
import KeyboardSupport exposing (Key(..))
import Nri.Ui.Checkbox.V6 as Checkbox
import Nri.Ui.Colors.V1 as Colors
import Nri.Ui.Fonts.V1 as Fonts
import Nri.Ui.Heading.V3 as Heading
import Nri.Ui.Svg.V1 as Svg


moduleName : String
moduleName =
    "Checkbox"


version : Int
version =
    6


{-| -}
example : Example State Msg
example =
    { name = moduleName
    , version = version
    , state = init
    , update = update
    , subscriptions = \_ -> Sub.none
    , preview = preview
    , view =
        \ellieLinkConfig state ->
            let
                settings =
                    Control.currentValue state.settings
            in
            [ ControlView.view
                { ellieLinkConfig = ellieLinkConfig
                , name = moduleName
                , version = version
                , update = UpdateControls
                , settings = state.settings
                , mainType = Nothing
                , extraCode = []
                , toExampleCode = \_ -> [ { sectionName = "TODO", code = "TODO" } ]
                }
            , Heading.h2 [ Heading.plaintext "Example" ]
            , viewExample state settings
            ]
    , categories = [ Inputs ]
    , keyboardSupport =
        [ { keys = [ Space ]
          , result = "Select or deselect the checkbox (may cause page scroll)"
          }
        ]
    }


preview : List (Html Never)
preview =
    let
        renderPreview ( icon, label_ ) =
            span
                [ css
                    [ Css.color Colors.navy
                    , Css.fontSize (Css.px 15)
                    , Fonts.baseFont
                    , Css.fontWeight (Css.int 600)
                    , Css.displayFlex
                    , Css.alignItems Css.center
                    , Css.minHeight (Css.px 30)
                    ]
                ]
                [ Svg.toHtml (Svg.withCss [ Css.marginRight (Css.px 8) ] icon)
                , text label_
                ]
    in
    [ ( CheckboxIcons.unchecked "unchecked-preview-unchecked", "Unchecked" )
    , ( CheckboxIcons.checkedPartially "checkedPartially-preview-checkedPartially", "Part checked" )
    , ( CheckboxIcons.checked "checkbox-preview-checked", "Checked" )
    ]
        |> List.map renderPreview


{-| -}
type alias State =
    { isChecked : Checkbox.IsSelected
    , settings : Control Settings
    }


{-| -}
init : State
init =
    { isChecked = Checkbox.PartiallySelected
    , settings = controlSettings
    }


controlSettings : Control Settings
controlSettings =
    Control.record Settings
        |> Control.field "label" (Control.string "Enable Text to Speech")
        |> Control.field "disabled" (Control.bool False)
        |> Control.field "theme"
            (Control.choice
                [ ( "Square", Control.value Checkbox.Square )
                , ( "Locked", Control.value Checkbox.Locked )
                ]
            )
        |> Control.field "containerCss"
            (Control.choice
                [ ( "[]", Control.value [] )
                , ( "Red dashed border", Control.value [ Css.border3 (Css.px 4) Css.dashed Colors.red ] )
                ]
            )
        |> Control.field "enabledLabelCss"
            (Control.choice
                [ ( "[]", Control.value [] )
                , ( "Orange dotted border", Control.value [ Css.border3 (Css.px 4) Css.dotted Colors.orange ] )
                ]
            )
        |> Control.field "disabledLabelCss"
            (Control.choice
                [ ( "[]", Control.value [] )
                , ( "strikethrough", Control.value [ Css.textDecoration Css.lineThrough ] )
                ]
            )


type alias Settings =
    { label : String
    , disabled : Bool
    , theme : Checkbox.Theme
    , containerCss : List Style
    , enabledLabelCss : List Style
    , disabledLabelCss : List Style
    }


viewExample : State -> Settings -> Html Msg
viewExample state settings =
    let
        id =
            "unique-example-id"
    in
    Checkbox.viewWithLabel
        { identifier = id
        , label = settings.label
        , setterMsg = ToggleCheck id
        , selected = state.isChecked
        , disabled = settings.disabled
        , theme = settings.theme
        , containerCss = settings.containerCss
        , enabledLabelCss = settings.enabledLabelCss
        , disabledLabelCss = settings.disabledLabelCss
        }


{-| -}
type Msg
    = ToggleCheck Id Bool
    | UpdateControls (Control Settings)


{-| -}
update : Msg -> State -> ( State, Cmd Msg )
update msg state =
    case msg of
        ToggleCheck id checked ->
            let
                isChecked =
                    if checked then
                        Checkbox.Selected

                    else
                        Checkbox.NotSelected
            in
            ( { state | isChecked = isChecked }, Cmd.none )

        UpdateControls settings ->
            ( { state | settings = settings }, Cmd.none )


type alias Id =
    String
