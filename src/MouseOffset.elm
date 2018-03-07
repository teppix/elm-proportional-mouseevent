module MouseOffset exposing (mouseOffsetInUnit)

import Json.Decode exposing (Decoder, map2)
import MouseOffset.Internal exposing (..)


{-| Decode mouse offset from event, relative to the supplied dimensions
-}
mouseOffsetInUnit : String -> ( Float, Float ) -> Decoder ( Float, Float )
mouseOffsetInUnit canvasId canvasSizeInUnit =
    map2 (convertMousePos canvasSizeInUnit) mouseOffset (canvasClientSize canvasId)
