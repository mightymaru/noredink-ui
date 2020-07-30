module Nri.RadioButton exposing (view, premium)

{-|

@docs view, premium

-}

import Accessibility.Styled exposing (..)
import Accessibility.Styled.Aria as Aria
import Accessibility.Styled.Role as Role
import Accessibility.Styled.Style as Style
import Accessibility.Styled.Widget as Widget
import Css exposing (..)
import Data.PremiumLevel as PremiumLevel exposing (PremiumLevel)
import Html.Styled as Html
import Html.Styled.Attributes exposing (..)
import Html.Styled.Attributes.Extra as Attributes
import Html.Styled.Events exposing (onClick, stopPropagationOn)
import Html.Styled.Events.Extra exposing (onEnterAndSpacePreventDefault)
import Html.Styled.Extra exposing (viewIf)
import Json.Decode
import Nri.Ui.ClickableSvg.V1 as ClickableSvg
import Nri.Ui.Colors.V1 as Colors
import Nri.Ui.Fonts.V1 as Fonts
import Nri.Ui.Pennant.V2 as Pennant
import Nri.Ui.Svg.V1 exposing (Svg, fromHtml)
import Svg.Styled as Svg
import Svg.Styled.Attributes as SvgAttributes
import Util


{-| View a single radio button.
If used in a group, all radio buttons in the group should have the same name attribute.
-}
view :
    { label : String
    , value : a
    , name : String
    , selectedValue : Maybe a
    , onSelect : a -> msg
    , showLabel : Bool
    , noOpMsg : msg
    , valueToString : a -> String
    }
    -> Html msg
view config =
    internalView
        { label = config.label
        , value = config.value
        , name = config.name
        , selectedValue = config.selectedValue
        , showLabel = config.showLabel
        , isLocked = False
        , isDisabled = False
        , onSelect = config.onSelect
        , premiumMsg = config.noOpMsg
        , noOpMsg = config.noOpMsg
        , valueToString = config.valueToString
        , showPennant = False
        }


{-| A radio button that should be used for premium content.

This radio button is locked when the premium level of the content
is greater than the premium level of the teacher.

  - `onChange`: A message for when the user selected the radio button
  - `onLockedClick`: A message for when the user clicks a radio button they don't have PremiumLevel for.
    If you get this message, you should show an `Nri.Premium.Model.view`

-}
premium :
    { label : String
    , value : a
    , name : String
    , selectedValue : Maybe a
    , teacherPremiumLevel : PremiumLevel
    , contentPremiumLevel : PremiumLevel
    , onSelect : a -> msg
    , premiumMsg : msg
    , noOpMsg : msg
    , valueToString : a -> String
    , showPennant : Bool
    , isDisabled : Bool
    }
    -> Html msg
premium config =
    let
        isLocked =
            not <|
                PremiumLevel.allowedFor
                    config.contentPremiumLevel
                    config.teacherPremiumLevel
    in
    internalView
        { label = config.label
        , value = config.value
        , name = config.name
        , selectedValue = config.selectedValue
        , isLocked = isLocked
        , isDisabled = config.isDisabled
        , onSelect = config.onSelect
        , showLabel = True
        , valueToString = config.valueToString
        , premiumMsg = config.premiumMsg
        , noOpMsg = config.noOpMsg
        , showPennant = config.showPennant && PremiumLevel.isPremium config.contentPremiumLevel
        }


type alias InternalConfig a msg =
    { label : String
    , value : a
    , name : String
    , selectedValue : Maybe a
    , isLocked : Bool
    , isDisabled : Bool
    , onSelect : a -> msg
    , showLabel : Bool
    , premiumMsg : msg
    , noOpMsg : msg
    , valueToString : a -> String
    , showPennant : Bool
    }


