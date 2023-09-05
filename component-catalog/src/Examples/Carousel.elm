module Examples.Carousel exposing
    ( example
    , State, Msg
    )

{-|

@docs example
@docs State, Msg

-}

import Browser.Dom as Dom
import Category exposing (Category(..))
import Code
import Css exposing (..)
import Debug.Control as Control exposing (Control)
import Debug.Control.Extra
import Debug.Control.View as ControlView
import Example exposing (Example)
import Html.Styled as Html exposing (..)
import Html.Styled.Attributes as Attributes exposing (css)
import KeyboardSupport exposing (Key(..))
import Nri.Ui.Carousel.V2 as Carousel
import Nri.Ui.ClickableSvg.V2 as ClickableSvg
import Nri.Ui.Colors.V1 as Colors
import Nri.Ui.Container.V2 as Container
import Nri.Ui.Heading.V3 as Heading
import Nri.Ui.Html.Attributes.V2 as Attributes
import Nri.Ui.Table.V7 as Table
import Nri.Ui.UiIcon.V1 as UiIcon
import Task


type alias State =
    { selected : Int
    , settings : Control Settings
    , tip : Tip
    }


init : State
init =
    { selected = 0
    , settings = initSettings
    , tip = AvoidWhiteAfterLaborDay
    }


type alias Settings =
    { items : Int
    , carouselType : CarouselType
    }


type CarouselType
    = Tabs
    | PrevNext
    | Combined


initSettings : Control Settings
initSettings =
    Control.record Settings
        |> Control.field "items" (Debug.Control.Extra.int 4)
        |> Control.field "carouselType" controlCarouselType


controlCarouselType : Control CarouselType
controlCarouselType =
    Control.choice
        [ ( "viewWithPreviousAndNextControls", Control.value PrevNext )
        , ( "viewWithTabControls", Control.value Tabs )
        , ( "viewWithCombinedControls", Control.value Combined )
        ]


controlStyles : Bool -> List Css.Style
controlStyles isSelected =
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


type Msg
    = FocusAndSelect { select : Int, focus : Maybe String }
    | AnnounceAndSelect { select : Int, announce : String }
    | SelectTip { select : Tip, announce : String }
    | Focused (Result Dom.Error ())
    | SetSettings (Control Settings)


update : Msg -> State -> ( State, Cmd Msg )
update msg model =
    case msg of
        FocusAndSelect { select, focus } ->
            ( { model | selected = select }
            , focus
                |> Maybe.map (Dom.focus >> Task.attempt Focused)
                |> Maybe.withDefault Cmd.none
            )

        Focused error ->
            ( model, Cmd.none )

        SetSettings settings ->
            ( { model | settings = settings }, Cmd.none )

        AnnounceAndSelect { select, announce } ->
            ( { model | selected = select }
            , -- TODO: actually announce!
              Cmd.none
            )

        SelectTip { select, announce } ->
            ( { model | tip = select }
            , -- TODO: actually announce!
              Cmd.none
            )


moduleName : String
moduleName =
    "Carousel"


version : Int
version =
    2


