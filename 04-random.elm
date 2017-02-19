module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (src, width, height)
import Random


main =
    Html.program { init = init, update = update, subscriptions = subscriptions, view = view }



-- MODEL


type alias Model =
    { dieFaces : List Int
    }



-- UPDATE


type Msg
    = Roll
    | NewFace (List Int)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Roll ->
            ( model, Random.generate NewFace (Random.list (List.length model.dieFaces) (Random.int 1 6)) )

        NewFace newFace ->
            ( Model newFace, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Roll the dice" ]
        , br []
            []
        , div [] (List.map viewDice model.dieFaces)
        , br [] []
        , button [ onClick Roll ] [ text "Roll" ]
        ]


viewDice : Int -> Html Msg
viewDice dieface =
    img [ src ("./images/Dice-" ++ (toString dieface) ++ ".png"), width 250, height 250 ] []



-- INIT


init : ( Model, Cmd Msg )
init =
    ( Model (List.repeat 2 1), Cmd.none )