internalView : InternalConfig a msg -> Html msg
internalView config =
    let
        isChecked =
            config.selectedValue == Just config.value

        id_ =
            config.name ++ "-" ++ Util.dashify (config.valueToString config.value)

        onContainerClick =
            if config.isLocked then
                config.premiumMsg

            else
                config.noOpMsg
    in
    Html.span
        [ -- This is necessary to prevent event propagation.
          -- See https://github.com/elm-lang/html/issues/96
          Html.Styled.Attributes.map (always onContainerClick) <|
            stopPropagationOn "click"
                (Json.Decode.succeed ( "stop click propagation", True ))
        , id (id_ ++ "-container")
        , classList [ ( "Nri-RadioButton-PremiumClass", config.showPennant ) ]
        ]
        [ radio config.name
            (config.valueToString config.value)
            isChecked
            [ id id_
            , Html.Styled.Attributes.disabled config.isLocked
            , if not config.isDisabled then
                onClick (config.onSelect config.value)

              else
                Attributes.none
            , class "Nri-RadioButton-HiddenRadioInput"
            , css [ display none ]
            ]
        , Html.label
            [ for id_
            , Widget.disabled config.isLocked
            , Role.radio
            , Widget.checked (Just isChecked)
            , Aria.controls id_
            , if not config.isLocked then
                tabindex 0

              else
                Attributes.none
            , if not config.isLocked && not config.isDisabled then
                onEnterAndSpacePreventDefault (config.onSelect config.value)

              else
                Attributes.none
            , classList
                [ ( "Nri-RadioButton-RadioButton", True )
                , ( "Nri-RadioButton-RadioButtonChecked", isChecked )
                ]
            , css
                [ if not config.showLabel then
                    -- Invisible label styles
                    Css.batch
                        [ Css.height (px 28) -- Hardcode height for invisible labels so radio button image appears- normally, label height is set by the text
                        , padding4 (px 4) zero (px 4) (px 28)
                        ]

                  else
                    padding4 (px 4) zero (px 4) (px 40)
                , if config.isDisabled then
                    Css.batch
                        [ color Colors.gray45
                        , cursor notAllowed
                        ]

                  else
                    cursor pointer
                , fontSize (px 15)
                , Fonts.baseFont
                , Css.property "font-weight" "600"
                , position relative
                , outline none
                , margin zero
                , display inlineBlock
                , color Colors.navy
                ]
            ]
            [ radioInputIcon
                { isLocked = config.isLocked
                , isDisabled = config.isDisabled
                , isChecked = isChecked
                }
            , span
                (case ( config.showLabel, config.showPennant ) of
                    ( False, _ ) ->
                        Style.invisible

                    ( True, False ) ->
                        []

                    ( True, True ) ->
                        [ css
                            [ displayFlex
                            , alignItems center
                            , Css.height (px 20)
                            ]
                        ]
                )
                [ Html.text config.label
                , viewIf
                    (\() ->
                        ClickableSvg.button "Premium"
                            Pennant.premiumFlag
                            [ ClickableSvg.onClick config.premiumMsg
                            , ClickableSvg.width (px 26)
                            , ClickableSvg.height (px 24)
                            , ClickableSvg.css [ marginLeft (px 8) ]
                            ]
                    )
                    config.showPennant
                ]
            ]
        ]


radioInputIcon :
    { isChecked : Bool
    , isLocked : Bool
    , isDisabled : Bool
    }
    -> Html msg
radioInputIcon config =
    let
        image =
            case ( config.isDisabled, config.isLocked, config.isChecked ) of
                ( _, True, _ ) ->
                    lockedSvg

                ( True, _, _ ) ->
                    unselectedSvg

                ( _, False, True ) ->
                    selectedSvg

                ( _, False, False ) ->
                    unselectedSvg
    in
    div
        [ classList
            [ ( "Nri-RadioButton-RadioButtonIcon", True )
            , ( "Nri-RadioButton-RadioButtonDisabled", config.isDisabled )
            ]
        , css
            [ Css.batch <|
                if config.isDisabled then
                    [ opacity (num 0.4) ]

                else
                    []
            , position absolute
            , left zero
            , top zero
            , Css.width (px 30)
            , Css.height (px 30)
            , Css.property "transition" ".3s all"
            ]
        ]
        [ Nri.Ui.Svg.V1.toHtml image ]


unselectedSvg : Svg
unselectedSvg =
    Svg.svg [ SvgAttributes.viewBox "0 0 27 27" ]
        [ Svg.defs []
            [ Svg.rect [ SvgAttributes.id "unselected-path-1", SvgAttributes.x "0", SvgAttributes.y "0", SvgAttributes.width "27", SvgAttributes.height "27", SvgAttributes.rx "13.5" ] []
            , Svg.filter [ SvgAttributes.id "unselected-filter-2", SvgAttributes.x "-3.7%", SvgAttributes.y "-3.7%", SvgAttributes.width "107.4%", SvgAttributes.height "107.4%", SvgAttributes.filterUnits "objectBoundingBox" ] [ Svg.feOffset [ SvgAttributes.dx "0", SvgAttributes.dy "2", SvgAttributes.in_ "SourceAlpha", SvgAttributes.result "shadowOffsetInner1" ] [], Svg.feComposite [ SvgAttributes.in_ "shadowOffsetInner1", SvgAttributes.in2 "SourceAlpha", SvgAttributes.operator "arithmetic", SvgAttributes.k2 "-1", SvgAttributes.k3 "1", SvgAttributes.result "shadowInnerInner1" ] [], Svg.feColorMatrix [ SvgAttributes.values "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.1 0", SvgAttributes.in_ "shadowInnerInner1" ] [] ]
            ]
        , Svg.g
            [ SvgAttributes.stroke "none"
            , SvgAttributes.strokeWidth "1"
            , SvgAttributes.fill "none"
            , SvgAttributes.fillRule "evenodd"
            ]
            [ Svg.g []
                [ Svg.g []
                    [ Svg.use
                        [ SvgAttributes.fill "#EBEBEB"
                        , SvgAttributes.fillRule "evenodd"
                        , SvgAttributes.xlinkHref "#unselected-path-1"
                        ]
                        []
                    , Svg.use
                        [ SvgAttributes.fill "black"
                        , SvgAttributes.fillOpacity "1"
                        , SvgAttributes.filter "url(#unselected-filter-2)"
                        , SvgAttributes.xlinkHref "#unselected-path-1"
                        ]
                        []
                    ]
                ]
            ]
        ]
        |> Nri.Ui.Svg.V1.fromHtml


