module Examples.RadioButton exposing
    ( example
    , State, Msg
    )

{-|

@docs example
@docs State, Msg

-}

import Accessibility.Styled.Key as Key
import Browser.Dom as Dom
import Category exposing (Category(..))
import Code
import CommonControls exposing (premiumDisplay)
import Css
import Debug.Control as Control exposing (Control)
import Debug.Control.Extra as ControlExtra
import Debug.Control.View as ControlView
import EllieLink
import Example exposing (Example)
import Examples.RadioButtonDotless as RadioButtonDotlessExample
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css)
import KeyboardSupport exposing (Direction(..), Key(..))
import Nri.Ui.Button.V10 as Button
import Nri.Ui.ClickableText.V4 as ClickableText
import Nri.Ui.Colors.V1 as Colors
import Nri.Ui.Data.PremiumDisplay as PremiumDisplay exposing (..)
import Nri.Ui.Heading.V3 as Heading
import Nri.Ui.Html.Attributes.V2 exposing (safeIdWithPrefix)
import Nri.Ui.Message.V4 as Message
import Nri.Ui.Modal.V12 as Modal
import Nri.Ui.RadioButton.V4 as RadioButton
import Nri.Ui.Spacing.V1 as Spacing
import Nri.Ui.Table.V7 as Table
import Nri.Ui.Text.V6 as Text
import Nri.Ui.Tooltip.V3 as Tooltip
import Routes
import Task


moduleName : String
moduleName =
    "RadioButton"


version : Int
version =
    4


type TooltipType
    = HelpfullyDisabled


{-| -}
example : Example State Msg
example =
    { name = moduleName
    , version = version
    , init = init
    , update = update
    , subscriptions = subscriptions
    , preview = preview
    , about =
        [ Message.view
            [ Message.html
                [ text "Looking for a group of buttons where only one button is selectable at a time? Check out "
                , ClickableText.link "RadioButtonDotless"
                    [ ClickableText.href (Routes.exampleHref RadioButtonDotlessExample.example)
                    , ClickableText.appearsInline
                    ]
                ]
            ]
        ]
    , view = view
    , categories = [ Inputs ]
    , keyboardSupport =
        [ { keys = [ Arrow Left ]
          , result = "Move the focus & select the previous radio button "
          }
        , { keys = [ Arrow Up ]
          , result = "Move the focus & select the previous radio button "
          }
        , { keys = [ Arrow Right ]
          , result = "Move the focus & select the next radio button"
          }
        , { keys = [ Arrow Down ]
          , result = "Move the focus & select the next radio button"
          }
        , { keys = [ Space ]
          , result = "Select the current radio button if none are selected"
          }
        ]
    }


preview : List (Html Never)
preview =
    let
        selectedValue =
            Just "Selected"
    in
    [ RadioButton.view
        { label = "Unselected"
        , name = "preview-radio-inputs"
        , value = "Unselected"
        , selectedValue = selectedValue
        , valueToString = identity
        }
        [ RadioButton.custom [ Key.tabbable False ] ]
    , RadioButton.view
        { label = "Selected"
        , name = "preview-radio-inputs"
        , value = "Selected"
        , selectedValue = selectedValue
        , valueToString = identity
        }
        [ RadioButton.custom [ Key.tabbable False ] ]
    , RadioButton.view
        { label = "Premium"
        , name = "preview-radio-inputs"
        , value = "Premium"
        , selectedValue = selectedValue
        , valueToString = identity
        }
        [ RadioButton.custom [ Key.tabbable False ]
        , RadioButton.premium PremiumDisplay.PremiumLocked
        ]
    ]


