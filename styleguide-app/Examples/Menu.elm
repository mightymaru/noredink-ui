module Examples.Menu exposing (Msg, State, example)

{-|

@docs Msg, State, example

-}

import Accessibility.Styled exposing (..)
import Browser.Dom as Dom
import Category exposing (Category(..))
import CommonControls
import Debug.Control as Control exposing (Control)
import Debug.Control.Extra as ControlExtra
import Debug.Control.View as ControlView
import EllieLink
import Example exposing (Example)
import KeyboardSupport exposing (Key(..))
import Nri.Ui.ClickableText.V3 as ClickableText
import Nri.Ui.Menu.V3 as Menu
import Nri.Ui.UiIcon.V1 as UiIcon
import Set exposing (Set)
import Task
import ViewHelpers exposing (viewExamples)


moduleName : String
moduleName =
    "Menu"


version : Int
version =
    3


{-| -}
example : Example State Msg
example =
    { name = moduleName
    , version = version
    , state = init
    , update = update
    , subscriptions = \_ -> Sub.none
    , categories = [ Layout ]
    , keyboardSupport =
        [ { keys = [ Space ], result = "Opens the menu" }
        , { keys = [ Enter ], result = "Opens the menu" }
        , { keys = [ Tab ], result = "Takes focus out of the menu to the next focusable element & closes the menu." }
        , { keys = [ Tab, Shift ], result = "Takes focus out of the menu to the previous focusable element & closes the menu." }
        , { keys = [ Arrow KeyboardSupport.Up ]
          , result = "If menu is closed, opens the menu & selects the last menu item.\nIf menu is open, moves the focus to the previous menu item."
          }
        , { keys = [ Arrow KeyboardSupport.Down ]
          , result = "If menu is closed, opens the menu & selects the first menu item.\nIf menu is open, moves the focus to the next menu item."
          }
        , { keys = [ Esc ], result = "Closes the menu" }
        ]
    , preview = []
    , view = view
    }


view : EllieLink.Config -> State -> List (Html Msg)
view ellieLinkConfig state =
    let
        menuAttributes =
            (Control.currentValue state.settings).menuAttributes
                |> List.map Tuple.second

        defaultButtonAttributes =
            (Control.currentValue state.settings).buttonAttributes
                |> List.map Tuple.second

        isOpen name =
            case state.openMenu of
                Just open ->
                    open == name

                Nothing ->
                    False
    in
    [ ControlView.view
        { ellieLinkConfig = ellieLinkConfig
        , name = moduleName
        , version = version
        , update = UpdateControls
        , settings = state.settings
        , mainType = "RootHtml.Html msg"
        , toExampleCode =
            \settings ->
                let
                    toCode buttonCode =
                        moduleName
                            ++ ".view"
                            ++ ControlView.codeFromList settings.menuAttributes
                            ++ ("\n\t{ button = " ++ buttonCode)
                            ++ "\n\t, entries = []"
                            ++ "\n\t, isOpen = True"
                            ++ "\n\t, focusAndToggle = FocusAndToggle"
                            ++ "\n\t}"
                in
                [ { sectionName = "Menu.button"
                  , code =
                        "\n\t\tMenu.button "
                            ++ ControlView.codeFromListWithIndentLevel 3 settings.buttonAttributes
                            ++ "\n\t\t\t\"1st Period English with Mx. Trainer\""
                            |> toCode
                  }
                , { sectionName = "Menu.custom"
                  , code =
                        "\n\t\tMenu.custom <|"
                            ++ "\n\t\t\t\\buttonAttributes ->"
                            ++ "\n\t\t\t\tbutton buttonAttributes [ text \"Custom Menu trigger button\" ]"
                            |> toCode
                  }
                ]
        }
    , viewExamples
        [ ( "Menu.button"
          , Menu.view
                (menuAttributes
                    ++ List.filterMap identity
                        [ Just <| Menu.buttonId "1stPeriodEnglish__button"
                        , Just <| Menu.menuId "1stPeriodEnglish__menu"
                        ]
                )
                { isOpen = isOpen "1stPeriodEnglish"
                , focusAndToggle = FocusAndToggle "1stPeriodEnglish"
                , entries =
                    [ Menu.entry "hello-button" <|
                        \attrs ->
                            ClickableText.button "Hello"
                                [ ClickableText.onClick (ConsoleLog "Hello")
                                , ClickableText.small
                                , ClickableText.custom attrs
                                ]
                    , Menu.group "Menu group"
                        [ Menu.entry "gift-button" <|
                            \attrs ->
                                ClickableText.button "Gift"
                                    [ ClickableText.onClick (ConsoleLog "Gift")
                                    , ClickableText.small
                                    , ClickableText.custom attrs
                                    , ClickableText.icon UiIcon.gift
                                    ]
                        , Menu.entry "null-button" <|
                            \attrs ->
                                ClickableText.button "Nope!"
                                    [ ClickableText.onClick (ConsoleLog "Nope!")
                                    , ClickableText.small
                                    , ClickableText.custom attrs
                                    , ClickableText.icon UiIcon.null
                                    ]
                        , Menu.entry "no-icon-button" <|
                            \attrs ->
                                ClickableText.button "Skip"
                                    [ ClickableText.onClick (ConsoleLog "Skip")
                                    , ClickableText.small
                                    , ClickableText.custom attrs
                                    ]
                        ]
                    , Menu.entry "performance-button" <|
                        \attrs ->
                            ClickableText.button "Performance"
                                [ ClickableText.onClick (ConsoleLog "Performance")
                                , ClickableText.small
                                , ClickableText.custom attrs
                                ]
                    ]
                , button = Menu.button defaultButtonAttributes "1st Period English with Mx. Trainer"
                }
          )
        , ( "Menu.custom"
          , Menu.view
                (menuAttributes
                    ++ List.filterMap identity
                        [ Just <| Menu.buttonId "icon-button-with-menu__button"
                        , Just <| Menu.menuId "icon-button-with-menu__menu"
                        ]
                )
                { entries =
                    [ Menu.entry "see-more-button" <|
                        \attrs ->
                            ClickableText.button "See more"
                                [ ClickableText.onClick (ConsoleLog "See more")
                                , ClickableText.small
                                , ClickableText.custom attrs
                                , ClickableText.icon UiIcon.seeMore
                                ]
                    ]
                , isOpen = isOpen "icon-button-with-menu"
                , focusAndToggle = FocusAndToggle "icon-button-with-menu"
                , button =
                    Menu.custom <|
                        \buttonAttributes ->
                            button buttonAttributes [ text "Custom Menu trigger button" ]
                }
          )
        ]
    ]


