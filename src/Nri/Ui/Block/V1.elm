module Nri.Ui.Block.V1 exposing
    ( view, Attribute
    , plaintext, content
    , Content, string, blank
    , emphasize, label, labelHeight
    , yellow, cyan, magenta, green, blue, purple, brown
    , class, id
    , labelId, labelContentId
    , getLabelHeights
    )

{-|

@docs view, Attribute


## Content

@docs plaintext, content
@docs Content, string, blank


## Content customization

@docs emphasize, label, labelHeight


### Visual customization

@docs yellow, cyan, magenta, green, blue, purple, brown


### General attributes

@docs class, id


## Accessors

You will need these helpers if you want to prevent label overlaps. (Which is to say -- anytime you have labels!)

@docs labelId, labelContentId
@docs getLabelHeights

-}

import Accessibility.Styled exposing (..)
import Browser.Dom as Dom
import Css exposing (Color)
import Dict exposing (Dict)
import Html.Styled.Attributes as Attributes exposing (css)
import List.Extra
import Nri.Ui.Colors.V1 as Colors
import Nri.Ui.Html.Attributes.V2 as AttributesExtra exposing (nriDescription)
import Nri.Ui.Mark.V1 as Mark exposing (Mark)
import Nri.Ui.MediaQuery.V1 as MediaQuery


{-|

    Block.view [ Block.plaintext "Hello, world!" ]

-}
view : List Attribute -> List (Html msg)
view attributes =
    attributes
        |> List.foldl (\(Attribute attribute) b -> attribute b) defaultConfig
        |> render



-- Attributes


{-| Provide the main content of the block as a plain-text string. You can also use `content` for more complex cases, including a blank appearing within an emphasis.
-}
plaintext : String -> Attribute
plaintext content_ =
    Attribute <| \config -> { config | content = [ String_ content_ ] }


{-| Use `content` for more complex block views, for instance when a blank appears within an emphasis block. Prefer to use `plaintext` when possible for better readability.

    Block.view
        [ Block.emphasize
        , Block.content [ Block.string "Hello, ", Block.blank, Block.string "!" ]
        ]

-}
content : List Content -> Attribute
content content_ =
    Attribute <| \config -> { config | content = content_ }


{-| Mark content as emphasized.
-}
emphasize : Attribute
emphasize =
    Attribute <| \config -> { config | theme = Just Emphasis }


{-| -}
label : String -> Attribute
label label_ =
    Attribute <| \config -> { config | label = Just label_ }


{-| Use `getLabelHeights` to calculate what these values should be.
-}
labelHeight : Maybe { totalHeight : Float, arrowHeight : Float } -> Attribute
labelHeight offset =
    Attribute <| \config -> { config | labelHeight = offset }


{-| -}
labelId : String -> String
labelId labelId_ =
    labelId_ ++ "-label"


{-| -}
labelContentId : String -> String
labelContentId labelId_ =
    labelId_ ++ "-label-content"


{-|

    Pass in a list of the Block ids that you care about (use `Block.id` to attach these ids).

    - First, we add ids to block with labels with `Block.id`.
    - Say we added `Block.id "example-id"`, then we will use `Browser.Dom.getElement (Block.labelId "example-id")` and `Browser.Dom.getElement (Block.labelContentId "example-id")` to construct a record in the shape { label : Dom.Element, labelContent : Dom.Element }. We store this record in a dictionary keyed by ids (e.g., "example-id") with measurements for all other labels.
    - Pass a list of all the block ids and the dictionary of measurements to `getLabelHeights`. `getLabelHeights` will return a dictionary of values (keyed by ids) that we will then pass directly to `labelHeight` for positioning.

-}
getLabelHeights :
    List String
    -> Dict String { label : Dom.Element, labelContent : Dom.Element }
    -> Dict String { totalHeight : Float, arrowHeight : Float }