{-| -}
view : EllieLink.Config -> State -> List (Html Msg)
view ellieLinkConfig state =
    let
        selectionSettings =
            Control.currentValue state.selectionSettings
    in
    [ ControlView.view
        { ellieLinkConfig = ellieLinkConfig
        , name = moduleName
        , version = version
        , update = SetSelectionSettings
        , settings = state.selectionSettings
        , mainType = Nothing
        , extraCode =
            [ Code.newlines
            , Code.unionType "Animals" [ "Dogs", "Cats", "Rabbits" ]
            , Code.newlines
            , "toString : Animals -> String"
            , "toString animals ="
                ++ Code.caseExpression "animals"
                    [ ( "Dogs", Code.string selectionSettings.dogsLabel )
                    , ( "Cats", Code.string selectionSettings.catsLabel )
                    , ( "Rabbits", Code.string selectionSettings.rabbitsLabel )
                    ]
                    1
            ]
        , renderExample = Code.unstyledView
        , toExampleCode =
            \_ ->
                [ { sectionName = "Example"
                  , code = viewExamplesCode selectionSettings state.selectedValue
                  }
                ]
        }
    , Heading.h2
        [ Heading.plaintext "Customizable Example"
        , Heading.css [ Css.marginTop Spacing.verticalSpacerPx ]
        ]
    , viewExamples selectionSettings state.selectedValue
    , Heading.h2
        [ Heading.plaintext "State & Premium Display Examples"
        , Heading.css [ Css.marginTop (Css.px 30) ]
        ]
    , Table.view []
        [ Table.string
            { header = "State"
            , value = .name
            , width = Css.px 10
            , cellStyles = always [ Css.padding2 (Css.px 14) (Css.px 7), Css.verticalAlign Css.middle, Css.fontWeight Css.bold ]
            , sort = Nothing
            }
        , Table.string
            { header = "Premium Display"
            , value = .premiumDisplay >> Debug.toString
            , width = Css.px 10
            , cellStyles = always [ Css.padding2 (Css.px 14) (Css.px 7), Css.verticalAlign Css.middle, Css.fontWeight Css.bold ]
            , sort = Nothing
            }
        , Table.custom
            { header = text "Enabled"
            , view =
                \{ name, selectedValue, premiumDisplay } ->
                    RadioButton.view
                        { label = "Include pandas"
                        , name = safeIdWithPrefix ("enabled-" ++ Debug.toString premiumDisplay) name
                        , value = ()
                        , selectedValue = selectedValue
                        , valueToString = \_ -> ""
                        }
                        [ RadioButton.premium premiumDisplay ]
            , width = Css.px 150
            , cellStyles = always [ Css.padding2 (Css.px 14) (Css.px 7), Css.verticalAlign Css.middle ]
            , sort = Nothing
            }
        , Table.custom
            { header = text "Disabled"
            , view =
                \{ name, selectedValue, premiumDisplay } ->
                    RadioButton.view
                        { label = "Include pandas"
                        , name = safeIdWithPrefix ("disabled-" ++ Debug.toString premiumDisplay) name
                        , value = ()
                        , selectedValue = selectedValue
                        , valueToString = \_ -> ""
                        }
                        [ RadioButton.disabled, RadioButton.premium premiumDisplay ]
            , width = Css.px 150
            , cellStyles = always [ Css.padding2 (Css.px 14) (Css.px 7), Css.verticalAlign Css.middle ]
            , sort = Nothing
            }
        ]
        [ { name = "Deselected"
          , selectedValue = Nothing
          , premiumDisplay = Free
          }
        , { name = "Selected"
          , selectedValue = Just ()
          , premiumDisplay = Free
          }
        , { name = "Deselected"
          , selectedValue = Nothing
          , premiumDisplay = PremiumUnlocked
          }
        , { name = "Selected"
          , selectedValue = Just ()
          , premiumDisplay = PremiumUnlocked
          }
        , { name = "Deselected"
          , selectedValue = Nothing
          , premiumDisplay = PremiumVouchered
          }
        , { name = "Selected"
          , selectedValue = Just ()
          , premiumDisplay = PremiumVouchered
          }
        , { name = "Deselected"
          , selectedValue = Nothing
          , premiumDisplay = PremiumLocked
          }
        , { name = "Selected"
          , selectedValue = Just ()
          , premiumDisplay = PremiumLocked
          }
        ]
    , Heading.h2
        [ Heading.plaintext "Guidance Examples"
        , Heading.css [ Css.marginTop (Css.px 30) ]
        ]
    , Table.view []
        [ Table.custom
            { header = text "Attribute"
            , view = .name >> text
            , width = Css.pct 10
            , cellStyles =
                always
                    [ Css.padding2 (Css.px 14) (Css.px 7)
                    , Css.verticalAlign Css.middle
                    , Css.fontWeight Css.bold
                    ]
            , sort = Nothing
            }
        , Table.custom
            { header = text "Example"
            , view =
                \{ name, attribute } ->
                    RadioButton.view
                        { label = "No default integration"
                        , name = safeIdWithPrefix "default-integration" name
                        , value = ()
                        , selectedValue = Nothing
                        , valueToString = \_ -> ""
                        }
                        [ attribute ]
            , width = Css.pct 50
            , cellStyles = always [ Css.padding2 (Css.px 14) (Css.px 7), Css.verticalAlign Css.middle ]
            , sort = Nothing
            }
        ]
        [ { name = "guidance"
          , attribute = RadioButton.guidance "Teachers will be able to use any integration."
          }
        , { name = "guidanceHtml"
          , attribute =
                RadioButton.guidanceHtml
                    [ text "Teachers will be able to use any "
                    , ClickableText.link "LMS supported by NoRedInk"
                        [ ClickableText.linkExternal "https://noredink.zendesk.com/hc/en-us/categories/6424228197403-Integrations"
                        , ClickableText.small
                        , ClickableText.appearsInline
                        ]
                    , text "."
                    ]
          }
        ]
    , Modal.view
        { title = "Go Premium!"
        , wrapMsg = ModalMsg
        , content = [ Text.mediumBody [ Text.plaintext "Often, we'll launch a modal showing the benefits of premium when a Premium pennant is clicked." ] ]
        , footer =
            [ Button.button "Okay"
                [ Button.modal
                , Button.onClick CloseModal
                , Button.id "close-premium-modal"
                ]
            ]
        , focus = Focus
        , firstId = Modal.closeButtonId
        , lastId = "close-premium-modal"
        }
        [ Modal.closeButton ]
        state.modal
    , Heading.h2
        [ Heading.plaintext "Tooltip Example"
        , Heading.css [ Css.marginTop Spacing.verticalSpacerPx ]
        ]
    , div []
        [ RadioButton.view
            { label = "Dogs"
            , name = "pets-2"
            , value = Dogs
            , selectedValue = state.selectedValue2
            , valueToString = selectionToString selectionSettings
            }
            [ RadioButton.onSelect Select2 ]
        , RadioButton.view
            { label = "Cats"
            , name = "pets-2"
            , value = Cats
            , selectedValue = state.selectedValue2
            , valueToString = selectionToString selectionSettings
            }
            [ RadioButton.onSelect Select2 ]
        , Tooltip.view
            { trigger =
                \attrs ->
                    RadioButton.view
                        { label = "Rabbits"
                        , name = "pets-2"
                        , value = Rabbits
                        , selectedValue = state.selectedValue2
                        , valueToString = selectionToString selectionSettings
                        }
                        [ RadioButton.disabled, RadioButton.custom attrs ]
            , id = "tooltip"
            }
            [ Tooltip.helpfullyDisabled
            , Tooltip.open (state.openTooltip == Just HelpfullyDisabled)
            , Tooltip.onToggle (ToggleTooltip HelpfullyDisabled)
            , Tooltip.paragraph "Reasons why you can't select this option"
            , Tooltip.onRight
            , Tooltip.fitToContent
            ]
        ]
    ]


