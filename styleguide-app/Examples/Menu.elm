module Examples.Menu exposing (Msg, State, example)

{-|

@docs Msg, State, example

-}

import Accessibility.Styled exposing (..)
import Accessibility.Styled.Role as Role
import Browser.Dom as Dom
import Category exposing (Category(..))
import Code
import CommonControls
import Css
import Debug.Control as Control exposing (Control)
import Debug.Control.Extra as ControlExtra
import Debug.Control.View as ControlView
import EllieLink
import Example exposing (Example)
import KeyboardSupport exposing (Key(..))
import Nri.Ui.Button.V10 as Button
import Nri.Ui.ClickableText.V3 as ClickableText
import Nri.Ui.Colors.Extra as ColorsExtra
import Nri.Ui.Colors.V1 as Colors
import Nri.Ui.Fonts.V1 as Fonts
import Nri.Ui.Menu.V4 as Menu
import Nri.Ui.Table.V6 as Table
import Nri.Ui.TextInput.V7 as TextInput
import Nri.Ui.UiIcon.V1 as UiIcon
import Set exposing (Set)
import Svg.Styled as Svg
import Svg.Styled.Attributes as SvgAttrs
import Task


moduleName : String
moduleName =
    "Menu"


version : Int
version =
    4


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
    , preview = [ preview ]
    , view = view
    }


preview : Html Never
preview =
    Svg.svg
        [ SvgAttrs.viewBox "0 0 100 100"
        , SvgAttrs.width "100%"
        , SvgAttrs.height "100%"
        , SvgAttrs.fill (ColorsExtra.toCssString Colors.white)
        , Role.img
        , SvgAttrs.filter "drop-shadow(0px 2px 2px rgb(0 0 0 / 0.4))"
        ]
        [ Svg.rect
            [ SvgAttrs.x "5"
            , SvgAttrs.y "10"
            , SvgAttrs.width "95"
            , SvgAttrs.height "60"
            , SvgAttrs.rx "5"
            ]
            []
        , Svg.polygon [ SvgAttrs.points "80,10 85,4 90,10" ] []
        , Svg.text_
            [ SvgAttrs.fill (ColorsExtra.toCssString Colors.azure)
            , SvgAttrs.css [ Fonts.baseFont, Css.fontSize (Css.px 6) ]
            , SvgAttrs.x "15"
            , SvgAttrs.y "28"
            ]
            [ Svg.text "Menu item 1" ]
        , Svg.text_
            [ SvgAttrs.fill (ColorsExtra.toCssString Colors.azure)
            , SvgAttrs.css [ Fonts.baseFont, Css.fontSize (Css.px 6) ]
            , SvgAttrs.x "15"
            , SvgAttrs.y "42"
            ]
            [ Svg.text "Menu item 2" ]
        , Svg.text_
            [ SvgAttrs.fill (ColorsExtra.toCssString Colors.azure)
            , SvgAttrs.css [ Fonts.baseFont, Css.fontSize (Css.px 6) ]
            , SvgAttrs.x "15"
            , SvgAttrs.y "56"
            ]
            [ Svg.text "Menu item 3" ]
        ]


