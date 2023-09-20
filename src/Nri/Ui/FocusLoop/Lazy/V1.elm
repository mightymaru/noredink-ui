module Nri.Ui.FocusLoop.Lazy.V1 exposing (lazy, lazy2, lazy3, lazy4, lazy5, Args2(..), Args3(..), Args4(..), Args5(..))

{-| Sometimes, there are sets of interactive elements that we want users to be able to navigate
through with arrow keys rather than with tabs, and we want the final focus change to wrap.
This module makes it easier to set up this focus and wrapping behavior.

@docs lazy, lazy2, lazy3, lazy4, lazy5, Args2, Args3, Args4, Args5

-}

import Accessibility.Styled exposing (Html)
import Html.Styled.Lazy as Lazy
import Nri.Ui.FocusLoop.Internal exposing (keyEvents, siblings)
import Nri.Ui.FocusLoop.V1 exposing (Config)


type alias LazyFocusLoop msg a =
    Config String msg a -> List a -> List ( String, Html msg )


{-| Helper type for lazy2
-}
type Args2 a1 a2
    = Args2 a1 a2


{-| Helper type for lazy3
-}
type Args3 a1 a2 a3
    = Args3 a1 a2 a3


{-| Helper type for lazy4
-}
type Args4 a1 a2 a3 a4
    = Args4 a1 a2 a3 a4


{-| Helper type for lazy5
-}
type Args5 a1 a2 a3 a4 a5
    = Args5 a1 a2 a3 a4 a5


{-| Lazy version of FocusLoop.view

As the name suggests, this function uses Html.Lazy.lazy to render your `view` function.

Please ensure that the arguments you are passing to `view`, i.e. the contents
of your array, will behave as expected with Html.Lazy. tl;dr, only primitives are
checked by value; everything else is checked by reference. This means that if you are
constructing records in your view that are passed into `lazy`, they will be reconstructed
on every call to view, causing the lazy to evaluate as not equal and ultimately cause your
view to re-render on every call to `view`.

See <https://guide.elm-lang.org/optimization/lazy> for more details.

Hint, you may need to flatten records into individual arguments and use lazy2, lazy3, etc.
so that you can pass primitives and ensure they are checked by value, or individual references
(i.e. not a record container many, a la `config`).

-}
lazy : LazyFocusLoop msg a
lazy config =
    let
        -- DO NOT INLINE THIS. Lazy.lazyN will not work if this is an anonymous function.
        view_ =
            viewHelp config
    in
    lazyHelp config (Lazy.lazy3 view_)


{-| Like FocusLoop.lazy, but with 2 arguments to your view function.

e.g.

    FocusLoop.lazy2
        { id = \(FocusLoop.Args2 a1 a2) -> ...
        , focus = Focus
        , leftRight = True
        , upDown = True
        , view = viewFocusableItem
        }
        [ FocusLoop.Args2 a1 a2
        , FocusLoop.Args2 b1 a2
        ]

    viewFocusableItem (FocusLoop.Args2 arg1 arg2) arrowKeyHandlers =
        ...

-}
lazy2 : LazyFocusLoop msg (Args2 a1 a2)
lazy2 config =
    let
        view_ a1 a2 =
            viewHelp config (Args2 a1 a2)
    in
    lazyHelp config (\(Args2 a1 a2) -> Lazy.lazy4 view_ a1 a2)


{-| Like FocusLoop.lazy, but with 3 arguments to your view function.

See lazy2 usage example for more details.

-}
lazy3 : LazyFocusLoop msg (Args3 a1 a2 a3)
lazy3 config =
    let
        view_ a1 a2 a3 =
            viewHelp config (Args3 a1 a2 a3)
    in
    lazyHelp config (\(Args3 a1 a2 a3) -> Lazy.lazy5 view_ a1 a2 a3)


{-| Like FocusLoop.lazy, but with 4 arguments to your view function.

See lazy2 usage example for more details.

-}
lazy4 : LazyFocusLoop msg (Args4 a1 a2 a3 a4)
lazy4 config =
    let
        view_ a1 a2 a3 a4 =
            viewHelp config (Args4 a1 a2 a3 a4)
    in
    lazyHelp config (\(Args4 a1 a2 a3 a4) -> Lazy.lazy6 view_ a1 a2 a3 a4)


{-| Like FocusLoop.lazy, but with 5 arguments to your view function.

See lazy2 usage example for more details.

-}
lazy5 : LazyFocusLoop msg (Args5 a1 a2 a3 a4 a5)
lazy5 config =
    let
        view_ a1 a2 a3 a4 a5 =
            viewHelp config (Args5 a1 a2 a3 a4 a5)
    in
    lazyHelp config (\(Args5 a1 a2 a3 a4 a5) -> Lazy.lazy7 view_ a1 a2 a3 a4 a5)


viewHelp : Config String msg a -> a -> String -> String -> Html msg
viewHelp config item prevId nextId =
    config.view item <|
        case ( prevId, nextId ) of
            ( "", "" ) ->
                []

            _ ->
                keyEvents config ( prevId, nextId )


lazyHelp : Config String msg args -> (args -> String -> String -> Html msg) -> List args -> List ( String, Html msg )
lazyHelp { id } view_ =
    siblings
        >> List.map
            (\( args, maybeSiblings ) ->
                let
                    ( prevId, nextId ) =
                        maybeSiblings
                            |> Maybe.map (Tuple.mapBoth id id)
                            -- We have to use empty strings here instead of maybes
                            -- so that lazy will check by value instead of by reference.
                            |> Maybe.withDefault ( "", "" )
                in
                ( id args
                , view_ args prevId nextId
                )
            )
