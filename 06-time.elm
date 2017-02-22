module Main exposing (..)

import Html exposing (Html, div, text)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time exposing (Time, second)
import Date


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



--- MODEL


type alias Model =
    Time


init : ( Model, Cmd Msg )
init =
    ( 0, Cmd.none )



--- UPDATE


type Msg
    = Tick Time


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick newTime ->
            ( newTime, Cmd.none )



--- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every second Tick



--- VIEW


view : Model -> Html Msg
view model =
    let
        angle =
            --turns (Time.inMinutes model)
            Basics.degrees (Basics.toFloat ((Date.second <| Date.fromTime model) * 6) - 90.0)

        handX =
            toString (50 + 35 * cos angle)

        handY =
            toString (50 + 35 * sin angle)

        angleH =
            Basics.degrees (Basics.toFloat ((Date.hour <| Date.fromTime model) * 30) - 90.0)

        handHX =
            toString (50 + 20 * cos angleH)

        handHY =
            toString (50 + 20 * sin angleH)

        angleM =
            Basics.degrees (Basics.toFloat ((Date.minute <| Date.fromTime model) * 6) - 90.0)

        handMX =
            toString (50 + 40 * cos angleM)

        handMY =
            toString (50 + 40 * sin angleM)

        minutes =
            Time.inMinutes model

        seconds =
            "///" ++ toString (Date.second <| Date.fromTime model)
    in
        div []
            [ svg
                [ viewBox "0 0 100 100", width "300px" ]
                [ circle [ cx "50", cy "50", r "45", fill "#6B7912" ] []
                , line [ x1 "50", y1 "50", x2 handMX, y2 handMY, stroke "black" ] []
                , line [ x1 "50", y1 "50", x2 handHX, y2 handHY, stroke "black" ] []
                , line [ x1 "50", y1 "50", x2 handX, y2 handY, stroke "red" ] []
                ]
            ]