view : EllieLink.Config -> State -> List (Html Msg)
view ellieLinkConfig state =
    let
        menuAttributes =
            (Control.currentValue state.settings).menuAttributes
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
        , mainType = Just "RootHtml.Html { focus : Maybe String, isOpen : Bool }"
        , extraCode = []
        , renderExample = Code.unstyledView
        , toExampleCode =
            \settings ->
                let
                    toCode : String -> String
                    toCode buttonCode =
                        moduleName
                            ++ ".view "
                            ++ Code.list (buttonCode :: List.map Tuple.first settings.menuAttributes)
                            ++ Code.recordMultiline
                                [ ( "entries", "[]" )
                                , ( "isOpen", "True" )
                                , ( "focusAndToggle", "identity -- TODO: you will need a real msg type here" )
                                ]
                                1
                in
                [ { sectionName = "Menu.button"
                  , code =
                        "Menu.button "
                            ++ Code.string "1st Period English with Mx. Trainer"
                            ++ Code.list []
                            |> toCode
                  }
                , { sectionName = "Menu.clickableText"
                  , code =
                        "Menu.clickableText "
                            ++ Code.string "1st Period English with Mx. Trainer"
                            ++ Code.list []
                            |> toCode
                  }
                , { sectionName = "Menu.clickableSvg"
                  , code =
                        "Menu.clickableSvg"
                            ++ Code.newlineWithIndent 2
                            ++ Code.string "1st Period English with Mx. Trainer"
                            ++ Code.newlineWithIndent 2
                            ++ "UiIcon.gear"
                            ++ Code.newlineWithIndent 2
                            ++ Code.list []
                            |> toCode
                  }
                , { sectionName = "Menu.custom"
                  , code =
                        "Menu.custom <|"
                            ++ Code.newlineWithIndent 2
                            ++ "\\buttonAttributes ->"
                            ++ Code.newlineWithIndent 3
                            ++ "button buttonAttributes [ text \"Custom Menu trigger button\" ]"
                            |> toCode
                  }
                ]
        }
    , Table.view
        [ Table.string
            { header = "Button type"
            , value = .button
            , width = Css.pct 30
            , cellStyles = always [ Css.padding2 (Css.px 14) (Css.px 7), Css.verticalAlign Css.middle, Css.fontWeight Css.bold ]
            , sort = Nothing
            }
        , Table.string
            { header = "Menu type"
            , value = .menu
            , width = Css.pct 30
            , cellStyles = always [ Css.padding2 (Css.px 14) (Css.px 7), Css.verticalAlign Css.middle, Css.fontWeight Css.bold ]
            , sort = Nothing
            }
        , Table.custom
            { header = text "Example"
            , view = .example
            , width = Css.px 300
            , cellStyles = always [ Css.padding2 (Css.px 14) (Css.px 7), Css.verticalAlign Css.middle ]
            , sort = Nothing
            }
        ]
        [ { button = "Menu.button"
          , menu = "default (Menu.navMenu)"
          , example =
                Menu.view
                    (menuAttributes
                        ++ List.filterMap identity
                            [ Just <| Menu.buttonId "1stPeriodEnglish__button"
                            , Just <| Menu.menuId "1stPeriodEnglish__menu"
                            , Just <| Menu.button "1st Period English with Mx. Trainer" []
                            , Just <| Menu.isOpen (isOpen "1stPeriodEnglish")
                            ]
                    )
                    { focusAndToggle = FocusAndToggle "1stPeriodEnglish"
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
                    }
          }
        , { button = "Menu.clickableText"
          , menu = "default (Menu.navMenu)"
          , example =
                Menu.view
                    (menuAttributes
                        ++ [ Menu.clickableText "1st Period English with Mx. Trainer" []
                           , Menu.isOpen (isOpen "clickableTextExample")
                           ]
                    )
                    { focusAndToggle = FocusAndToggle "clickableTextExample"
                    , entries = []
                    }
          }
        , { button = "Menu.clickableSvg"
          , menu = "default (Menu.navMenu)"
          , example =
                Menu.view
                    (menuAttributes
                        ++ [ Menu.clickableSvg "1st Period English with Mx. Trainer" UiIcon.gear []
                           , Menu.isOpen (isOpen "clickableSvgExample")
                           ]
                    )
                    { focusAndToggle = FocusAndToggle "clickableSvgExample"
                    , entries = []
                    }
          }
        , { button = "Menu.custom"
          , menu = "default (Menu.navMenu)"
          , example =
                Menu.view
                    (menuAttributes
                        ++ List.filterMap identity
                            [ Just <| Menu.isOpen (isOpen "icon-button-with-menu")
                            , Just <| Menu.buttonId "icon-button-with-menu__button"
                            , Just <| Menu.menuId "icon-button-with-menu__menu"
                            , Just <|
                                Menu.custom <|
                                    \buttonAttributes ->
                                        button buttonAttributes [ text "Custom Menu trigger button" ]
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
                    , focusAndToggle = FocusAndToggle "icon-button-with-menu"
                    }
          }
        , { button = "Menu.button"
          , menu = "Menu.disclosure"
          , example =
                Menu.view
                    (menuAttributes
                        ++ [ Menu.buttonId "disclosure__button"
                           , Menu.menuId "disclosure__menu"
                           , Menu.disclosure { lastId = "disclosure__login__button" }
                           , Menu.button "Log In disclosure" []
                           , Menu.isOpen (isOpen "with_disclosure")
                           ]
                    )
                    { focusAndToggle = FocusAndToggle "with_disclosure"
                    , entries =
                        [ Menu.entry "disclosure__username" <|
                            \attrs ->
                                div []
                                    [ TextInput.view "Username"
                                        [ TextInput.id "disclosure__username__input"
                                        ]
                                    , TextInput.view "Password"
                                        [ TextInput.id "disclosure__password__input"
                                        ]
                                    , Button.button "Log in"
                                        [ Button.primary
                                        , Button.id "disclosure__login__button"
                                        , Button.fillContainerWidth
                                        , Button.css [ Css.marginTop (Css.px 15) ]
                                        ]
                                    ]
                        ]
                    }
          }
        , { button = "Menu.button"
          , menu = "Menu.dialog"
          , example =
                Menu.view
                    (menuAttributes
                        ++ [ Menu.buttonId "dialog__button"
                           , Menu.menuId "dialog__menu"
                           , Menu.dialog { firstId = "dialog__username__input", lastId = "dialog__login__button" }
                           , Menu.button "Log In dialog" []
                           , Menu.isOpen (isOpen "dialog")
                           ]
                    )
                    { focusAndToggle = FocusAndToggle "dialog"
                    , entries =
                        [ Menu.entry "dialog__username" <|
                            \attrs ->
                                div []
                                    [ TextInput.view "Username"
                                        [ TextInput.id "dialog__username__input"
                                        ]
                                    , TextInput.view "Password"
                                        [ TextInput.id "dialog__password__input"
                                        ]
                                    , Button.button "Log in"
                                        [ Button.primary
                                        , Button.id "dialog__login__button"
                                        , Button.fillContainerWidth
                                        , Button.css [ Css.marginTop (Css.px 15) ]
                                        ]
                                    ]
                        ]
                    }
          }
        , { button = "Menu.button"
          , menu = "Menu.navMenuList"
          , example =
                Menu.view
                    (menuAttributes
                        ++ [ Menu.buttonId "dropdown_list__button"
                           , Menu.menuId "dropdown_list__menu"
                           , Menu.navMenuList
                           , Menu.button "Dropdown list" []
                           , Menu.isOpen (isOpen "dropdown_list")
                           ]
                    )
                    { focusAndToggle = FocusAndToggle "dropdown_list"
                    , entries =
                        [ Menu.entry "dropdown_list__first" <|
                            \attrs ->
                                ClickableText.button "First"
                                    [ ClickableText.small
                                    , ClickableText.onClick (ConsoleLog "First")
                                    , ClickableText.custom attrs
                                    ]
                        , Menu.entry "dropdown_list__second" <|
                            \attrs ->
                                ClickableText.button "Second"
                                    [ ClickableText.small
                                    , ClickableText.onClick (ConsoleLog "Second")
                                    , ClickableText.custom attrs
                                    ]
                        , Menu.entry "dropdown_list__third" <|
                            \attrs ->
                                ClickableText.button "Third"
                                    [ ClickableText.small
                                    , ClickableText.onClick (ConsoleLog "Third")
                                    , ClickableText.custom attrs
                                    ]
                        ]
                    }
          }
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
    }


initSettings : Control Settings
initSettings =
    Control.record Settings
        |> Control.field "Menu attributes" controlMenuAttributes


controlMenuAttributes : Control (List ( String, Menu.Attribute msg ))
controlMenuAttributes =
    ControlExtra.list
        |> ControlExtra.optionalListItem "alignment" controlAlignment
        |> ControlExtra.optionalBoolListItem "isDisabled" ( "Menu.isDisabled True", Menu.isDisabled True )
        |> ControlExtra.optionalListItem "menuWidth" controlMenuWidth
        |> ControlExtra.optionalBoolListItem "opensOnHover" ( "Menu.opensOnHover True", Menu.opensOnHover True )


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