getLabelHeights ids labelMeasurementsById =
    let
        startingArrowHeight =
            8
    in
    ids
        |> List.filterMap
            (\idString ->
                case Dict.get idString labelMeasurementsById of
                    Just measurement ->
                        Just ( idString, measurement )

                    Nothing ->
                        Nothing
            )
        -- Group the elements whose bottom edges are at the same height
        -- this ensures that we only offset labels against other labels in the same line of content
        |> List.Extra.groupWhile
            (\( _, a ) ( _, b ) ->
                (a.label.element.y + a.label.element.height) == (b.label.element.y + b.label.element.height)
            )
        |> List.concatMap
            (\( first, rem ) ->
                (first :: rem)
                    -- Put the widest elements higher visually to avoid overlaps
                    |> List.sortBy (Tuple.second >> .labelContent >> .element >> .width)
                    |> List.foldl
                        (\( idString, e ) ( height, acc ) ->
                            ( height + e.labelContent.element.height
                            , ( idString
                              , { totalHeight = height + e.labelContent.element.height + 8, arrowHeight = height }
                              )
                                :: acc
                            )
                        )
                        ( startingArrowHeight, [] )
                    |> Tuple.second
            )
        |> Dict.fromList



-- Content


{-| -}
type Content
    = String_ String
    | Blank


renderContent : { config | class : Maybe String, id : Maybe String } -> Content -> List Css.Style -> Html msg
renderContent config content_ markStyles =
    span
        [ css (Css.whiteSpace Css.preWrap :: markStyles)
        , nriDescription "block-segment-container"
        , AttributesExtra.maybe Attributes.class config.class
        , AttributesExtra.maybe Attributes.id config.id
        ]
        (case content_ of
            String_ str ->
                [ text str ]

            Blank ->
                [ viewBlank { class = Nothing, id = Nothing } ]
        )


{-| You will only need to use this helper if you're also using `content` to construct a more complex Block. Maybe you want `plaintext` instead?
-}
string : String -> Content
string =
    String_


{-| You will only need to use this helper if you're also using `content` to construct a more complex Block. For a less complex blank Block, don't include content or plaintext in the list of attributes.
-}
blank : Content
blank =
    Blank



-- Color themes


{-| -}
type Theme
    = Emphasis
    | Yellow
    | Cyan
    | Magenta
    | Green
    | Blue
    | Purple
    | Brown


themeToPalette : Theme -> Palette
themeToPalette theme =
    case theme of
        Emphasis ->
            defaultPalette

        Yellow ->
            { backgroundColor = Colors.highlightYellow
            , borderColor = Colors.highlightYellowDark
            }

        Cyan ->
            { backgroundColor = Colors.highlightCyan
            , borderColor = Colors.highlightCyanDark
            }

        Magenta ->
            { backgroundColor = Colors.highlightMagenta
            , borderColor = Colors.highlightMagentaDark
            }

        Green ->
            { backgroundColor = Colors.highlightGreen
            , borderColor = Colors.highlightGreenDark
            }

        Blue ->
            { backgroundColor = Colors.highlightBlue
            , borderColor = Colors.highlightBlueDark
            }

        Purple ->
            { backgroundColor = Colors.highlightPurple
            , borderColor = Colors.highlightPurpleDark
            }

        Brown ->
            { backgroundColor = Colors.highlightBrown
            , borderColor = Colors.highlightBrownDark
            }


type alias Palette =
    { backgroundColor : Color, borderColor : Color }


defaultPalette : Palette
defaultPalette =
    { backgroundColor = Colors.highlightYellow
    , borderColor = Colors.highlightYellowDark
    }


toMark : Maybe String -> Maybe Palette -> Maybe Mark
toMark label_ palette =
    case ( label_, palette ) of
        ( _, Just { backgroundColor, borderColor } ) ->
            Just
                { name = label_
                , startStyles = []
                , styles =
                    [ Css.padding2 (Css.px 4) (Css.px 2)
                    , Css.backgroundColor backgroundColor
                    , Css.border3 (Css.px 1) Css.dashed borderColor
                    , MediaQuery.highContrastMode
                        [ Css.property "background-color" "Mark"
                        , Css.property "color" "MarkText"
                        , Css.property "forced-color-adjust" "none"
                        ]
                    ]
                , endStyles = []
                }

        ( Just l, Nothing ) ->
            Just
                { name = Just l
                , startStyles = []
                , styles = []
                , endStyles = []
                }

        ( Nothing, Nothing ) ->
            Nothing


