module Nri.Ui.Block.V6 exposing
    ( view, Attribute
    , plaintext
    , Content, content
    , phrase, space, bold, italic
    , blank
    , emphasize
    , label, id
    , labelId, labelContentId
    , LabelPosition, getLabelPositions, labelPosition
    , LabelState(..), labelState
    , labelCss
    , yellow, cyan, magenta, green, blue, purple, brown
    , insertLineBreakOpportunities
    )

{-| Changes from V5:

    - Remove `wordWithId` and `blankWithId` as we no longer are trying to point to words or blanks with the question box.
    - Remove the `fullHeightBlank` attribute option - we can always infer this from the contents
    - Set a maximum blank width of ~60 characters as blanks won't line break

@docs view, Attribute


## Content

@docs plaintext
@docs Content, content
@docs phrase, space, bold, italic
@docs blank


## Content customization

@docs emphasize


## Labels & positioning

@docs label, id

You will need these helpers if you want to prevent label overlaps. (Which is to say -- anytime you have labels!)

@docs labelId, labelContentId
@docs LabelPosition, getLabelPositions, labelPosition
@docs LabelState, labelState
@docs labelCss


### Visual customization

@docs yellow, cyan, magenta, green, blue, purple, brown
@docs insertLineBreakOpportunities

-}

import Accessibility.Styled exposing (..)
import Browser.Dom as Dom
import Css exposing (Color)
import Dict exposing (Dict)
import Html.Styled.Attributes as Attributes exposing (css)
import List.Extra
import Nri.Ui.Colors.V1 as Colors
import Nri.Ui.Html.Attributes.V2 as AttributesExtra exposing (nriDescription)
import Nri.Ui.Mark.V4 as Mark exposing (Mark)
import Nri.Ui.MediaQuery.V1 as MediaQuery
import Position exposing (xOffsetPx)


{-| Create a block element.

Note that it is important that a series of Block elements be wrapped in a container with "whitespace; pre" set.
This will ensure that line breaks only happen at whitespace, and not directly before an emphasis block in
situations where it would look strange (like if the block started with a comma).

    p
        [ css [ Css.whitespace Css.pre ] ]
        [ Block.view [ Block.plaintext "Hello, world!" ] ]

-}
view : List (Attribute msg) -> Html msg
view attributes =
    attributes
        |> List.foldl (\(Attribute attribute) b -> attribute b) defaultConfig
        |> render



-- Attributes


{-| Provide the main content of the block as a plain-text string. You can also use `content` for more complex cases, including a blank appearing within an emphasis.
-}
plaintext : String -> Attribute msg
plaintext content_ =
    Attribute <| \config -> { config | content = parseString content_ }


{-| Use `content` for more complex block views, for instance when a blank appears within an emphasis block. Prefer to use `plaintext` when possible for better readability.

    Block.view
        [ Block.emphasize
        , Block.content (Block.phrase "Hello, " ++  Block.blank { characterWidth = 8 } :: Block.phrase "!" ) ]
        ]

-}
content : List (Content msg) -> Attribute msg
content content_ =
    Attribute <| \config -> { config | content = content_ }


{-| Mark content as emphasized.
-}
emphasize : Attribute msg
emphasize =
    Attribute <| \config -> { config | emphasize = True }


{-| Add a label above content. This label supports markdown syntax for **bold** and _italics_
-}
label : String -> Attribute msg
label label_ =
    Attribute <| \config -> { config | label = Just label_, emphasize = True }


{-| Use `getLabelPositions` to construct this value.
-}
type alias LabelPosition =
    { totalHeight : Float
    , arrowHeight : Float
    , zIndex : Int
    , xOffset : Float
    }


{-| Use `getLabelPositions` to calculate what these values should be.
-}
labelPosition : Maybe LabelPosition -> Attribute msg
labelPosition offset =
    Attribute <| \config -> { config | labelPosition = offset }


{-| Controls label animations.

Visible will fade in when first displayed.
FadeOut will start visible and then fade out.

-}
type LabelState
    = Visible
    | FadeOut


{-| Sets a Block's labels visible / fading-out state. Default is visible.
-}
labelState : LabelState -> Attribute msg
labelState state =
    Attribute <| \config -> { config | labelState = state }


{-| Use to set a block's label's CSS
-}
labelCss : List Css.Style -> Attribute msg
labelCss css =
    Attribute <| \config -> { config | labelCss = List.append config.labelCss css }


