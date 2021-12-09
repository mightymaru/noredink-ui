module Nri.Ui.ClickableText.V3 exposing
    ( button
    , link
    , Attribute
    , small, medium, large, modal
    , onClick
    , href, linkSpa, linkExternal, linkWithMethod, linkWithTracking, linkExternalWithTracking
    , icon
    , custom, css, nriDescription, testId, id
    )

{-|


# Post-release patches

  - uses ClickableAttributes
  - adds `css` helper
  - removes underline on hover and recolors to azureDark
  - removes bottom border
  - adds `nriDescription`, `testId`, and `id` helpers
  - adds `modal` helper, for use in modal footers, same as applying large and Css.marginTop (Css.px 15)


# Changes from V2

  - Changes API to be attributes-based rather than config-based
  - Makes a hole for custom attributes (like ids and styles)


# About:

ClickableText looks different from Nri.Ui.Button in that it displays without margin or padding.
ClickableText has the suave, traditional look of a "link"!

For accessibility purposes, buttons that perform an action on the current page should be HTML `<button>`
elements and are created here with `*Button` functions. Buttons that take the user to a new page should be
HTML `<a>` elements and are created here with `*Link` functions.


# `<button>` creators

@docs button


# `<a>` creators

@docs link


# Attributes

@docs Attribute


## Sizing

@docs small, medium, large, modal


## Behavior

@docs onClick
@docs href, linkSpa, linkExternal, linkWithMethod, linkWithTracking, linkExternalWithTracking

@docs icon
@docs custom, css, nriDescription, testId, id

-}

import ClickableAttributes exposing (ClickableAttributes)
import Css exposing (Style)
import Html.Styled as Html exposing (..)
import Html.Styled.Attributes as Attributes
import Nri.Ui
import Nri.Ui.Colors.V1 as Colors
import Nri.Ui.Fonts.V1
import Nri.Ui.Html.Attributes.V2 as ExtraAttributes
import Nri.Ui.Svg.V1 as NriSvg exposing (Svg)


label : String -> Attribute msg
label label_ =
    set (\attributes -> { attributes | label = label_ })


{-| -}
small : Attribute msg
small =
    set (\attributes -> { attributes | size = Small })


{-| -}
medium : Attribute msg
medium =
    set (\attributes -> { attributes | size = Medium })


{-| -}
large : Attribute msg
large =
    set (\attributes -> { attributes | size = Large })


{-| For use in Modal footers (adds `large` and `Css.marginTop (Css.px 15)`)
-}
modal : Attribute msg
modal =
    set
        (\attributes ->
            { attributes
                | size = Large
                , customStyles = List.append attributes.customStyles [ Css.marginTop (Css.px 15) ]
            }
        )


type Size
    = Small
    | Medium
    | Large


{-| -}
icon : Svg -> Attribute msg
icon icon_ =
    set (\attributes -> { attributes | icon = Just icon_ })


{-| Use this helper to add custom attributes.

Do NOT use this helper to add css styles, as they may not be applied the way
you want/expect if underlying Button styles change.
Instead, please use the `css` helper.

-}
custom : List (Html.Attribute msg) -> Attribute msg
custom attributes =
    set
        (\config ->
            { config
                | customAttributes = List.append config.customAttributes attributes
            }
        )


{-| -}
nriDescription : String -> Attribute msg
nriDescription description =
    custom [ ExtraAttributes.nriDescription description ]


{-| -}
testId : String -> Attribute msg
testId id_ =
    custom [ ExtraAttributes.testId id_ ]


{-| -}
id : String -> Attribute msg
id id_ =
    custom [ Attributes.id id_ ]


{-| -}
css : List Style -> Attribute msg
css styles =
    set
        (\config ->
            { config
                | customStyles = List.append config.customStyles styles
            }
        )



-- LINKING, CLICKING, and TRACKING BEHAVIOR


setClickableAttributes :
    (ClickableAttributes String msg -> ClickableAttributes String msg)
    -> Attribute msg
setClickableAttributes apply =
    set
        (\attributes ->
            { attributes | clickableAttributes = apply attributes.clickableAttributes }
        )


{-| -}
onClick : msg -> Attribute msg
onClick msg =
    setClickableAttributes (ClickableAttributes.onClick msg)


{-| -}
href : String -> Attribute msg
href url =
    setClickableAttributes (ClickableAttributes.href url)


{-| Use this link for routing within a single page app.

This will make a normal <a> tag, but change the Events.onClick behavior to avoid reloading the page.

See <https://github.com/elm-lang/html/issues/110> for details on this implementation.

-}
linkSpa : String -> Attribute msg
linkSpa url =
    setClickableAttributes (ClickableAttributes.linkSpa url)