example : Example State Msg
example =
    { name = moduleName
    , version = version
    , categories = [ Navigation ]
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
        [ -- faking a mini version of the Carousel component to give Component Catalog users a sense of what the
          -- component might look like
          Html.div [ css [ Css.position Css.relative ] ]
            [ Html.div
                [ css
                    [ Css.displayFlex
                    , Css.alignItems Css.center
                    , Css.justifyContent Css.spaceBetween
                    , Css.marginBottom (Css.px 10)
                    ]
                ]
                [ ClickableSvg.button "Previous" UiIcon.arrowLeft []
                , Html.text "First Slide"
                , ClickableSvg.button "Next" UiIcon.arrowRight []
                ]
            , Html.div
                [ Attributes.css
                    [ Css.displayFlex
                    , Css.justifyContent Css.center
                    , Css.property "gap" "5px"
                    ]
                ]
                [ Html.div [ Attributes.css (controlStyles True) ] [ Html.text "1" ]
                , Html.div [ Attributes.css (controlStyles False) ] [ Html.text "2" ]
                , Html.div [ Attributes.css (controlStyles False) ] [ Html.text "3" ]
                ]
            ]
        ]
    , about = []
    , view =
        \ellieLinkConfig model ->
            let
                settings =
                    Control.currentValue model.settings

                ( code_, view ) =
                    case settings.carouselType of
                        Tabs ->
                            viewWithTabControls model

                        PrevNext ->
                            viewCustomizableWithPreviousAndNextControls model

                        Combined ->
                            viewWithCombinedControls model
            in
            [ ControlView.view
                { ellieLinkConfig = ellieLinkConfig
                , name = moduleName
                , version = version
                , update = SetSettings
                , settings = model.settings
                , mainType = Just "RootHtml.Html { select : Int, focus : Maybe String }"
                , extraCode = []
                , renderExample = Code.unstyledView
                , toExampleCode =
                    \_ ->
                        [ { sectionName = "Example"
                          , code = code_
                          }
                        ]
                }
            , Heading.h2
                [ Heading.plaintext "Customizable example"
                , Heading.css [ Css.marginTop (Css.px 30) ]
                ]
            , view
            , Heading.h2
                [ Heading.plaintext "Usage examples"
                , Heading.css [ Css.marginTop (Css.px 30) ]
                ]
            , Table.view []
                [ Table.rowHeader
                    { header = text (moduleName ++ " view name")
                    , view = \{ viewName } -> code [] [ text viewName ]
                    , width = Css.zero
                    , cellStyles =
                        always
                            [ Css.padding2 (Css.px 14) (Css.px 7)
                            , Css.verticalAlign Css.middle
                            , Css.textAlign Css.left
                            , Css.fontWeight Css.normal
                            ]
                    , sort = Nothing
                    }
                , Table.custom
                    { header = text "Example with added styles"
                    , view = .example
                    , width = Css.pct 60
                    , cellStyles =
                        always
                            [ Css.padding2 (Css.px 14) (Css.px 7)
                            , Css.verticalAlign Css.middle
                            , Css.lineHeight (Css.num 2)
                            ]
                    , sort = Nothing
                    }
                ]
                [ { viewName = "viewWithPreviousAndNextControls"
                  , example = viewTips model.tip
                  }
                , { viewName = "viewWithTabControls"
                  , example = text ""
                  }
                , { viewName = "viewWithCombinedControls"
                  , example = text ""
                  }
                ]
            ]
    }


viewCustomizableWithPreviousAndNextControls : State -> ( String, Html Msg )
viewCustomizableWithPreviousAndNextControls model =
    let
        settings =
            Control.currentValue model.settings

        allItems =
            settings.items
                |> indicesForItemCount
                |> List.map toNonTabbedCarouselItem

        { viewPreviousButton, viewNextButton, slides, containerAttributes } =
            Carousel.viewWithPreviousAndNextControls
                { selected = model.selected
                , slides = List.map Tuple.second allItems
                , previousButton =
                    { attributes = [], icon = UiIcon.arrowLeft, name = "Previous" }
                , nextButton =
                    { attributes = [], icon = UiIcon.arrowRight, name = "Next" }
                , name = "Items"
                , visibleLabelId = Nothing
                , role = Carousel.Group
                , announceAndSelect = AnnounceAndSelect
                }
    in
    ( Code.pipelineMultiline
        [ Code.fromModule moduleName "viewWithPreviousAndNextControls"
            ++ Code.recordMultiline
                [ ( "selected", Code.int model.selected )
                , ( "slides", Code.listMultiline (List.map Tuple.first allItems) 3 )
                , ( "previousButton"
                  , Code.recordMultiline
                        [ ( "name", Code.string "Previous" )
                        , ( "icon", "UiIcon.arrowLeft" )
                        , ( "attributes", Code.list [] )
                        ]
                        2
                  )
                , ( "nextButton"
                  , Code.recordMultiline
                        [ ( "name", Code.string "Previous" )
                        , ( "icon", "UiIcon.arrowRight" )
                        , ( "attributes", Code.list [] )
                        ]
                        2
                  )
                , ( "name", Code.string "Items" )
                , ( "visibleLabelId", Code.maybe Nothing )
                , ( "role", Code.fromModule moduleName "Group" )
                , ( "announceAndSelect", "AnnounceAndSelect" )
                ]
                1
        , Code.anonymousFunction "{ viewPreviousButton, viewNextButton, slides, containerAttributes }"
            (Code.newlineWithIndent 2
                ++ "section containerAttributes [ slides, viewPreviousButton, viewNextButton ]"
            )
        ]
        0
    , Html.div containerAttributes [ slides, viewPreviousButton, viewNextButton ]
    )