{-| -}
labelContentId : String -> String
labelContentId labelId_ =
    labelId_ ++ "-label-content"


{-| Determine where to position labels in order to dynamically avoid overlapping content.

    - First, we add ids to block with labels with `Block.labelId`.
    - Say we added `Block.labelId "example-id"`, then we will use `Browser.Dom.getElement "example-id"` and `Browser.Dom.getElement (Block.labelContentId "example-id")` to construct a record in the shape { label : Dom.Element, labelContent : Dom.Element }. We store this record in a dictionary keyed by ids (e.g., "example-id") with measurements for all other labels.

`getLabelPositions` will return a dictionary of values (keyed by label ids) whose values can be passed directly to `labelPosition` for positioning.

-}
getLabelPositions :
    Dict String { label : Dom.Element, labelContent : Dom.Element }
    -> Dict String LabelPosition
getLabelPositions labelMeasurementsById =
    let
        startingArrowHeight =
            8
    in
    Dict.toList labelMeasurementsById
        |> splitByOverlaps
        |> List.concatMap
            (\row ->
                let
                    maxRowIndex =
                        List.length row - 1
                in
                row
                    -- Put the widest elements higher visually to avoid overlaps
                    |> List.sortBy (Tuple.second >> .labelContent >> .element >> .width)
                    |> List.foldl
                        (\( idString, e ) ( index, height, acc ) ->
                            ( index + 1
                            , height + e.labelContent.element.height + 4
                            , ( idString
                              , { totalHeight = height + e.labelContent.element.height
                                , arrowHeight = height
                                , zIndex = maxRowIndex - index
                                , xOffset = xOffsetPx e.label
                                }
                              )
                                :: acc
                            )
                        )
                        ( 0, startingArrowHeight, [] )
                    |> (\( _, _, v ) -> v)
            )
        |> Dict.fromList


{-| Group the elements whose bottom edges are at the same height. This ensures that we only offset labels against other labels in the same visual line of content.

Then, for elements in the same row, group elements with horizontal overlaps .

-}
splitByOverlaps : List ( id, { a | label : Dom.Element } ) -> List (List ( id, { a | label : Dom.Element } ))
splitByOverlaps =
    -- consider the elements from top to bottom
    groupWithSort (\( _, a ) -> a.label.element.y + a.label.element.height)
        (\( _, a ) ( _, b ) ->
            isRangeOverlapping
                ( a.label.element.y, a.label.element.y + a.label.element.height )
                ( b.label.element.y, b.label.element.y + b.label.element.height )
        )
        >> List.concatMap
            -- consider the elements from left to right
            (groupWithSort (\( _, a ) -> a.label.element.x)
                (\( _, a ) ( _, b ) ->
                    (a.label.element.x + xOffsetPx a.label + a.label.element.width) >= (b.label.element.x + xOffsetPx b.label)
                )
            )


isRangeOverlapping : ( Float, Float ) -> ( Float, Float ) -> Bool
isRangeOverlapping ( a1, a2 ) ( b1, b2 ) =
    (a1 <= b2 && a2 >= b1) || (a1 <= b2 && a2 >= b1)


groupWithSort : (a -> comparable) -> (a -> a -> Bool) -> List a -> List (List a)
groupWithSort sortBy groupBy =
    List.sortBy sortBy
        >> List.Extra.groupWhile groupBy
        >> List.map (\( first, rem ) -> first :: rem)


{-| Insert the HTML <wbr> "line break opportunity" element if the content is a space
(Only makes a difference on Chrome. Firefox and Safari treat this element like a <span>.)
-}
insertLineBreakOpportunities : Bool -> Attribute msg
insertLineBreakOpportunities x =
    Attribute <| \config -> { config | insertWbrAfterSpace = x }



-- Content


{-| -}
type Content msg
    = Word String
    | Blank CharacterWidth
    | Markdown Markdown (List (Content msg))


{-| -}
type CharacterWidth
    = CharacterWidth Int


type Markdown
    = Bold
    | Italic


parseString : String -> List (Content msg)
parseString =
    String.split " "
        >> List.intersperse " "
        >> List.filter (\str -> str /= "")
        >> List.map Word


renderContent :
    BlankHeight
    -> Config msg
    -> Content msg
    -> List Css.Style
    -> Html msg