{-| -}
linkWithMethod : { method : String, url : String } -> Attribute msg
linkWithMethod config =
    setClickableAttributes (ClickableAttributes.linkWithMethod config)


{-| -}
linkWithTracking : { track : msg, url : String } -> Attribute msg
linkWithTracking config =
    setClickableAttributes (ClickableAttributes.linkWithTracking config)


{-| -}
linkExternal : String -> Attribute msg
linkExternal url =
    setClickableAttributes (ClickableAttributes.linkExternal url)


{-| -}
linkExternalWithTracking : { track : msg, url : String } -> Attribute msg
linkExternalWithTracking config =
    setClickableAttributes (ClickableAttributes.linkExternalWithTracking config)


{-| Creates a `<button>` element
-}
button :
    String
    -> List (Attribute msg)
    -> Html msg
button label_ attributes =
    let
        config =
            (label label_ :: attributes)
                |> List.foldl (\(Attribute attribute) b -> attribute b) defaults
    in
    Nri.Ui.styled Html.button
        (dataDescriptor "button")
        (clickableTextStyles ++ config.customStyles)
        (ClickableAttributes.toButtonAttributes config.clickableAttributes
            ++ config.customAttributes
        )
        [ viewContent config ]


{-| Creates a `<a>` element
-}
link :
    String
    -> List (Attribute msg)
    -> Html msg
link label_ attributes =
    let
        config =
            (label label_ :: attributes)
                |> List.foldl (\(Attribute attribute) l -> attribute l) defaults

        ( name, clickableAttributes ) =
            ClickableAttributes.toLinkAttributes identity config.clickableAttributes
    in
    Nri.Ui.styled Html.a
        (dataDescriptor name)
        (clickableTextStyles ++ config.customStyles)
        (clickableAttributes ++ config.customAttributes)
        [ viewContent config ]


viewContent : { a | label : String, size : Size, icon : Maybe Svg } -> Html msg
viewContent config =
    let
        fontSize =
            sizeToPx config.size
    in
    span [ Attributes.css [ Css.fontSize fontSize ] ]
        (case config.icon of
            Just icon_ ->
                [ div
                    [ Attributes.css
                        [ Css.displayFlex
                        , Css.alignItems Css.center
                        , Css.property "line-height" "normal"
                        ]
                    ]
                    [ div
                        [ Attributes.css
                            [ Css.height fontSize
                            , Css.maxWidth fontSize
                            , Css.minWidth fontSize -- so it doesn't shrink when the label is long
                            , case config.size of
                                Small ->
                                    Css.marginRight (Css.px 3)

                                Medium ->
                                    Css.marginRight (Css.px 3)

                                Large ->
                                    Css.marginRight (Css.px 4)
                            ]
                        ]
                        [ NriSvg.toHtml icon_ ]
                    , span [] [ text config.label ]
                    ]
                ]

            Nothing ->
                [ text config.label ]
        )


clickableTextStyles : List Css.Style
clickableTextStyles =
    [ Css.cursor Css.pointer
    , Nri.Ui.Fonts.V1.baseFont
    , Css.backgroundImage Css.none
    , Css.textShadow Css.none
    , Css.boxShadow Css.none
    , Css.border Css.zero
    , Css.disabled [ Css.cursor Css.notAllowed ]
    , Css.color Colors.azure
    , Css.hover [ Css.color Colors.azureDark ]
    , Css.backgroundColor Css.transparent
    , Css.fontWeight (Css.int 600)
    , Css.textAlign Css.left
    , Css.borderStyle Css.none
    , Css.textDecoration Css.none
    , Css.padding Css.zero
    , Css.display Css.inlineBlock
    , Css.verticalAlign Css.textBottom
    , Css.margin Css.zero -- Get rid of default margin Webkit adds to buttons
    ]


sizeToPx : Size -> Css.Px
sizeToPx size =
    case size of
        Small ->
            Css.px 15

        Medium ->
            Css.px 17

        Large ->
            Css.px 20


dataDescriptor : String -> String
dataDescriptor descriptor =
    "clickable-text-v2-" ++ descriptor



--  Internals


type alias ClickableTextAttributes msg =
    { clickableAttributes : ClickableAttributes String msg
    , label : String
    , size : Size
    , icon : Maybe Svg
    , customAttributes : List (Html.Attribute msg)
    , customStyles : List Style
    }


defaults : ClickableTextAttributes msg
defaults =
    { clickableAttributes = ClickableAttributes.init
    , size = Medium
    , label = ""
    , icon = Nothing
    , customAttributes = []
    , customStyles = []
    }


{-| -}
type Attribute msg
    = Attribute (ClickableTextAttributes msg -> ClickableTextAttributes msg)


set :
    (ClickableTextAttributes msg -> ClickableTextAttributes msg)
    -> Attribute msg
set with =
    Attribute (\config -> with config)
