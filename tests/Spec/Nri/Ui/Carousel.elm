module Spec.Nri.Ui.Carousel exposing (spec)

import Browser.Dom as Dom
import Html.Styled exposing (..)
import Nri.Ui.Carousel.V2 as Carousel
import Nri.Ui.UiIcon.V1 as UiIcon
import ProgramTest exposing (..)
import Spec.TabsInternalHelpers exposing (..)
import Task
import Test exposing (..)
import Test.Html.Selector as Selector


spec : Test
spec =
    describe "Nri.Ui.Carousel.V2"
        [ describe "viewWithTabControls rendering" panelRenderingTests
        , describe "keyboard behavior on viewWithTabControls" keyboardTests
        , describe "viewWithPreviousAndNextControls rendering" viewWithPreviousAndNextControlsTests
        , describe "viewWithCombinedControls rendering" viewWithCombinedControlsTests
        ]


panelRenderingTests : List Test
panelRenderingTests =
    [ test "displays the associated slide when a control is activated" <|
        \() ->
            program viewWithTabControls
                |> ensureTabbable "Control 0"
                |> ensurePanelDisplayed "Slide 0"
                |> done
    , test "has only one slide displayed" <|
        \() ->
            program viewWithTabControls
                |> ensureOnlyOnePanelDisplayed [ "Slide 0", "Slide 1", "Slide 2" ]
                |> done
    ]


keyboardTests : List Test
keyboardTests =
    [ test "has a focusable control" <|
        \() ->
            program viewWithTabControls
                |> ensureTabbable "Control 0"
                |> done
    , test "all slides are focusable" <|
        \() ->
            program viewWithTabControls
                |> ensurePanelsFocusable [ "Slide 0", "Slide 1", "Slide 2" ]
                |> done
    , test "has only one control included in the tab sequence" <|
        \() ->
            program viewWithTabControls
                |> ensureOnlyOneTabInSequence [ "Control 0", "Control 1", "Control 2" ]
                |> done
    , test "moves focus right on right arrow key" <|
        \() ->
            program viewWithTabControls
                |> ensureTabbable "Control 0"
                |> releaseRightArrow
                |> ensureTabbable "Control 1"
                |> ensureOnlyOneTabInSequence [ "Control 0", "Control 1", "Control 2" ]
                |> releaseRightArrow
                |> ensureTabbable "Control 2"
                |> done
    , test "moves focus left on left arrow key" <|
        \() ->
            program viewWithTabControls
                |> ensureTabbable "Control 0"
                |> releaseRightArrow
                |> ensureTabbable "Control 1"
                |> releaseLeftArrow
                |> ensureTabbable "Control 0"
                |> ensureOnlyOneTabInSequence [ "Control 0", "Control 1", "Control 2" ]
                |> done
    , test "when the focus is on the first element, move focus to the last element on left arrow key" <|
        \() ->
            program viewWithTabControls
                |> ensureTabbable "Control 0"
                |> releaseLeftArrow
                |> ensureTabbable "Control 2"
                |> ensureOnlyOneTabInSequence [ "Control 0", "Control 1", "Control 2" ]
                |> done
    , test "when the focus is on the last element, move focus to the first element on right arrow key" <|
        \() ->
            program viewWithTabControls
                |> ensureTabbable "Control 0"
                |> releaseLeftArrow
                |> ensureTabbable "Control 2"
                |> releaseRightArrow
                |> ensureTabbable "Control 0"
                |> ensureOnlyOneTabInSequence [ "Control 0", "Control 1", "Control 2" ]
                |> done
    ]


viewWithPreviousAndNextControlsTests : List Test
viewWithPreviousAndNextControlsTests =
    [ test "rotate back and forward with 3 slides" <|
        \() ->
            program (viewWithPreviousAndNextControls 3)
                |> ensureSlideIsVisible "slide-0"
                |> clickButton "Next"
                |> ensureSlideIsVisible "slide-1"
                |> clickButton "Next"
                |> ensureSlideIsVisible "slide-2"
                |> clickButton "Next"
                |> ensureSlideIsVisible "slide-0"
                |> clickButton "Previous"
                |> ensureSlideIsVisible "slide-2"
                |> clickButton "Previous"
                |> ensureSlideIsVisible "slide-1"
                |> clickButton "Previous"
                |> ensureSlideIsVisible "slide-0"
                |> done
    , test "rotate back and forward with 1 slides" <|
        \() ->
            program (viewWithPreviousAndNextControls 1)
                |> ensureSlideIsVisible "slide-0"
                |> clickButton "Next"
                |> ensureSlideIsVisible "slide-0"
                |> clickButton "Previous"
                |> ensureSlideIsVisible "slide-0"
                |> done
    ]


