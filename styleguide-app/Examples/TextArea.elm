module Examples.TextArea exposing (Msg, State, example)

{-|

@docs Msg, State, example

-}

import Category exposing (Category(..))
import Code
import CommonControls
import Css
import Debug.Control as Control exposing (Control)
import Debug.Control.Extra as ControlExtra
import Debug.Control.View as ControlView
import Example exposing (Example)
import Html.Styled as Html
import Html.Styled.Attributes as Attributes exposing (css)
import Nri.Ui.Colors.V1 as Colors
import Nri.Ui.Heading.V3 as Heading
import Nri.Ui.InputStyles.V4 as InputStyles exposing (Theme(..))
import Nri.Ui.TextArea.V5 as TextArea


moduleName : String
moduleName =
    "TextArea"


version : Int
version =
    5


{-| -}
example : Example State Msg
example =
    { name = moduleName
    , version = version
    , state = init
    , update = update
    , subscriptions = \_ -> Sub.none
    , categories = [ Inputs ]
    , keyboardSupport = []
    , preview =
        [ Html.div [ css [ Css.position Css.relative ] ]
            [ Html.textarea
                [ css
                    [ InputStyles.input Standard
                    , Css.minHeight (Css.px 100)
                    , Css.maxWidth (Css.px 140)
                    , Css.backgroundColor Colors.white |> Css.important
                    , Css.cursor Css.pointer |> Css.important
                    , Css.resize Css.none
                    ]
                , Attributes.class "override-sass-styles"
                , Attributes.disabled True
                , Attributes.id "preview-textarea"
                ]
                []
            , Html.label
                [ css [ InputStyles.label Standard False ]
                , Attributes.for "preview-textarea"
                ]
                [ Html.text "Label" ]
            ]
        ]
    , view =
        \ellieLinkConfig state ->
            let
                { label, attributes } =
                    Control.currentValue state.settings

                toExampleCode name =
                    [ moduleName ++ "." ++ name ++ " " ++ Code.string label
                    , Code.list <|
                        ("TextArea.value " ++ Code.string state.value)
                            :: "TextArea.onInput identity"
                            :: List.map Tuple.first attributes
                    ]
                        |> String.join ""
            in
            [ ControlView.view
                { ellieLinkConfig = ellieLinkConfig
                , name = moduleName
                , version = version
                , update = UpdateControl
                , settings = state.settings
                , mainType = Just "RootHtml.Html String"
                , extraCode = []
                , renderExample = Code.unstyledView
                , toExampleCode =
                    \_ ->
                        [ { sectionName = "view"
                          , code = toExampleCode "view"
                          }
                        ]
                }
            , Heading.h2 [ Heading.plaintext "Example" ]
            , TextArea.view label
                (TextArea.value state.value
                    :: TextArea.onInput UpdateValue
                    :: List.map Tuple.second attributes
                )
            ]
    }


{-| -}
type alias State =
    { value : String
    , settings : Control Settings
    }


{-| -}
init : State
init =
    { value = ""
    , settings = initControls
    }


type alias Settings =
    { label : String
    , attributes : List ( String, TextArea.Attribute Msg )
    }


controlAttributes : Control (List ( String, TextArea.Attribute Msg ))
controlAttributes =
    ControlExtra.list
        |> ControlExtra.optionalListItem
            "theme"
            (CommonControls.choice moduleName
                [ ( "standard", TextArea.standard )
                , ( "writing", TextArea.writing )
                ]
            )
        |> ControlExtra.optionalBoolListItem "onBlur"
            ( "TextArea.onBlur " ++ Code.string "Neener neener Blur happened"
            , TextArea.onBlur (UpdateValue "Neener neener Blur happened")
            )
        |> ControlExtra.optionalListItem "placeholder"
            (Control.string "A long time ago, in a galaxy pretty near here actually..."
                |> Control.map
                    (\str ->
                        ( "TextArea.placeholder " ++ Code.string str
                        , TextArea.placeholder str
                        )
                    )
            )
        |> ControlExtra.optionalListItem "height"
            (CommonControls.choice moduleName
                [ ( "autoResize", TextArea.autoResize )
                , ( "autoResizeSingleLine", TextArea.autoResizeSingleLine )
                ]
            )
        |> CommonControls.guidanceAndErrorMessage
            { moduleName = moduleName
            , guidance = TextArea.guidance
            , errorMessage = TextArea.errorMessage
            , message = "The statement must be true."
            }
        |> ControlExtra.optionalBoolListItem "disabled"
            ( "TextArea.disabled", TextArea.disabled )
        |> ControlExtra.optionalBoolListItem "noMargin"
            ( "TextArea.noMargin True", TextArea.noMargin True )
        |> ControlExtra.optionalBoolListItem "css"
            ( "TextArea.css [ Css.backgroundColor Colors.azure ]"
            , TextArea.css [ Css.backgroundColor Colors.azure ]
            )


initControls : Control Settings
initControls =
    Control.record Settings
        |> Control.field "label" (Control.string "Introductory paragraph")
        |> Control.field "attributes" controlAttributes


{-| -}
type Msg
    = UpdateValue String
    | UpdateControl (Control Settings)


{-| -}
update : Msg -> State -> ( State, Cmd Msg )
update msg state =
    case msg of
        UpdateValue newValue ->
            ( { state | value = newValue }
            , Cmd.none
            )

        UpdateControl settings ->
            ( { state | settings = settings }, Cmd.none )