viewWithCombinedControls : State -> ( String, Html Msg )
viewWithCombinedControls model =
    let
        settings =
            Control.currentValue model.settings

        allItems =
            settings.items
                |> indicesForItemCount
                |> List.map toTabbedCarouselItem

        { tabControls, slides, viewPreviousButton, viewNextButton, containerAttributes } =
            Carousel.viewWithCombinedControls
                { selected = model.selected
                , slides = List.map Tuple.second allItems
                , tabControlStyles = \_ -> []
                , tabControlListStyles = []
                , previousButton =
                    { attributes = [], icon = UiIcon.arrowLeft, name = "Previous" }
                , nextButton =
                    { attributes = [], icon = UiIcon.arrowRight, name = "Next" }
                , role = Carousel.Group
                , name = "Items"
                , visibleLabelId = Nothing
                , focusAndSelect = FocusAndSelect
                , announceAndSelect = AnnounceAndSelect
                }
    in
    ( Code.pipelineMultiline
        [ Code.fromModule moduleName "viewWithCombinedControls"
            ++ Code.record
                [ ( "selected", Code.int model.selected )
                , ( "slides", Code.listMultiline (List.map Tuple.first allItems) 2 )
                , ( "tabControlStyles", "(\\_ -> [])" )
                , ( "tabControlListStyles", Code.list [] )
                , ( "previousButton"
                  , Code.recordMultiline
                        [ ( "name", Code.string "Previous" )
                        , ( "icon", "UiIcon.arrowLeft" )
                        , ( "attributes", Code.list [] )
                        ]
                        2
                  )
                , ( "nextButton"
                  , Code.recordMultiline
                        [ ( "name", Code.string "Previous" )
                        , ( "icon", "UiIcon.arrowRight" )
                        , ( "attributes", Code.list [] )
                        ]
                        2
                  )
                , ( "role", Code.fromModule moduleName "Group" )
                , ( "name", Code.string "Items" )
                , ( "visibleLabelId", Code.maybe Nothing )
                , ( "focusAndSelect", "FocusAndSelect" )
                , ( "announceAndSelect", "AnnounceAndSelect" )
                ]
        , Code.anonymousFunction "{ tabControls, slides, viewPreviousButton, viewNextButton, containerAttributes }"
            (Code.newlineWithIndent 2
                ++ "section containerAttributes [ slides, tabControls, viewPreviousButton, viewNextButton  ]"
            )
        ]
        0
    , Html.div containerAttributes [ slides, tabControls, viewPreviousButton, viewNextButton ]
    )


viewWithTabControls : State -> ( String, Html Msg )
viewWithTabControls model =
    let
        settings =
            Control.currentValue model.settings

        allItems =
            settings.items
                |> indicesForItemCount
                |> List.map toTabbedCarouselItem

        { controls, slides, containerAttributes } =
            Carousel.viewWithTabControls
                { selected = model.selected
                , slides = List.map Tuple.second allItems
                , tabControlStyles = \_ -> []
                , tabControlListStyles = []
                , role = Carousel.Group
                , name = "Items"
                , visibleLabelId = Nothing
                , focusAndSelect = FocusAndSelect
                }
    in
    ( Code.pipelineMultiline
        [ Code.fromModule moduleName "viewWithTabControls"
            ++ Code.record
                [ ( "selected", Code.int model.selected )
                , ( "slides", Code.listMultiline (List.map Tuple.first allItems) 2 )
                , ( "tabControlStyles", "(\\_ -> [])" )
                , ( "tabControlListStyles", Code.list [] )
                , ( "role", Code.fromModule moduleName "Group" )
                , ( "name", Code.string "Items" )
                , ( "visibleLabelId", Code.maybe Nothing )
                , ( "focusAndSelect", "FocusAndSelect" )
                , ( "announceAndSelect", "AnnounceAndSelect" )
                ]
        , Code.anonymousFunction "{ controls, slides, containerAttributes }"
            (Code.newlineWithIndent 2
                ++ "section containerAttributes [ slides, controls ]"
            )
        ]
        0
    , Html.div containerAttributes [ slides, controls ]
    )


indicesForItemCount : Int -> List Int
indicesForItemCount itemCount =
    List.range 0 (max 0 (itemCount - 1))