renderContent blankHeight config content_ styles =
    case content_ of
        Word str ->
            let
                blockContainer =
                    blockSegmentContainer Nothing
                        [ text str ]
                        styles
            in
            if str == " " then
                if config.insertWbrAfterSpace then
                    span []
                        [ blockContainer
                        , wbr [] []
                        ]

                else
                    blockContainer

            else
                blockContainer

        Blank length ->
            blockSegmentContainer Nothing
                [ viewBlank blankHeight length ]
                styles

        Markdown markdown contents ->
            let
                tag =
                    case markdown of
                        Bold ->
                            strong [ css styles ]

                        Italic ->
                            em [ css styles ]
            in
            contents
                |> List.map (\c -> renderContent blankHeight config c [])
                |> tag


blockSegmentContainer : Maybe String -> List (Html msg) -> List Css.Style -> Html msg
blockSegmentContainer id_ children styles =
    span
        [ css
            (Css.whiteSpace Css.pre
                :: Css.display Css.inlineBlock
                :: Css.position Css.relative
                :: styles
            )
        , AttributesExtra.maybe Attributes.id id_
        , nriDescription "block-segment-container"
        ]
        children


{-| Add any arbitrary string as part of block content.
-}
phrase : String -> List (Content msg)
phrase =
    parseString


{-| Convenience helper to insert a space into block content.

Putting spaces in `phrase` is fine as well, but you might find this more useful around the edges of `blank`.

-}
space : Content msg
space =
    Word " "


{-| Insert a blank into block content specify a number of characters to set the width.

For simple blanks, you can call `view` with no `content` or `plaintext` specified,
however if you need to control the width of the blank or put a blank inside of other emphasized content you need to use this function.

The `characterWidth` will be multipled by 0.5em, which will roughly appear to be the same size as a string with that many characters.

For example, the following two blocks should be approximately the same width.

`phrase "Hello"`
`blank { characterWidth = 5 }`

-}
blank : { characterWidth : Int } -> Content msg
blank { characterWidth } =
    Blank (CharacterWidth characterWidth)


{-| Wraps a group of content in a `strong` tag
-}
bold : List (Content msg) -> Content msg
bold =
    Markdown Bold


{-| Wraps a group of content in a `em` tag
-}
italic : List (Content msg) -> Content msg
italic =
    Markdown Italic



-- Color themes


{-| -}
type Theme
    = Yellow
    | Cyan
    | Magenta
    | Green
    | Blue
    | Purple
    | Brown


themeToPalette : Theme -> Palette
themeToPalette theme =
    case theme of
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


toMark :
    { config
        | emphasize : Bool
        , label : Maybe String
        , content : List (Content msg)
    }
    -> Palette
    -> Maybe Mark
toMark config { backgroundColor, borderColor } =
    case ( config.label, config.content, config.emphasize ) of
        ( Just l, (Blank _) :: [], _ ) ->
            -- If a blank is the **only** content and there is a label, then wrapping it in an emphasize block looks awkward.
            Just
                { name = Just l
                , startStyles = []
                , styles = []
                , endStyles = []
                }

        ( Just l, _, False ) ->
            Just
                { name = Just l
                , startStyles = []
                , styles = []
                , endStyles = []
                }

        ( _, _, True ) ->
            let
                borderWidth =
                    Css.px 1

                borderStyle =
                    Css.dashed
            in
            Just
                { name = config.label
                , startStyles =
                    [ Css.borderLeft3 borderWidth borderStyle borderColor
                    , Css.paddingLeft (Css.px 2)
                    ]
                , styles =
                    [ Css.paddingTop topBottomSpace
                    , Css.paddingBottom topBottomSpace
                    , Css.backgroundColor backgroundColor
                    , Css.borderTop3 borderWidth borderStyle borderColor
                    , Css.borderBottom3 borderWidth borderStyle borderColor
                    , MediaQuery.highContrastMode
                        [ Css.property "background-color" "Mark"
                        , Css.property "color" "MarkText"
                        , Css.property "forced-color-adjust" "none"
                        ]
                    ]
                , endStyles =
                    [ Css.borderRight3 borderWidth borderStyle borderColor
                    , Css.paddingRight (Css.px 2)
                    ]
                }

        ( Nothing, _, False ) ->
            Nothing


topBottomSpace : Css.Px
topBottomSpace =
    Css.px 4