viewExamplesCode : SelectionSettings -> Maybe Selection -> String
viewExamplesCode selectionSettings selectedValue =
    let
        toExampleCode ( kind, settings ) =
            Code.fromModule "RadioButton" "view"
                ++ Code.recordMultiline
                    [ ( "label", (selectionToString selectionSettings >> Code.string) kind )
                    , ( "name", Code.string "pets" )
                    , ( "value", selectionToString selectionSettings kind )
                    , ( "selectedValue"
                      , Code.maybe (Maybe.map (selectionToString selectionSettings) selectedValue)
                      )
                    , ( "valueToString", "toString" )
                    ]
                    2
                ++ Code.listMultiline (List.map Tuple.first settings) 2
    in
    "div []" ++ Code.listMultiline (List.map toExampleCode (examples selectionSettings)) 1


viewExamples : SelectionSettings -> Maybe Selection -> Html Msg
viewExamples selectionSettings selectedValue =
    let
        viewExample_ ( kind, settings ) =
            RadioButton.view
                { label = selectionToString selectionSettings kind
                , name = "pets"
                , value = kind
                , selectedValue = selectedValue
                , valueToString = selectionToString selectionSettings
                }
                (RadioButton.onSelect Select :: List.map Tuple.second settings)
    in
    div [ css [ Css.flexBasis (Css.px 300) ] ]
        (List.map viewExample_ (examples selectionSettings))


