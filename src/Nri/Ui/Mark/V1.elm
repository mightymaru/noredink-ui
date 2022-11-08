module Nri.Ui.Mark.V1 exposing (view, viewWithInlineTags)

{-|

@docs view, viewWithInlineTags

-}

import Accessibility.Styled.Aria as Aria
import Accessibility.Styled.Style exposing (invisibleStyle)
import Css exposing (Style)
import Css.Global
import Html.Styled as Html exposing (Html, span)
import Html.Styled.Attributes exposing (class, css)
import Nri.Ui.Colors.V1 as Colors
import Nri.Ui.Fonts.V1 as Fonts
import Nri.Ui.Html.Attributes.V2 as AttributesExtra
import Nri.Ui.Html.V3 exposing (viewJust)
import Nri.Ui.MediaQuery.V1 as MediaQuery


type alias Marker marker =
    { marker
        | name : Maybe String
        , endGroupClass : List Css.Style
    }


{-| When elements are marked, wrap them in a single `mark` html node.
-}
view :
    (Int -> { content | marked : Maybe (Marker marker) } -> Html msg)
    -> List { content | marked : Maybe (Marker marker) }
    -> List (Html msg)
view =
    view_ { showTagsInline = False, inlineTagStyles = \_ -> [] }


{-| When elements are marked, wrap them in a single `mark` html node.

Show the label for the mark, if present, in-line with the emphasized content.

-}
viewWithInlineTags :
    ({ content | marked : Maybe (Marker marker) } -> List Style)
    -> (Int -> { content | marked : Maybe (Marker marker) } -> Html msg)
    -> List { content | marked : Maybe (Marker marker) }
    -> List (Html msg)
viewWithInlineTags inlineTagStyles =
    view_ { showTagsInline = True, inlineTagStyles = inlineTagStyles }


view_ :
    { showTagsInline : Bool
    , inlineTagStyles : { content | marked : Maybe (Marker marker) } -> List Style
    }
    -> (Int -> { content | marked : Maybe (Marker marker) } -> Html msg)
    -> List { content | marked : Maybe (Marker marker) }
    -> List (Html msg)
view_ config viewSegment highlightables =
    case highlightables of
        [] ->
            []

        first :: _ ->
            case first.marked of
                Just markedWith ->
                    [ Html.mark
                        [ markedWith.name
                            |> Maybe.map (\name -> Aria.roleDescription (name ++ " highlight"))
                            |> Maybe.withDefault AttributesExtra.none
                        , css
                            [ Css.backgroundColor Css.transparent
                            , Css.Global.children
                                [ Css.Global.selector ":last-child"
                                    (Css.after
                                        [ Css.property "content" ("\" [end " ++ (Maybe.map (\name -> name) markedWith.name |> Maybe.withDefault "highlight") ++ "] \"")
                                        , invisibleStyle
                                        ]
                                        :: markedWith.endGroupClass
                                    )
                                ]
                            ]
                        ]
                        (viewInlineTag config first :: List.indexedMap viewSegment highlightables)
                    ]

                Nothing ->
                    List.indexedMap viewSegment highlightables


viewInlineTag :
    { showTagsInline : Bool
    , inlineTagStyles : { content | marked : Maybe (Marker marker) } -> List Css.Style
    }
    -> { content | marked : Maybe (Marker marker) }
    -> Html msg
viewInlineTag { showTagsInline, inlineTagStyles } highlightable =
    span
        [ css (inlineTagStyles highlightable)
        , class "highlighter-inline-tag"
        , case highlightable.marked of
            Just markedWith ->
                class "highlighter-inline-tag-highlighted"

            _ ->
                AttributesExtra.none
        ]
        [ viewJust
            (\name ->
                span
                    [ css
                        [ Fonts.baseFont
                        , Css.backgroundColor Colors.white
                        , Css.color Colors.navy
                        , Css.padding2 (Css.px 2) (Css.px 4)
                        , Css.borderRadius (Css.px 3)
                        , Css.margin2 Css.zero (Css.px 5)
                        , Css.boxShadow5 Css.zero (Css.px 1) (Css.px 1) Css.zero Colors.gray75
                        , Css.display Css.none
                        , if showTagsInline then
                            Css.batch [ Css.display Css.inline |> Css.important, MediaQuery.highContrastMode [ Css.property "forced-color-adjust" "none", Css.property "color" "initial" |> Css.important ] ]

                          else
                            Css.batch
                                [ MediaQuery.highContrastMode [ Css.property "forced-color-adjust" "none", Css.display Css.inline |> Css.important, Css.property "color" "initial" |> Css.important ]
                                ]
                        ]
                    , -- we use the :before element to convey details about the start of the
                      -- highlighter to screenreaders, so the visual label is redundant
                      Aria.hidden True
                    ]
                    [ Html.text name ]
            )
            (Maybe.andThen .name highlightable.marked)
        ]