{-| -}
yellow : Attribute msg
yellow =
    Attribute (\config -> { config | theme = Yellow })


{-| -}
cyan : Attribute msg
cyan =
    Attribute (\config -> { config | theme = Cyan })


{-| -}
magenta : Attribute msg
magenta =
    Attribute (\config -> { config | theme = Magenta })


{-| -}
green : Attribute msg
green =
    Attribute (\config -> { config | theme = Green })


{-| -}
blue : Attribute msg
blue =
    Attribute (\config -> { config | theme = Blue })


{-| -}
purple : Attribute msg
purple =
    Attribute (\config -> { config | theme = Purple })


{-| -}
brown : Attribute msg
brown =
    Attribute (\config -> { config | theme = Brown })


{-| -}
id : String -> Attribute msg
id id_ =
    Attribute (\config -> { config | id = Just id_ })


{-| -}
labelId : String -> Attribute msg
labelId id_ =
    Attribute (\config -> { config | labelId = Just id_ })



-- Internals


{-| -}
type Attribute msg
    = Attribute (Config msg -> Config msg)


defaultConfig : Config msg
defaultConfig =
    { content = [ blank { characterWidth = 8 } ]
    , id = Nothing
    , label = Nothing
    , labelId = Nothing
    , labelPosition = Nothing
    , labelState = Visible
    , labelCss = []
    , theme = Yellow
    , emphasize = False
    , insertWbrAfterSpace = False
    }


type alias Config msg =
    { content : List (Content msg)
    , id : Maybe String
    , label : Maybe String
    , labelId : Maybe String
    , labelPosition : Maybe LabelPosition
    , labelState : LabelState
    , labelCss : List Css.Style
    , theme : Theme
    , emphasize : Bool
    , insertWbrAfterSpace : Bool
    }


type BlankHeight
    = BlankHeightFull
    | BlankHeightInline


findBlankHeight : { x | emphasize : Bool, content : List (Content msg) } -> BlankHeight
findBlankHeight config =
    case config.content of
        [ Blank _ ] ->
            -- Lonely blanks don't have the emphasized border draw around them (even if they have a label!)
            -- So there is no need to make them inline
            BlankHeightFull

        _ ->
            if config.emphasize then
                BlankHeightInline

            else
                BlankHeightFull


render : Config msg -> Html msg
render config =
    let
        palette =
            themeToPalette config.theme

        maybeMark =
            toMark config palette
    in
    span
        [ css [ Css.position Css.relative ], AttributesExtra.maybe Attributes.id config.id ]
        (Mark.viewWithBalloonTags
            { renderSegment = renderContent (findBlankHeight config) config
            , backgroundColor = palette.backgroundColor
            , maybeMarker = maybeMark
            , labelPosition = config.labelPosition
            , labelCss = config.labelCss
            , labelState =
                case config.labelState of
                    Visible ->
                        Mark.Visible

                    FadeOut ->
                        Mark.FadeOut
            , labelId = config.labelId
            , labelContentId = Maybe.map labelContentId config.labelId
            }
            config.content
        )


viewBlank : BlankHeight -> CharacterWidth -> Html msg
viewBlank blankHeight (CharacterWidth width) =
    let
        heightStyles =
            case blankHeight of
                BlankHeightFull ->
                    [ Css.paddingTop topBottomSpace
                    , Css.paddingBottom topBottomSpace
                    , Css.lineHeight Css.initial
                    ]

                BlankHeightInline ->
                    [ Css.lineHeight (Css.num 1) ]
    in
    span
        [ css
            [ Css.border3 (Css.px 2) Css.dashed Colors.navy
            , MediaQuery.highContrastMode
                [ Css.property "border-color" "CanvasText"
                , Css.property "background-color" "Canvas"
                ]
            , Css.backgroundColor Colors.white
            , Css.width <| Css.em (min 30 <| max 0.83 (toFloat width * 0.5))
            , Css.display Css.inlineBlock
            , Css.borderRadius (Css.px 4)
            , Css.batch heightStyles
            ]
        ]
        [ blankString ]


blankString : Html msg
blankString =
    span
        [ css
            [ Css.overflowX Css.hidden
            , Css.width (Css.px 0)
            , Css.display Css.inlineBlock
            , Css.verticalAlign Css.bottom
            ]
        ]
        [ text "blank" ]