examples :
    SelectionSettings
    -> List ( Selection, List ( String, RadioButton.Attribute Selection Msg ) )
examples selectionSettings =
    [ ( Dogs, selectionSettings.dogs )
    , ( Cats, selectionSettings.cats )
    , ( Rabbits, selectionSettings.rabbits )
    ]


type Selection
    = Dogs
    | Cats
    | Rabbits


selectionToString : SelectionSettings -> Selection -> String
selectionToString { dogsLabel, catsLabel, rabbitsLabel } selection =
    case selection of
        Dogs ->
            dogsLabel

        Cats ->
            catsLabel

        Rabbits ->
            rabbitsLabel


{-| -}
type alias State =
    { selectedValue : Maybe Selection
    , selectedValue2 : Maybe Selection
    , modal : Modal.Model
    , selectionSettings : Control SelectionSettings
    , openTooltip : Maybe TooltipType
    }


{-| -}
init : State
init =
    { selectedValue = Nothing
    , selectedValue2 = Nothing
    , modal = Modal.init
    , selectionSettings = initSelectionSettings
    , openTooltip = Nothing
    }


type alias SelectionSettings =
    { dogsLabel : String
    , dogs : List ( String, RadioButton.Attribute Selection Msg )
    , catsLabel : String
    , cats : List ( String, RadioButton.Attribute Selection Msg )
    , rabbitsLabel : String
    , rabbits : List ( String, RadioButton.Attribute Selection Msg )
    }


initSelectionSettings : Control SelectionSettings
initSelectionSettings =
    Control.record SelectionSettings
        |> Control.field "Dogs label" (Control.string "Dogs")
        |> Control.field "Dogs" controlAttributes
        |> Control.field "Cats label" (Control.string "Cats")
        |> Control.field "Cats" controlAttributes
        |> Control.field "Rabbits label" (Control.string "Rabbits")
        |> Control.field "Rabbits" controlAttributes


controlAttributes : Control (List ( String, RadioButton.Attribute Selection Msg ))
controlAttributes =
    Control.list
        |> ControlExtra.optionalListItem "visibility" labelVisibility
        |> ControlExtra.optionalListItem "status" disabledOrEnabled
        |> ControlExtra.optionalListItem "onLockedClick" onLockedClick
        |> ControlExtra.optionalListItem "premium"
            -- TODO: allow the teacher premium level to vary as well:
            (Control.map
                (\( premiumDisplay, pDisplay ) ->
                    ( "RadioButton.premium " ++ premiumDisplay, RadioButton.premium pDisplay )
                )
                premiumDisplay
            )
        |> ControlExtra.optionalListItem "containerCss"
            (Control.choice
                [ ( "max-width with border"
                  , Control.value
                        ( "RadioButton.containerCss [ Css.maxWidth (Css.px 200), Css.border3 (Css.px 1) Css.solid Colors.red ]"
                        , RadioButton.containerCss [ Css.maxWidth (Css.px 200), Css.border3 (Css.px 1) Css.solid Colors.red ]
                        )
                  )
                , ( "100% width"
                  , Control.value
                        ( "RadioButton.containerCss [ Css.width (Css.pct 100) ]"
                        , RadioButton.containerCss [ Css.width (Css.pct 100) ]
                        )
                  )
                , ( "10px right margin"
                  , Control.value
                        ( "RadioButton.containerCss [ Css.marginRight (Css.px 10) ]"
                        , RadioButton.containerCss [ Css.marginRight (Css.px 10) ]
                        )
                  )
                ]
            )
        |> ControlExtra.optionalListItem "labelCss"
            (Control.choice
                [ ( "backgroundColor highlightMagenta"
                  , Control.value
                        ( "RadioButton.labelCss [ Css.backgroundColor Colors.highlightMagenta ]"
                        , RadioButton.labelCss [ Css.backgroundColor Colors.highlightMagenta ]
                        )
                  )
                , ( "1px ochreDark border"
                  , Control.value
                        ( "RadioButton.labelCss [ Css.border3 (Css.px 1) Css.solid Colors.ochreDark ]"
                        , RadioButton.labelCss [ Css.border3 (Css.px 1) Css.solid Colors.ochreDark ]
                        )
                  )
                ]
            )
        |> ControlExtra.optionalListItem "disclosure" controlDisclosure
        |> CommonControls.guidanceAndErrorMessage
            { moduleName = moduleName
            , guidance = RadioButton.guidance
            , guidanceHtml = RadioButton.guidanceHtml
            , errorMessage = Just RadioButton.errorMessage
            , message = "The statement must be true."
            }
        |> CommonControls.rightIcon "RadioButton" RadioButton.rightIcon


