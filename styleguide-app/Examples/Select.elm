module Examples.Select exposing (Msg, State, example)

{-|

@docs Msg, State, example

-}

import Category exposing (Category(..))
import Css
import Debug.Control as Control exposing (Control)
import Debug.Control.Extra as ControlExtra
import Example exposing (Example)
import Html.Styled
import Html.Styled.Attributes
import KeyboardSupport exposing (Direction(..), Key(..))
import Nri.Ui.Heading.V2 as Heading
import Nri.Ui.Select.V8 as Select


{-| -}
example : Example State Msg
example =
    { name = "Select"
    , version = 8
    , state = init
    , update = update
    , subscriptions = \_ -> Sub.none
    , categories = [ Inputs ]
    , keyboardSupport = []
    , view =
        \state ->
            let
                attributes =
                    Control.currentValue state.attributes
            in
            [ Control.view UpdateAttributes state.attributes
                |> Html.Styled.fromUnstyled
            , Select.view "Tortilla Selector"
                { current = Nothing
                , choices =
                    [ { label = "Tacos", value = "Tacos" }
                    , { label = "Burritos", value = "Burritos" }
                    , { label = "Enchiladas", value = "Enchiladas" }
                    ]
                , valueToString = identity
                , defaultDisplayText = Just "Select a tasty tortilla based treat!"
                }
                attributes
                |> Html.Styled.map ConsoleLog
            , Html.Styled.div
                [ Html.Styled.Attributes.css [ Css.maxWidth (Css.px 400) ] ]
                [ Select.view "Selector with Overflowed Text"
                    { current = Nothing
                    , choices = []
                    , valueToString = identity
                    , defaultDisplayText = Just "Look at me, I design coastlines, I got an award for Norway. Where's the sense in that?"
                    }
                    []
                    |> Html.Styled.map ConsoleLog
                ]
            ]
    }


{-| -}
type alias State =
    { attributes : Control (List Select.Attribute)
    }


{-| -}
init : State
init =
    { attributes = initControls
    }


initControls : Control (List Select.Attribute)
initControls =
    ControlExtra.list
        |> ControlExtra.optionalListItem "errorIf"
            (Control.map Select.errorIf <| Control.bool True)
        |> ControlExtra.optionalListItem "errorMessage"
            (Control.map (Just >> Select.errorMessage) <| Control.string "The right item must be selected.")


{-| -}
type Msg
    = ConsoleLog String
    | UpdateAttributes (Control (List Select.Attribute))


{-| -}
update : Msg -> State -> ( State, Cmd Msg )
update msg state =
    case msg of
        ConsoleLog message ->
            let
                _ =
                    Debug.log "SelectExample" message
            in
            ( state, Cmd.none )

        UpdateAttributes attributes ->
            ( { state | attributes = attributes }
            , Cmd.none
            )
