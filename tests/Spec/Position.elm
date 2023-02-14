module Spec.Position exposing (spec)

{-| -}

import Browser.Dom exposing (Element)
import Expect
import Position
import Test exposing (..)


spec : Test
spec =
    describe "xOffsetPx"
        [ test "when the element is in line with the left edge of the viewport, does not shift" <|
            \() ->
                element { viewportX = 0, viewportWidth = 100, elementX = 0, elementWidth = 50 }
                    |> Position.xOffsetPx
                    |> Expect.equal 0
        , test "when the element is in line with the right edge of the viewport, does not shift" <|
            \() ->
                element { viewportX = 0, viewportWidth = 100, elementX = 50, elementWidth = 50 }
                    |> Position.xOffsetPx
                    |> Expect.equal 0
        , test "when the viewport cuts off the element on the left side, shift to the right" <|
            \() ->
                let
                    cutOffAmount =
                        100
                in
                element { viewportX = 0, viewportWidth = 500, elementX = -cutOffAmount, elementWidth = 200 }
                    |> Position.xOffsetPx
                    |> Expect.equal cutOffAmount
        , test "when the viewport cuts off the element on the right side, shift to the left" <|
            \() ->
                let
                    cutOffAmount =
                        100
                in
                element { viewportX = 0, viewportWidth = 0, elementX = 0, elementWidth = cutOffAmount }
                    |> Position.xOffsetPx
                    |> Expect.equal -cutOffAmount
        , test "when the viewport cuts off the element on both sides, align to the left side of the viewport" <|
            \() ->
                element { viewportX = 0, viewportWidth = 100, elementX = -100, elementWidth = 300 }
                    |> Position.xOffsetPx
                    |> Expect.equal 100
        ]


element : { viewportX : Float, viewportWidth : Float, elementX : Float, elementWidth : Float } -> Element
element { viewportX, viewportWidth, elementWidth, elementX } =
    { scene = { width = 1000, height = 1000 }
    , viewport = { x = viewportX, y = 0, width = viewportWidth, height = 500 }
    , element = { x = elementX, width = elementWidth, y = 0, height = 10 }
    }