toNonTabbedCarouselItem :
    Int
    ->
        ( String
        , { id : Int
          , idString : String
          , name : String
          , visibleLabelId : Maybe String
          , slideHtml : Html msg
          }
        )
toNonTabbedCarouselItem id =
    let
        idString =
            Attributes.safeIdWithPrefix "slide" <| String.fromInt id

        humanizedId =
            String.fromInt (id + 1)
    in
    ( Code.recordMultiline
        [ ( "id", Code.int id )
        , ( "idString", Code.string (String.fromInt id) )
        , ( "name", Code.string ("Slide " ++ humanizedId) )
        , ( "visibleLabelId", Code.maybe Nothing )
        , ( "slideHtml", "Html.text " ++ Code.string ("Contents for slide " ++ humanizedId) )
        ]
        4
    , { id = id
      , idString = idString
      , name = "Slide " ++ humanizedId
      , visibleLabelId = Nothing
      , slideHtml = Html.text ("Contents for slide " ++ humanizedId)
      }
    )


toTabbedCarouselItem :
    Int
    ->
        ( String
        , { id : Int
          , idString : String
          , name : String
          , visibleLabelId : Maybe String
          , slideHtml : Html msg
          , tabControlHtml : Html Never
          }
        )
toTabbedCarouselItem id =
    let
        idString =
            Attributes.safeIdWithPrefix "slide" <| String.fromInt id

        humanizedId =
            String.fromInt (id + 1)
    in
    ( Code.recordMultiline
        [ ( "id", Code.int id )
        , ( "idString", Code.string (String.fromInt id) )
        , ( "name", Code.string ("Slide " ++ humanizedId) )
        , ( "visibleLabelId", Code.maybe Nothing )
        , ( "tabControlHtml", "Html.text " ++ Code.string ("Slide " ++ humanizedId) )
        , ( "slideHtml", "Html.text " ++ Code.string ("Contents for slide " ++ humanizedId) )
        ]
        3
    , { id = id
      , idString = idString
      , name = "Slide " ++ humanizedId
      , visibleLabelId = Nothing
      , tabControlHtml = Html.text ("Slide " ++ humanizedId)
      , slideHtml = Html.text ("Contents for slide " ++ humanizedId)
      }
    )


viewTips : Tip -> Html Msg
viewTips selected =
    let
        { viewPreviousButton, viewNextButton, slides, containerAttributes } =
            Carousel.viewWithPreviousAndNextControls
                { selected = selected
                , slides =
                    [ { id = AvoidWhiteAfterLaborDay
                      , idString = "avoid-white-after-labor-day"
                      , name = "Avoid White After Labor Day"
                      , visibleLabelId = Nothing
                      , slideHtml = text "Avoid wearing white after Labor Day"
                      }
                    , { id = AvoidNavyAndBlack
                      , idString = "avoid-navy-and-black"
                      , name = "Avoid pairing navy and black"
                      , visibleLabelId = Nothing
                      , slideHtml = text "Avoid pairing navy and black"
                      }
                    , { id = TailorOffTheShelfClothes
                      , idString = "tailor-off-the-shelf-clothes"
                      , name = "Tailor off the shelf clothes"
                      , visibleLabelId = Nothing
                      , slideHtml = text "Tailor off the shelf clothes"
                      }
                    ]
                , previousButton =
                    { attributes = [ ClickableSvg.small, ClickableSvg.withBorder ]
                    , icon = UiIcon.arrowTop
                    , name = "Previous"
                    }
                , nextButton =
                    { attributes = [ ClickableSvg.small, ClickableSvg.withBorder ]
                    , icon = UiIcon.arrowDown
                    , name = "Next"
                    }
                , name = "Tips"
                , visibleLabelId = Nothing
                , role = Carousel.Group
                , announceAndSelect = SelectTip
                }
    in
    Container.view
        [ Container.custom containerAttributes
        , Container.css
            [ displayFlex
            , alignItems center
            , position relative
            , marginRight (px 20)
            , maxWidth (px 210)
            ]
        , Container.html
            [ slides
            , div
                [ css
                    [ displayFlex
                    , flexDirection column
                    , property "gap" "4px"
                    , right (px -20)
                    , position absolute
                    ]
                ]
                [ viewPreviousButton
                , viewNextButton
                ]
            ]
        ]


type Tip
    = AvoidWhiteAfterLaborDay
    | AvoidNavyAndBlack
    | TailorOffTheShelfClothes
