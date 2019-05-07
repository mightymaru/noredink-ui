module Examples.DisclosureIndicator exposing (Msg, State, example, init, update)

{- \
   @docs Msg, State, example, init, update,
-}

import Assets exposing (Assets, assets)
import Css
import Html.Styled as Html
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events exposing (onClick)
import ModuleExample as ModuleExample exposing (Category(..), ModuleExample)
import Nri.Ui.DisclosureIndicator.V2 as DisclosureIndicator
import Nri.Ui.Fonts.V1 as Fonts


{-| -}
type Msg
    = DisclosureIndicatorToggle Bool
    | InlineDisclosureIndicatorToggle Bool


{-| -}
type alias State =
    { disclosed : Bool
    , inlineDisclosed : Bool
    }


{-| -}
example : (Msg -> msg) -> State -> ModuleExample msg
example parentMessage state =
    { name = "Nri.Ui.DisclosureIndicator.V2"
    , category = Widgets
    , content =
        [ Html.h3 [] [ Html.text "Panel indicator" ]
        , Html.button
            [ css
                [ Css.borderStyle Css.none
                , Css.outline Css.none
                , Css.fontSize (Css.px 20)
                ]
            , onClick (DisclosureIndicatorToggle (not state.disclosed))
            ]
            [ DisclosureIndicator.view assets
                { isOpen = state.disclosed
                }
            , Html.text "Item with detail"
            ]
        , Html.h3 [] [ Html.text "Inline indicator" ]
        , Html.p []
            [ Html.text
                """
                The inline variant of the indicator is smaller and occupies
                less vertical space so it can be inlined in lists or tables
                without breaking text flow. Also, it rotates from right to
                down direction when expanding.
                """
            ]
        , Html.button
            [ css
                [ Css.displayFlex
                , Css.alignItems Css.center
                , Css.borderStyle Css.none
                , Css.outline Css.none
                , Fonts.baseFont
                , Css.fontSize (Css.px 16)
                ]
            , onClick (InlineDisclosureIndicatorToggle (not state.inlineDisclosed))
            ]
            [ DisclosureIndicator.viewInline assets
                { isOpen = state.inlineDisclosed
                }
            , Html.text "Item with detail"
            ]
        ]
            |> List.map (Html.map parentMessage)
    }


{-| -}
init : State
init =
    { disclosed = False
    , inlineDisclosed = False
    }


{-| -}
update : Msg -> State -> ( State, Cmd Msg )
update msg state =
    case msg of
        DisclosureIndicatorToggle disclosed ->
            ( { state | disclosed = disclosed }, Cmd.none )

        InlineDisclosureIndicatorToggle disclosed ->
            ( { state | inlineDisclosed = disclosed }, Cmd.none )