viewWithCombinedControlsTests : List Test
viewWithCombinedControlsTests =
    [ test "rotate back and forward with 3 slides" <|
        \() ->
            program viewWithCombinedControls
                |> ensurePanelDisplayed "Slide 0"
                |> clickButton "Next"
                |> ensurePanelDisplayed "Slide 1"
                |> clickButton "Next"
                |> ensurePanelDisplayed "Slide 2"
                |> clickButton "Next"
                |> ensurePanelDisplayed "Slide 0"
                |> clickButton "Previous"
                |> ensurePanelDisplayed "Slide 2"
                |> clickButton "Previous"
                |> ensurePanelDisplayed "Slide 1"
                |> clickButton "Previous"
                |> ensurePanelDisplayed "Slide 0"
                |> done
    ]


ensureSlideIsVisible : String -> ProgramTest.ProgramTest model msg effect -> ProgramTest.ProgramTest model msg effect
ensureSlideIsVisible id =
    ensureViewHas [ Selector.id id, Selector.style "display" "block" ]


update : Msg -> State -> State
update msg model =
    case msg of
        FocusAndSelectTab { select, focus } ->
            Tuple.first
                ( { model | selected = select }
                , focus
                    |> Maybe.map (Dom.focus >> Task.attempt Focused)
                    |> Maybe.withDefault Cmd.none
                )

        Focused _ ->
            Tuple.first ( model, Cmd.none )


viewWithTabControls : State -> Html Msg
viewWithTabControls model =
    Carousel.viewWithTabControls
        { focusAndSelect = FocusAndSelectTab
        , selected = model.selected
        , tabControlListStyles = []
        , role = Carousel.Group
        , tabControlStyles = \_ -> []
        , labelledBy = Carousel.LabelledByAccessibleLabelOnly "Label"
        , panels =
            [ { id = 0
              , idString = "slide-0"
              , tabControlHtml = text "Control 0"
              , slideHtml = text "Slide 0"
              }
            , { id = 1
              , idString = "slide-1"
              , tabControlHtml = text "Control 1"
              , slideHtml = text "Slide 1"
              }
            , { id = 2
              , idString = "slide-2"
              , tabControlHtml = text "Control 2"
              , slideHtml = text "Slide 2"
              }
            ]
        }
        |> (\{ controls, slides, containerAttributes } -> section containerAttributes [ slides, controls ])


viewWithCombinedControls : State -> Html Msg
viewWithCombinedControls model =
    Carousel.viewWithCombinedControls
        { focusAndSelect = FocusAndSelectTab
        , selected = model.selected
        , tabControlListStyles = []
        , role = Carousel.Group
        , tabControlStyles = \_ -> []
        , labelledBy = Carousel.LabelledByAccessibleLabelOnly "Label"
        , panels =
            [ { id = 0
              , idString = "slide-0"
              , tabControlHtml = text "Control 0"
              , slideHtml = text "Slide 0"
              }
            , { id = 1
              , idString = "slide-1"
              , tabControlHtml = text "Control 1"
              , slideHtml = text "Slide 1"
              }
            , { id = 2
              , idString = "slide-2"
              , tabControlHtml = text "Control 2"
              , slideHtml = text "Slide 2"
              }
            ]
        , previousButton = { attributes = [], icon = UiIcon.arrowLeft, name = "Previous" }
        , nextButton = { attributes = [], icon = UiIcon.arrowRight, name = "Next" }
        }
        |> (\{ tabControls, slides, containerAttributes, viewNextButton, viewPreviousButton } ->
                section containerAttributes [ slides, tabControls, viewNextButton, viewPreviousButton ]
           )


viewWithPreviousAndNextControls : Int -> State -> Html Msg
viewWithPreviousAndNextControls slidesCount model =
    Carousel.viewWithPreviousAndNextControls
        { focusAndSelect = FocusAndSelectTab
        , selected = model.selected
        , role = Carousel.Group
        , labelledBy = Carousel.LabelledByAccessibleLabelOnly "Label"
        , panels =
            List.map
                (\i ->
                    { id = i
                    , idString = "slide-" ++ String.fromInt i
                    , labelledBy = Carousel.LabelledByAccessibleLabelOnly ("Control " ++ String.fromInt i)
                    , slideHtml = text ("Slide " ++ String.fromInt i)
                    }
                )
                (List.range 0 (slidesCount - 1))
        , previousButton = { attributes = [], icon = UiIcon.arrowLeft, name = "Previous" }
        , nextButton = { attributes = [], icon = UiIcon.arrowRight, name = "Next" }
        }
        |> (\{ viewPreviousButton, viewNextButton, slides, containerAttributes } ->
                section containerAttributes [ slides, viewPreviousButton, viewNextButton ]
           )


program : (State -> Html Msg) -> TestContext
program view =
    ProgramTest.createSandbox
        { init = init
        , update = update
        , view = view >> toUnstyled
        }
        |> ProgramTest.start ()
