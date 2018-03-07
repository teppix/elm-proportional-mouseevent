module OverlappingBoxes exposing (..)

import Html exposing (Attribute, Html, div, pre, text, beginnerProgram)
import Html.Attributes exposing (style, id)
import Html.Events exposing (on)
import Json.Decode as Json
import MouseOffset exposing (mouseOffsetInUnit)


{- Types -}


type alias Position =
    ( Float, Float )


type Msg
    = SetMousePositionCanvas Position
    | SetMousePositionBox Position


type alias Model =
    { canvas : Position
    , box : Position
    }



{- Init -}


init : Model
init =
    { canvas = ( 0, 0 )
    , box = ( 0, 0 )
    }



{- Events -}


onMouseMove : (Position -> Msg) -> String -> Position -> Html.Attribute Msg
onMouseMove msg canvasId canvasSize =
    on "mousemove" <|
        Json.map msg (mouseOffsetInUnit canvasId canvasSize)



{- Helpers -}


intToMm : Int -> String
intToMm val =
    (toString val) ++ "mm"


positionToString : Position -> String
positionToString ( x, y ) =
    intToMm (round x) ++ ", " ++ intToMm (round y)



{- Styles -}


canvasStyle : String -> String -> Attribute Msg
canvasStyle width height =
    style
        [ ( "background-color", "grey" )
        , ( "width", width )
        , ( "height", height )
        , ( "margin", "10mm auto" )
        , ( "position", "relative" )
        ]


boxStyle : String -> String -> Attribute Msg
boxStyle width height =
    style
        [ ( "background-color", "lightgrey" )
        , ( "width", width )
        , ( "height", height )
        , ( "position", "relative" )
        , ( "top", "10mm" )
        , ( "left", "10mm" )
        ]



{- Views -}


boxView : Html Msg
boxView =
    let
        ( widthInMm, heightInMm ) =
            ( 30, 20 )

        elementId =
            "box"
    in
        div
            [ id elementId
            , boxStyle (intToMm widthInMm) (intToMm heightInMm)
            , onMouseMove SetMousePositionBox elementId ( widthInMm, heightInMm )
            ]
            []


canvasView : Html Msg
canvasView =
    let
        ( widthInMm, heightInMm ) =
            ( 70, 85 )

        elementId =
            "canvas"
    in
        div
            [ id elementId
            , canvasStyle (intToMm widthInMm) (intToMm heightInMm)
            , onMouseMove SetMousePositionCanvas elementId ( widthInMm, heightInMm )
            ]
            [ boxView ]


infoView : String -> Position -> Html Msg
infoView name position =
    pre
        [ style [ ( "text-align", "center" ) ]
        ]
        [ text <| name ++ ": " ++ positionToString position ]


view : Model -> Html Msg
view model =
    div []
        [ canvasView
        , infoView "Canvas" model.canvas
        , infoView "Box" model.box
        ]



{- Update -}


update : Msg -> Model -> Model
update msg model =
    case msg of
        SetMousePositionCanvas pos ->
            { model | canvas = pos }

        SetMousePositionBox pos ->
            { model | box = pos }



{- Program -}


main : Program Never Model Msg
main =
    beginnerProgram
        { view = view
        , update = update
        , model = init
        }