{-| -}
init : State
init =
    { openMenu = Nothing
    , checkboxChecked = False
    , openTooltips = Set.empty
    , settings = initSettings
    }


{-| -}
type alias State =
    { openMenu : Maybe Id
    , checkboxChecked : Bool
    , openTooltips : Set String
    , settings : Control Settings
    }


type alias Settings =
    { menuAttributes : List ( String, Menu.Attribute Msg )
    , buttonAttributes : List ( String, Menu.ButtonAttribute )
    }


initSettings : Control Settings
initSettings =
    Control.record Settings
        |> Control.field "Menu attributes" controlMenuAttributes
        |> Control.field "Button attributes" controlButtonAttributes


controlMenuAttributes : Control (List ( String, Menu.Attribute msg ))
controlMenuAttributes =
    ControlExtra.list
        |> ControlExtra.optionalListItem "alignment" controlAlignment
        |> ControlExtra.optionalBoolListItem "isDisabled" ( "Menu.isDisabled True", Menu.isDisabled True )
        |> ControlExtra.optionalListItem "menuWidth" controlMenuWidth


controlAlignment : Control ( String, Menu.Attribute msg )
controlAlignment =
    Control.choice
        [ ( "Left"
          , Control.value ( "Menu.alignment Menu.Left", Menu.alignment Menu.Left )
          )
        , ( "Right"
          , Control.value ( "Menu.alignment Menu.Right", Menu.alignment Menu.Right )
          )
        ]


controlMenuWidth : Control ( String, Menu.Attribute msg )
controlMenuWidth =
    Control.map
        (\val -> ( "Menu.menuWidth " ++ String.fromInt val, Menu.menuWidth val ))
        (ControlExtra.int 220)


controlButtonAttributes : Control (List ( String, Menu.ButtonAttribute ))
controlButtonAttributes =
    ControlExtra.list
        |> CommonControls.icon moduleName Menu.icon
        |> ControlExtra.optionalBoolListItemDefaultTrue "hasBorder" ( "Menu.hasBorder False", Menu.hasBorder False )
        |> ControlExtra.optionalListItem "buttonWidth" controlButtonWidth
        |> ControlExtra.optionalListItem "wrapping" controlWrapping


controlButtonWidth : Control ( String, Menu.ButtonAttribute )
controlButtonWidth =
    Control.map
        (\val -> ( "Menu.buttonWidth " ++ String.fromInt val, Menu.buttonWidth val ))
        (ControlExtra.int 220)


controlWrapping : Control ( String, Menu.ButtonAttribute )
controlWrapping =
    Control.choice
        [ ( "WrapAndExpandTitle"
          , Control.value ( "Menu.wrapping Menu.WrapAndExpandTitle", Menu.wrapping Menu.WrapAndExpandTitle )
          )
        , ( "TruncateTitle"
          , Control.value ( "Menu.wrapping Menu.TruncateTitle", Menu.wrapping Menu.TruncateTitle )
          )
        ]


{-| -}
type Msg
    = ConsoleLog String
    | UpdateControls (Control Settings)
    | FocusAndToggle String { isOpen : Bool, focus : Maybe String }
    | Focused (Result Dom.Error ())


{-| -}
update : Msg -> State -> ( State, Cmd Msg )
update msg state =
    case msg of
        ConsoleLog message ->
            ( Debug.log "Menu Example" message |> always state, Cmd.none )

        UpdateControls configuration ->
            ( { state | settings = configuration }, Cmd.none )

        FocusAndToggle id { isOpen, focus } ->
            ( { state
                | openMenu =
                    if isOpen then
                        Just id

                    else
                        Nothing
              }
            , Maybe.map (\idString -> Task.attempt Focused (Dom.focus idString)) focus
                |> Maybe.withDefault Cmd.none
            )

        Focused _ ->
            ( state, Cmd.none )



-- INTERNAL


type alias Id =
    String
