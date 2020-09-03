module Examples.Tooltip exposing (example, State, Msg)

{-|

@docs example, State, Msg

-}

import Accessibility.Styled as Html
import AtomicDesignType exposing (AtomicDesignType(..))
import Category exposing (Category(..))
import Css
import Example exposing (Example)
import Html.Styled.Attributes exposing (css, href)
import KeyboardSupport exposing (Direction(..), Key(..))
import Nri.Ui.Heading.V2 as Heading
import Nri.Ui.Text.V4 as Text
import Nri.Ui.Tooltip.V2 as Tooltip


type TooltipType
    = PrimaryLabelOnClick
    | PrimaryLabelOnHover
    | AuxillaryDescription
    | ToggleTipTop
    | ToggleTipRight
    | ToggleTipBottom
    | ToggleTipLeft


type alias State =
    { openTooltip : Maybe TooltipType
    }


init : State
init =
    { openTooltip = Nothing }


type Msg
    = ToggleTooltip TooltipType Bool


update : Msg -> State -> ( State, Cmd Msg )
update msg model =
    case msg of
        ToggleTooltip type_ isOpen ->
            if isOpen then
                ( { model | openTooltip = Just type_ }, Cmd.none )

            else
                ( { model | openTooltip = Nothing }, Cmd.none )


example : Example State Msg
example =
    { name = "Nri.Ui.Tooltip.V2"
    , categories = [ Widgets ]
    , atomicDesignType = Molecule
    , keyboardSupport = []
    , state = init
    , update = update
    , subscriptions = \_ -> Sub.none
    , view =
        \model ->
            [ Text.mediumBody [ Html.text "These tooltips look similar, but serve different purposes when reading them via a screen-reader." ]
            , Heading.h3 [] [ Html.text "primaryLabel" ]
            , Text.smallBody
                [ Html.text "A primary label is used when the tooltip content serves as the main label for its trigger content"
                , Html.br []
                , Html.text "e.g. when the trigger content is an icon with no text."
                ]
            , Tooltip.view
                { triggerHtml = Html.text "Primary Label - OnClick Trigger"
                , id = "primary label tooltip"
                }
                [ Tooltip.plaintext "Tooltip"
                , Tooltip.primaryLabel
                , Tooltip.onClick (ToggleTooltip PrimaryLabelOnClick)
                , Tooltip.open (model.openTooltip == Just PrimaryLabelOnClick)
                ]
            , Html.br [ css [ Css.marginBottom (Css.px 20) ] ]
            , Tooltip.view
                { triggerHtml = Html.text "Primary Label - OnHover Trigger"
                , id = "primary label tooltip"
                }
                [ Tooltip.plaintext "Tooltip"
                , Tooltip.primaryLabel
                , Tooltip.onHover (ToggleTooltip PrimaryLabelOnHover)
                , Tooltip.open (model.openTooltip == Just PrimaryLabelOnHover)
                ]
            , Html.br [ css [ Css.marginBottom (Css.px 20) ] ]
            , Heading.h3 [] [ Html.text "auxillaryDescription" ]
            , Text.smallBody
                [ Html.text "An auxillary description is used when the tooltip content provides supplementary information about its trigger content"
                , Html.br []
                , Html.text "e.g. when the trigger content is a word in the middle of a body of text that requires additional explanation."
                ]
            , Tooltip.view
                { triggerHtml = Html.text "Auxillary Description Trigger"
                , id = "Auxillary description"
                }
                [ Tooltip.plaintext "Tooltip"
                , Tooltip.onClick (ToggleTooltip AuxillaryDescription)
                , Tooltip.auxillaryDescription
                , Tooltip.open (model.openTooltip == Just AuxillaryDescription)
                ]
            , Html.br [ css [ Css.marginBottom (Css.px 20) ] ]
            , Heading.h3 [] [ Html.text "toggleTip" ]
            , Text.smallBody [ Html.text "A Toggle Tip is triggered by the \"?\" icon and provides supplemental information for the page." ]
            , Html.div [ css [ Css.displayFlex, Css.alignItems Css.center ] ]
                [ Tooltip.toggleTip
                    { label = "More info"
                    }
                    [ Tooltip.html
                        [ Html.text "Tooltip On Top! "
                        , Html.a [ href "/" ] [ Html.text "Links work!" ]
                        ]
                    , Tooltip.onHover (ToggleTooltip ToggleTipTop)
                    , Tooltip.open (model.openTooltip == Just ToggleTipTop)
                    ]
                , Text.mediumBody
                    [ Html.text "This toggletip will open on top"
                    ]
                ]
            , Html.div [ css [ Css.displayFlex, Css.alignItems Css.center ] ]
                [ Tooltip.toggleTip
                    { label = "More info"
                    }
                    [ Tooltip.html
                        [ Html.text "Tooltip On Left! "
                        , Html.a [ href "/" ] [ Html.text "Links work!" ]
                        ]
                    , Tooltip.onLeft
                    , Tooltip.onHover (ToggleTooltip ToggleTipLeft)
                    , Tooltip.open (model.openTooltip == Just ToggleTipLeft)
                    ]
                , Text.mediumBody
                    [ Html.text "This toggletip will open on the left"
                    ]
                ]
            ]
    }