selectedSvg : Svg
selectedSvg =
    Svg.svg [ SvgAttributes.viewBox "0 0 27 27" ]
        [ Svg.defs []
            [ Svg.rect [ SvgAttributes.id "selected-path-1", SvgAttributes.x "0", SvgAttributes.y "0", SvgAttributes.width "27", SvgAttributes.height "27", SvgAttributes.rx "13.5" ] []
            , Svg.filter
                [ SvgAttributes.id "selected-filter-2", SvgAttributes.x "-3.7%", SvgAttributes.y "-3.7%", SvgAttributes.width "107.4%", SvgAttributes.height "107.4%", SvgAttributes.filterUnits "objectBoundingBox" ]
                [ Svg.feOffset [ SvgAttributes.dx "0", SvgAttributes.dy "2", SvgAttributes.in_ "SourceAlpha", SvgAttributes.result "shadowOffsetInner1" ] [], Svg.feComposite [ SvgAttributes.in_ "shadowOffsetInner1", SvgAttributes.in2 "SourceAlpha", SvgAttributes.operator "arithmetic", SvgAttributes.k2 "-1", SvgAttributes.k3 "1", SvgAttributes.result "shadowInnerInner1" ] [], Svg.feColorMatrix [ SvgAttributes.values "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.1 0", SvgAttributes.in_ "shadowInnerInner1" ] [] ]
            ]
        , Svg.g
            [ SvgAttributes.stroke "none"
            , SvgAttributes.strokeWidth "1"
            , SvgAttributes.fill "none"
            , SvgAttributes.fillRule "evenodd"
            ]
            [ Svg.g []
                [ Svg.g []
                    [ Svg.use
                        [ SvgAttributes.fill "#D4F0FF"
                        , SvgAttributes.fillRule "evenodd"
                        , SvgAttributes.xlinkHref "#selected-path-1"
                        ]
                        []
                    , Svg.use
                        [ SvgAttributes.fill "black"
                        , SvgAttributes.fillOpacity "1"
                        , SvgAttributes.filter "url(#selected-filter-2)"
                        , SvgAttributes.xlinkHref "#selected-path-1"
                        ]
                        []
                    ]
                , Svg.circle
                    [ SvgAttributes.fill "#146AFF"
                    , SvgAttributes.cx "13.5"
                    , SvgAttributes.cy "13.5"
                    , SvgAttributes.r "6.3"
                    ]
                    []
                ]
            ]
        ]
        |> Nri.Ui.Svg.V1.fromHtml