{-| -}
yellow : Attribute
yellow =
    Attribute (\config -> { config | theme = Just Yellow })


{-| -}
cyan : Attribute
cyan =
    Attribute (\config -> { config | theme = Just Cyan })


{-| -}
magenta : Attribute
magenta =
    Attribute (\config -> { config | theme = Just Magenta })


{-| -}
green : Attribute
green =
    Attribute (\config -> { config | theme = Just Green })


{-| -}
blue : Attribute
blue =
    Attribute (\config -> { config | theme = Just Blue })


{-| -}
purple : Attribute
purple =
    Attribute (\config -> { config | theme = Just Purple })


{-| -}
brown : Attribute
brown =
    Attribute (\config -> { config | theme = Just Brown })


{-| -}
class : String -> Attribute
class class_ =
    Attribute (\config -> { config | class = Just class_ })


{-| -}
id : String -> Attribute
id id_ =
    Attribute (\config -> { config | id = Just id_ })



-- Internals


{-| -}
type Attribute
    = Attribute (Config -> Config)


defaultConfig : Config
defaultConfig =
    { content = []
    , label = Nothing
    , labelId = Nothing
    , labelHeight = Nothing
    , theme = Nothing
    , class = Nothing
    , id = Nothing
    }


type alias Config =
    { content : List Content
    , label : Maybe String
    , labelId : Maybe String
    , labelHeight : Maybe { totalHeight : Float, arrowHeight : Float }
    , theme : Maybe Theme
    , class : Maybe String
    , id : Maybe String
    }


render : Config -> List (Html msg)
render config =
    let
        maybePalette =
            Maybe.map themeToPalette config.theme

        palette =
            Maybe.withDefault defaultPalette maybePalette

        maybeMark =
            toMark config.label maybePalette
    in
    case config.content of
        [] ->
            case maybeMark of
                Just mark ->
                    Mark.viewWithOffsetBalloonTags
                        { renderSegment = renderContent config
                        , backgroundColor = palette.backgroundColor
                        , maybeMarker = Just mark
                        , labelHeight = config.labelHeight
                        , labelId = Maybe.map labelId config.id
                        , labelContentId = Maybe.map labelContentId config.id
                        }
                        [ Blank ]

                Nothing ->
                    [ viewBlank config ]

        _ ->
            Mark.viewWithOffsetBalloonTags
                { renderSegment = renderContent config
                , backgroundColor = palette.backgroundColor
                , maybeMarker = maybeMark
                , labelHeight = config.labelHeight
                , labelId = Maybe.map labelId config.id
                , labelContentId = Maybe.map labelContentId config.id
                }
                config.content


viewBlank : { config | class : Maybe String, id : Maybe String } -> Html msg
viewBlank config =
    span
        [ css
            [ Css.border3 (Css.px 2) Css.dashed Colors.navy
            , MediaQuery.highContrastMode
                [ Css.property "border-color" "CanvasText"
                , Css.property "background-color" "Canvas"
                ]
            , Css.backgroundColor Colors.white
            , Css.minWidth (Css.px 80)
            , Css.display Css.inlineBlock
            , Css.borderRadius (Css.px 4)
            ]
        , AttributesExtra.maybe Attributes.class config.class
        , AttributesExtra.maybe Attributes.id config.id
        ]
        [ span
            [ css
                [ Css.overflowX Css.hidden
                , Css.width (Css.px 0)
                , Css.display Css.inlineBlock
                , Css.verticalAlign Css.bottom
                ]
            ]
            [ text "blank" ]
        ]
