module Main exposing (..)

import Html exposing (Html, div, span, br, h2, text)
import Html.Attributes exposing (style)
import Svg exposing (svg, circle)
import Svg.Attributes exposing (cx, cy, r, fill, width, height)
import Keyboard exposing (KeyCode, downs)
import Mouse exposing (Position, clicks, moves)
import Char exposing (fromCode)
import Window exposing (Size, resizes, size)
import Task exposing (perform)


main : Program Never Model Msg
main =
    Html.program { init = init, update = update, subscriptions = subscriptions, view = view }



--- MODEL


type alias Model =
    { keyCodes : List KeyCode
    , mousePos : Position
    , clicks : List Position
    , screen : Window.Size
    }


init : ( Model, Cmd Msg )
init =
    ( Model [] { x = 0, y = 0 } [] { width = 0, height = 0 }, Task.perform WindowResize Window.size )



--- UPDATE


type Msg
    = KeyPress KeyCode
    | MouseMove Position
    | MouseClick Position
    | WindowResize Window.Size


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        KeyPress keyCode ->
            ( { model | keyCodes = model.keyCodes ++ [ keyCode ] }, Cmd.none )

        MouseMove position ->
            ( { model | mousePos = position }, Cmd.none )

        MouseClick position ->
            ( { model | clicks = model.clicks ++ [ position ] }, Cmd.none )

        WindowResize size ->
            ( { model | screen = size }, Cmd.none )



--- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ downs KeyPress
        , moves MouseMove
        , clicks MouseClick
        , Window.resizes WindowResize
        ]



--- VIEW


view : Model -> Html Msg
view model =
    let
        lastKeyCode =
            model.keyCodes |> List.reverse |> List.head

        lastStr =
            case lastKeyCode of
                Maybe.Nothing ->
                    ""

                Just keyCode ->
                    keyCode |> fromCode |> String.fromChar
    in
        div []
            [ div [ style [ ( "position", "fixed" ), ( "top", "0px" ), ( "left", "0px" ) ] ]
                [ div []
                    [ h2 [] [ text "Mouse position" ]
                    , span [] [ text ("X: " ++ toString model.mousePos.x) ]
                    , span [] [ text ("Y: " ++ toString model.mousePos.y) ]
                    ]
                , div []
                    [ h2 [] [ text "Keyboard" ]
                    , span [ style [ ( "font-size", "100px" ) ] ]
                        [ text ("Code: " ++ (toString lastKeyCode) ++ "----> Char: " ++ lastStr) ]
                    , br [] []
                    , span [] (List.map (\x -> x |> fromCode |> String.fromChar |> text) model.keyCodes)
                    ]
                ]
            , div [ style [ ( "position", "fixed" ), ( "top", "0px" ), ( "left", "0px" ) ] ]
                [ svg [ width (toString model.screen.width), height (toString model.screen.height) ] (List.map viewClicks model.clicks)
                ]
            ]


viewClicks : Position -> Html Msg
viewClicks position =
    circle [ cx (toString position.x), cy (toString position.y), r "10", fill "lightgreen" ] []
