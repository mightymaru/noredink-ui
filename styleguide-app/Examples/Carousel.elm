module Examples.Carousel exposing
    ( example
    , State
    , Msg
    )

{-|

@docs example
@docs State, msg

-}

import Browser.Dom as Dom
import Category exposing (Category(..))
import CommonControls
import Css exposing (Style)
import Debug.Control as Control exposing (Control)
import Debug.Control.Extra
import Debug.Control.View as ControlView
import Example exposing (Example)
import Html.Styled as Html exposing (fromUnstyled)
import Html.Styled.Attributes as Attributes
import KeyboardSupport exposing (Key(..))
import Nri.Ui.Carousel.V1 as Carousel exposing (Tab, TabPosition(..))
import Nri.Ui.Colors.V1 as Colors
import Task


type alias State =
    { selected : Int
    , settings : Control Settings
    }


init : State
init =
    { selected = 0
    , settings = initSettings
    }


type alias Settings =
    { tabs : Int
    , tabListPosition : ( String, Carousel.TabPosition )
    , tabListStyles : ( String, List Style )
    , tabStyles : ( String, Int -> Bool -> List Style )
    , containerStyles : ( String, List Style )
    }


initSettings : Control Settings
initSettings =
    Control.record Settings
        |> Control.field "tabs" (Debug.Control.Extra.int 4)
        |> Control.field "tabListPosition"
            (CommonControls.choice moduleName
                [ ( "Before", Before )
                , ( "After", After )
                ]
            )
        |> Control.field "tabListStyles" controlTabListStyles
        |> Control.field "tabStyles" controlTabStyles
        |> Control.field "containerStyles" controlContainerStyles


controlTabListStyles : Control ( String, List Style )
controlTabListStyles =
    ( "[ Css.displayFlex, Css.property \"gap\" \"20px\" ]"
    , [ Css.displayFlex, Css.property "gap" "20px" ]
    )
        |> Control.value
        |> Control.maybe False
        |> Control.map (Maybe.withDefault ( "[]", [] ))


controlTabStyles : Control ( String, Int -> Bool -> List Css.Style )
controlTabStyles =
    let
        simplifiedCodeVersion =
            "\\index isSelected -> [ -- styles that depend on selection status\n    ]"
    in
    (\_ isSelected ->
        let
            ( backgroundColor, textColor ) =
                if isSelected then
                    ( Colors.azure, Colors.white )

                else
                    ( Colors.gray92, Colors.gray20 )
        in
        [ Css.padding2 (Css.px 10) (Css.px 20)
        , Css.backgroundColor backgroundColor
        , Css.borderRadius (Css.px 8)
        , Css.border Css.zero
        , Css.color textColor
        , Css.cursor Css.pointer
        ]
    )
        |> Control.value
        |> Control.maybe False
        |> Control.map (Maybe.withDefault (\_ _ -> []))
        |> Control.map (\v -> ( simplifiedCodeVersion, v ))


controlContainerStyles : Control ( String, List Style )
controlContainerStyles =
    ( "[ Css.margin (Css.px 20) ]", [ Css.margin (Css.px 20) ] )
        |> Control.value
        |> Control.maybe False
        |> Control.map (Maybe.withDefault ( "[]", [] ))


type Msg
    = FocusAndSelectTab { select : Int, focus : Maybe String }
    | Focused (Result Dom.Error ())
    | SetSettings (Control Settings)


update : Msg -> State -> ( State, Cmd Msg )
update msg model =
    case msg of
        FocusAndSelectTab { select, focus } ->
            ( { model | selected = select }
            , focus
                |> Maybe.map (Dom.focus >> Task.attempt Focused)
                |> Maybe.withDefault Cmd.none
            )

        Focused error ->
            ( model, Cmd.none )

        SetSettings settings ->
            ( { model | settings = settings }, Cmd.none )


moduleName : String
moduleName =
    "Carousel"


version : Int
version =
    1


example : Example State Msg
example =
    { name = moduleName
    , version = version
    , categories = [ Layout ]
    , keyboardSupport =
        [ { keys = [ KeyboardSupport.Tab ]
          , result = "Move focus to the currently-selected Tab's tab panel"
          }
        , { keys = [ Arrow KeyboardSupport.Left ]
          , result = "Select the tab to the left of the currently-selected Tab"
          }
        , { keys = [ Arrow KeyboardSupport.Right ]
          , result = "Select the tab to the right of the currently-selected Tab"
          }
        ]
    , state = init
    , update = update
    , subscriptions = \_ -> Sub.none
    , preview =
        []
    , view =
        \ellieLinkConfig model ->
            let
                settings =
                    Control.currentValue model.settings

                allTabs =
                    List.repeat settings.tabs ()
                        |> List.indexedMap toTab
            in
            [ ControlView.view
                { ellieLinkConfig = ellieLinkConfig
                , name = moduleName
                , version = version
                , update = SetSettings
                , settings = model.settings
                , mainType = "RootHtml.Html { select : Int, focus : Maybe String }"
                , extraImports = []
                , toExampleCode =
                    \_ ->
                        let
                            code =
                                [ moduleName ++ ".view"
                                , "    { focusAndSelect = identity"
                                , "    , selected = " ++ String.fromInt model.selected
                                , "    , tabListStyles = " ++ Tuple.first settings.tabListStyles
                                , "    , tabStyles = " ++ Tuple.first settings.tabStyles
                                , "    , containerStyles = " ++ Tuple.first settings.containerStyles
                                , "    , tabListPosition = " ++ Tuple.first settings.tabListPosition
                                , "    , tabs =" ++ ControlView.codeFromListSimpleWithIndentLevel 2 (List.map Tuple.first allTabs)
                                , "    }"
                                ]
                                    |> String.join "\n"
                        in
                        [ { sectionName = "Example"
                          , code = code
                          }
                        ]
                }
            , Carousel.view
                { focusAndSelect = FocusAndSelectTab
                , selected = model.selected
                , tabListStyles = Tuple.second settings.tabListStyles
                , tabStyles = Tuple.second settings.tabStyles
                , containerStyles = Tuple.second settings.containerStyles
                , tabListPosition = Tuple.second settings.tabListPosition
                , tabs = List.map Tuple.second allTabs
                }
            ]
    }


toTab : Int -> a -> ( String, Tab Int msg )
toTab id _ =
    let
        idString =
            String.fromInt id
    in
    ( [ "Carousel.buildTab { id = " ++ idString ++ ", idString = \"" ++ idString ++ "-slide\" }"
      , "      [ Carousel.tabHtml (Html.text \"" ++ idString ++ "\")"
      , "      , Carousel.slideHtml (Html.text \"" ++ idString ++ " slide\")"
      , "      ]"
      ]
        |> String.join "\n    "
    , Carousel.buildTab { id = id, idString = String.fromInt id ++ "-slide" }
        [ Carousel.tabHtml (Html.text (String.fromInt (id + 1)))
        , Carousel.slideHtml (Html.text (String.fromInt (id + 1) ++ " slide"))
        ]
    )
