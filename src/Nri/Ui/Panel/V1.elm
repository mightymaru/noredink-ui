module Nri.Ui.Panel.V1 exposing
    ( view, Attribute
    , header, headerExtras
    , plaintext, markdown, html
    , containerCss, headerCss, css
    , primaryTheme, secondaryTheme
    )

{-| Create panels (AKA wells.)

@docs view, Attribute


## Content

@docs header, headerExtras
@docs plaintext, markdown, html
@docs containerCss, headerCss, css


## Theme

@docs primaryTheme, secondaryTheme

-}

import Css exposing (Style)
import Html.Styled exposing (..)
import Html.Styled.Attributes as Attributes
import Markdown
import Nri.Ui.Colors.V1 as Colors
import Nri.Ui.Fonts.V1 as Fonts


type alias Config msg =
    { header : String
    , headerExtras : List (Html msg)
    , content : List (Html msg)
    , theme : Theme
    , css : List Style
    , headerCss : List Style
    , containerCss : List Style
    }


defaultConfig : Config msg
defaultConfig =
    { header = ""
    , headerExtras = []
    , content = []
    , theme = Primary
    , css = []
    , headerCss = []
    , containerCss = []
    }


{-| -}
type Attribute msg
    = Attribute (Config msg -> Config msg)


type Theme
    = Primary
    | Secondary


{-| use the primary color theme (this is the default)
-}
primaryTheme : Attribute msg
primaryTheme =
    Attribute (\soFar -> { soFar | theme = Primary })


{-| use the secondary color theme
-}
secondaryTheme : Attribute msg
secondaryTheme =
    Attribute (\soFar -> { soFar | theme = Secondary })


{-| The main text for the panel's header
-}
header : String -> Attribute msg
header header_ =
    Attribute (\soFar -> { soFar | header = header_ })


{-| Use this attribute can also add extra stuff to the right side of the panel header.
-}
headerExtras : List (Html msg) -> Attribute msg
headerExtras headerExtras_ =
    Attribute (\soFar -> { soFar | headerExtras = headerExtras_ })


{-| Render panel content.
-}
html : List (Html msg) -> Attribute msg
html contents_ =
    Attribute (\soFar -> { soFar | content = contents_ })


{-| Use a plain-text string for the panel content.
-}
plaintext : String -> Attribute msg
plaintext content =
    Attribute <| \config -> { config | content = [ text content ] }


{-| Use a markdown string for the panel content.
-}
markdown : String -> Attribute msg
markdown content =
    Attribute <|
        \config ->
            { config
                | content =
                    Markdown.toHtml Nothing content
                        |> List.map fromUnstyled
            }


{-| -}
containerCss : List Style -> Attribute msg
containerCss styles =
    Attribute <| \config -> { config | containerCss = styles }


{-| -}
headerCss : List Style -> Attribute msg
headerCss styles =
    Attribute <| \config -> { config | headerCss = styles }


{-| -}
css : List Style -> Attribute msg
css styles =
    Attribute <| \config -> { config | css = styles }



-- views


{-| create a panel, given the options you specify
-}
view : List (Attribute msg) -> Html msg
view customizations =
    let
        panel =
            List.foldl (\(Attribute f) -> f) defaultConfig customizations
    in
    section [ Attributes.css panel.containerCss ]
        [ Html.Styled.header
            [ Attributes.css
                [ case panel.theme of
                    Primary ->
                        Css.backgroundColor Colors.navy

                    Secondary ->
                        Css.backgroundColor Colors.gray75
                , Css.padding2 (Css.px 8) (Css.px 15)
                , Fonts.baseFont
                , Css.fontSize (Css.px 16)
                , Css.color Colors.white
                , Css.borderTopLeftRadius (Css.px 8)
                , Css.borderTopRightRadius (Css.px 8)
                , Css.displayFlex
                , Css.alignItems Css.center
                , Css.flexWrap Css.wrap
                , Css.batch panel.headerCss
                ]
            ]
            (text panel.header :: panel.headerExtras)
        , article
            [ Attributes.css
                [ Css.padding2 (Css.px 8) (Css.px 15)
                , Fonts.baseFont
                , Css.fontSize (Css.px 16)
                , Css.color Colors.gray20
                , Css.backgroundColor Colors.white
                , Css.borderBottomLeftRadius (Css.px 8)
                , Css.borderBottomRightRadius (Css.px 8)
                , Css.overflowWrap Css.breakWord
                , Css.property "word-wrap" "break-word"
                , Css.batch panel.css
                ]
            ]
            panel.content
        ]