lockedSvg : Svg
lockedSvg =
    Svg.svg [ SvgAttributes.viewBox "0 0 30 30" ]
        [ Svg.defs []
            [ Svg.rect [ SvgAttributes.id "locked-path-1", SvgAttributes.x "0", SvgAttributes.y "0", SvgAttributes.width "30", SvgAttributes.height "30", SvgAttributes.rx "15" ] []
            , Svg.filter [ SvgAttributes.id "locked-filter-2", SvgAttributes.x "-3.3%", SvgAttributes.y "-3.3%", SvgAttributes.width "106.7%", SvgAttributes.height "106.7%", SvgAttributes.filterUnits "objectBoundingBox" ] [ Svg.feOffset [ SvgAttributes.dx "0", SvgAttributes.dy "2", SvgAttributes.in_ "SourceAlpha", SvgAttributes.result "shadowOffsetInner1" ] [], Svg.feComposite [ SvgAttributes.in_ "shadowOffsetInner1", SvgAttributes.in2 "SourceAlpha", SvgAttributes.operator "arithmetic", SvgAttributes.k2 "-1", SvgAttributes.k3 "1", SvgAttributes.result "shadowInnerInner1" ] [], Svg.feColorMatrix [ SvgAttributes.values "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.1 0", SvgAttributes.in_ "shadowInnerInner1" ] [] ]
            ]
        , Svg.g
            [ SvgAttributes.stroke "none"
            , SvgAttributes.strokeWidth "1"
            , SvgAttributes.fill "none"
            , SvgAttributes.fillRule "evenodd"
            ]
            [ Svg.g []
                [ Svg.use
                    [ SvgAttributes.fill "#EBEBEB"
                    , SvgAttributes.fillRule "evenodd"
                    , SvgAttributes.xlinkHref "#locked-path-1"
                    ]
                    []
                , Svg.use
                    [ SvgAttributes.fill "black"
                    , SvgAttributes.fillOpacity "1"
                    , SvgAttributes.filter "url(#locked-filter-2)"
                    , SvgAttributes.xlinkHref "#locked-path-1"
                    ]
                    []
                ]
            , Svg.g
                [ SvgAttributes.transform "translate(8.000000, 5.000000)"
                ]
                [ Svg.path
                    [ SvgAttributes.d "M11.7991616,9.36211885 L11.7991616,5.99470414 C11.7991616,3.24052783 9.64616757,1 7.00011784,1 C4.35359674,1 2.20083837,3.24052783 2.20083837,5.99470414 L2.20083837,9.36211885 L1.51499133,9.36211885 C0.678540765,9.36211885 -6.21724894e-14,10.0675883 -6.21724894e-14,10.9381415 L-6.21724894e-14,18.9239773 C-6.21724894e-14,19.7945305 0.678540765,20.5 1.51499133,20.5 L12.48548,20.5 C13.3219306,20.5 14,19.7945305 14,18.9239773 L14,10.9383868 C14,10.0678336 13.3219306,9.36211885 12.48548,9.36211885 L11.7991616,9.36211885 Z M7.46324136,15.4263108 L7.46324136,17.2991408 C7.46324136,17.5657769 7.25560176,17.7816368 7.00011784,17.7816368 C6.74416256,17.7816368 6.53652295,17.5657769 6.53652295,17.2991408 L6.53652295,15.4263108 C6.01259238,15.228848 5.63761553,14.7080859 5.63761553,14.0943569 C5.63761553,13.3116195 6.24757159,12.6763045 7.00011784,12.6763045 C7.75195704,12.6763045 8.36285584,13.3116195 8.36285584,14.0943569 C8.36285584,14.7088218 7.98717193,15.2295839 7.46324136,15.4263108 L7.46324136,15.4263108 Z M9.98178482,9.36211885 L4.01821518,9.36211885 L4.01821518,5.99470414 C4.01821518,4.2835237 5.35597044,2.89122723 7.00011784,2.89122723 C8.64402956,2.89122723 9.98178482,4.2835237 9.98178482,5.99470414 L9.98178482,9.36211885 L9.98178482,9.36211885 Z"
                    , SvgAttributes.fill "#E68800"
                    ]
                    []
                , Svg.path
                    [ SvgAttributes.d "M11.7991616,8.14770554 L11.7991616,4.8666348 C11.7991616,2.18307839 9.64616757,-7.10542736e-15 7.00011784,-7.10542736e-15 C4.35359674,-7.10542736e-15 2.20083837,2.18307839 2.20083837,4.8666348 L2.20083837,8.14770554 L1.51499133,8.14770554 C0.678540765,8.14770554 -6.21724894e-14,8.83508604 -6.21724894e-14,9.6833174 L-6.21724894e-14,17.4643881 C-6.21724894e-14,18.3126195 0.678540765,19 1.51499133,19 L12.48548,19 C13.3219306,19 14,18.3126195 14,17.4643881 L14,9.68355641 C14,8.83532505 13.3219306,8.14770554 12.48548,8.14770554 L11.7991616,8.14770554 Z M7.46324136,14.0564054 L7.46324136,15.8812141 C7.46324136,16.1410134 7.25560176,16.3513384 7.00011784,16.3513384 C6.74416256,16.3513384 6.53652295,16.1410134 6.53652295,15.8812141 L6.53652295,14.0564054 C6.01259238,13.8640057 5.63761553,13.3565966 5.63761553,12.7586042 C5.63761553,11.9959369 6.24757159,11.376912 7.00011784,11.376912 C7.75195704,11.376912 8.36285584,11.9959369 8.36285584,12.7586042 C8.36285584,13.3573136 7.98717193,13.8647228 7.46324136,14.0564054 L7.46324136,14.0564054 Z M9.98178482,8.14770554 L4.01821518,8.14770554 L4.01821518,4.8666348 C4.01821518,3.19933078 5.35597044,1.84273423 7.00011784,1.84273423 C8.64402956,1.84273423 9.98178482,3.19933078 9.98178482,4.8666348 L9.98178482,8.14770554 L9.98178482,8.14770554 Z"
                    , SvgAttributes.fill "#FEC709"
                    ]
                    []
                ]
            ]
        ]
        |> Nri.Ui.Svg.V1.fromHtml