labelVisibility : Control ( String, RadioButton.Attribute Selection Msg )
labelVisibility =
    Control.choice
        [ ( "hiddenLabel", Control.value ( "RadioButton.hiddenLabel", RadioButton.hiddenLabel ) )
        , ( "visibleLabel", Control.value ( "RadioButton.visibleLabel", RadioButton.visibleLabel ) )
        ]


disabledOrEnabled : Control ( String, RadioButton.Attribute Selection Msg )
disabledOrEnabled =
    Control.choice
        [ ( "disabled", Control.value ( "RadioButton.disabled", RadioButton.disabled ) )
        , ( "enabled", Control.value ( "RadioButton.enabled", RadioButton.enabled ) )
        ]


onLockedClick : Control ( String, RadioButton.Attribute Selection Msg )
onLockedClick =
    Control.value
        ( "RadioButton.onLockedClick OpenPremiumModal"
        , RadioButton.onLockedClick (OpenModal "dogs")
        )


controlDisclosure : Control ( String, RadioButton.Attribute Selection Msg )
controlDisclosure =
    Control.map
        (\content ->
            ( "RadioButton.disclosure [ Text.smallBody [ Text.plaintext \""
                ++ content
                ++ "\" ]"
            , RadioButton.disclosure [ Text.smallBody [ Text.plaintext content ] ]
            )
        )
        (Control.string "These pets occupy themselves.")


type Msg
    = OpenModal String
    | ModalMsg Modal.Msg
    | CloseModal
    | Select Selection
    | Select2 Selection
    | SetSelectionSettings (Control SelectionSettings)
    | Focus String
    | Focused (Result Dom.Error ())
    | ToggleTooltip TooltipType Bool


{-| -}
update : Msg -> State -> ( State, Cmd Msg )
update msg model =
    case msg of
        OpenModal returnFocusTo ->
            let
                ( modal, startFocusOn ) =
                    Modal.open
                        { startFocusOn = Modal.closeButtonId
                        , returnFocusTo = returnFocusTo
                        }
            in
            ( { model | modal = modal }
            , Task.attempt Focused (Dom.focus startFocusOn)
            )

        ModalMsg modalMsg ->
            let
                ( modal, maybeFocus ) =
                    Modal.update { dismissOnEscAndOverlayClick = True }
                        modalMsg
                        model.modal
            in
            ( { model | modal = modal }
            , Maybe.map (Task.attempt Focused << Dom.focus) maybeFocus
                |> Maybe.withDefault Cmd.none
            )

        CloseModal ->
            let
                ( modal, maybeFocus ) =
                    Modal.close model.modal
            in
            ( { model | modal = modal }
            , Maybe.map (Task.attempt Focused << Dom.focus) maybeFocus
                |> Maybe.withDefault Cmd.none
            )

        Select value ->
            ( { model | selectedValue = Just value }, Cmd.none )

        Select2 value ->
            ( { model | selectedValue2 = Just value }, Cmd.none )

        SetSelectionSettings selectionSettings ->
            ( { model | selectionSettings = selectionSettings }
            , Cmd.none
            )

        Focus focus ->
            ( model, Task.attempt Focused (Dom.focus focus) )

        Focused _ ->
            ( model, Cmd.none )

        ToggleTooltip type_ isOpen ->
            if isOpen then
                ( { model | openTooltip = Just type_ }, Cmd.none )

            else
                ( { model | openTooltip = Nothing }, Cmd.none )


subscriptions : State -> Sub Msg
subscriptions { modal } =
    Sub.map ModalMsg (Modal.subscriptions modal)
