module MouseOffset.Internal exposing (..)

import Json.Decode
    exposing
        ( Decoder
        , andThen
        , field
        , float
        , map2
        , string
        )


{-| find parent element with id == searchId, and apply decoder to element
-}
parentWithId : String -> Decoder a -> Decoder a
parentWithId searchId decoder =
    let
        checkId id =
            if id == searchId then
                decoder
            else
                field "parentElement" (parentWithId searchId decoder)
    in
        field "id" string |> andThen checkId


{-| decode clientWidth and clientHeight into float-tuple
-}
getClientSize : Decoder ( Float, Float )
getClientSize =
    map2 (,)
        (field "clientWidth" float)
        (field "clientHeight" float)


{-| Get client size of parent element with matching id
-}
canvasClientSize : String -> Decoder ( Float, Float )
canvasClientSize canvasId =
    field "target" <| parentWithId canvasId getClientSize


mouseOffset : Decoder ( Float, Float )
mouseOffset =
    map2 (,)
        (field "offsetX" float)
        (field "offsetY" float)


{-| calculate unit-agnostic mouse position
-}
convertMousePos : ( Float, Float ) -> ( Float, Float ) -> ( Float, Float ) -> ( Float, Float )
convertMousePos ( canvasW, canvasH ) ( mouseX_Px, mouseY_Px ) ( clientW_Px, clientH_Px ) =
    ( mouseX_Px * canvasW / clientW_Px
    , mouseY_Px * canvasH / clientH_Px
    )
