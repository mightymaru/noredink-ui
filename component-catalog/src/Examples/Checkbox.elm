module Examples.Checkbox exposing (Msg, State, example)

{-|

@docs Msg, State, example

-}

import Category exposing (Category(..))
import CheckboxIcons
import Code
import CommonControls
import Css
import Debug.Control as Control exposing (Control)
import Debug.Control.Extra as ControlExtra
import Debug.Control.View as ControlView
import Example exposing (Example)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css)
import KeyboardSupport exposing (Key(..))
import Nri.Ui.Checkbox.V7 as Checkbox
import Nri.Ui.Colors.V1 as Colors
import Nri.Ui.Fonts.V1 as Fonts
import Nri.Ui.Heading.V3 as Heading
import Nri.Ui.Svg.V1 as Svg
import Nri.Ui.Table.V7 as Table


moduleName : String
moduleName =
    "Checkbox"


version : Int
version =
    7


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

                ( exampleCode, exampleView ) =
                    viewExampleWithCode state settings
            in
            [ ControlView.view
                { ellieLinkConfig = ellieLinkConfig
                , name = moduleName
                , version = version
                , update = UpdateControls
                , settings = state.settings
                , mainType = Just "RootHtml.Html Bool"
                , extraCode = []
                , renderExample = Code.unstyledView
                , toExampleCode = \_ -> [ { sectionName = "Example", code = exampleCode } ]
                }
            , Heading.h2 [ Heading.plaintext "Customizable example" ]
            , exampleView
            , Heading.h2 [ Heading.plaintext "Examples" ]
            , Table.view []
                [ Table.string
                    { header = "State"
                    , value = .state
                    , width = Css.pct 30
                    , cellStyles = always [ Css.padding2 (Css.px 14) (Css.px 7), Css.verticalAlign Css.middle, Css.fontWeight Css.bold ]
                    , sort = Nothing
                    }
                , Table.custom
                    { header = text "Enabled"
                    , view = .enabled
                    , width = Css.px 150
                    , cellStyles = always [ Css.padding2 (Css.px 14) (Css.px 7), Css.verticalAlign Css.middle ]
                    , sort = Nothing
                    }
                , Table.custom
                    { header = text "Disabled"
                    , view = .disabled
                    , width = Css.px 150
                    , cellStyles = always [ Css.padding2 (Css.px 14) (Css.px 7), Css.verticalAlign Css.middle ]
                    , sort = Nothing
                    }
                ]
                (List.indexedMap row
                    [ ( "NotSelected", Checkbox.NotSelected )
                    , ( "PartiallySelected", Checkbox.PartiallySelected )
                    , ( "Selected", Checkbox.Selected )
                    ]
                )
            ]
    , categories = [ Inputs ]
    , keyboardSupport =
        [ { keys = [ Space ]
          , result = "Select or deselect the checkbox (may cause page scroll)"
          }
        ]
    }


row :
    Int
    -> ( String, Checkbox.IsSelected )
    -> { state : String, enabled : Html Msg, disabled : Html Msg }
row i ( name, selectionStatus ) =
    { state = name
    , enabled =
        Checkbox.view
            { label = "Setting"
            , selected = selectionStatus
            }
            [ Checkbox.id <| "enabled-" ++ String.fromInt i
            , Checkbox.onCheck <| \_ -> Swallow
            , Checkbox.enabled
            , Checkbox.visibleLabel
            ]
    , disabled =
        Checkbox.view
            { label = "Setting"
            , selected = selectionStatus
            }
            [ Checkbox.id <| "disabled-" ++ String.fromInt i
            , Checkbox.onCheck <| \_ -> Swallow
            , Checkbox.disabled
            , Checkbox.visibleLabel
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
    [ ( CheckboxIcons.checkedPartially "checkedPartially-preview-checkedPartially", "Part checked" )
    , ( CheckboxIcons.unchecked "unchecked-preview-unchecked", "Unchecked" )
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


type alias Settings =
    { label : String
    , attributes : List ( String, Checkbox.Attribute Msg )
    }


controlSettings : Control Settings
controlSettings =
    Control.record Settings
        |> Control.field "label" (Control.string "Enable Text-to-Speech")
        |> Control.field "attributes" initAttributes


initAttributes : Control (List ( String, Checkbox.Attribute Msg ))
initAttributes =
    ControlExtra.list
        |> CommonControls.guidanceAndErrorMessage
            { moduleName = moduleName
            , guidance = Checkbox.guidance
            , guidanceHtml = Checkbox.guidanceHtml
            , errorMessage = Nothing
            , message = "There is something you need to be aware of."
            }
        |> ControlExtra.optionalBoolListItem "disabled" ( "disabled", Checkbox.disabled )
        |> ControlExtra.optionalBoolListItem "hiddenLabel" ( "hiddenLabel", Checkbox.hiddenLabel )
        |> ControlExtra.optionalListItem "containerCss"
            (Control.choice
                [ ( "Red dashed border"
                  , Control.value
                        ( "Checkbox.containerCss [ Css.border3 (Css.px 4) Css.dashed Colors.red ]"
                        , Checkbox.containerCss [ Css.border3 (Css.px 4) Css.dashed Colors.red ]
                        )
                  )
                ]
            )
        |> ControlExtra.optionalListItem "labelCss"
            (Control.choice
                [ ( "Orange dotted border"
                  , Control.value
                        ( "Checkbox.labelCss [ Css.border3 (Css.px 4) Css.dotted Colors.orange ]"
                        , Checkbox.labelCss [ Css.border3 (Css.px 4) Css.dotted Colors.orange ]
                        )
                  )
                ]
            )


viewExampleWithCode : State -> Settings -> ( String, Html Msg )
viewExampleWithCode state settings =
    let
        id =
            "unique-example-id"
    in
    ( [ Code.fromModule moduleName "view"
      , Code.recordMultiline
            [ ( "label", Code.string settings.label )
            , ( "selected", Code.fromModule "Checkbox" (Debug.toString state.isChecked) )
            ]
            1
      , Code.listMultiline
            ([ Code.fromModule moduleName "id " ++ Code.string id
             , Code.fromModule moduleName "onCheck " ++ "identity"
             ]
                ++ List.map Tuple.first settings.attributes
            )
            1
      ]
        |> String.join ""
    , Checkbox.view
        { label = settings.label
        , selected = state.isChecked
        }
        ([ Checkbox.id id
         , Checkbox.onCheck (ToggleCheck id)
         ]
            ++ List.map Tuple.second settings.attributes
        )
    )


{-| -}
type Msg
    = ToggleCheck Id Bool
    | UpdateControls (Control Settings)
    | Swallow


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

        Swallow ->
            ( state, Cmd.none )


type alias Id =
    String
