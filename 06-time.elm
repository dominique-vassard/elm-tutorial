module Main exposing (..)

import Html exposing (Html, div, text, span)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time exposing (Time, second)
import Task
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
    { clockTime : Time
    , clockOn : Bool
    }


init : ( Model, Cmd Msg )
init =
    ( { clockTime = 0, clockOn = True }, Task.perform Tick Time.now )



--- UPDATE


type Msg
    = Tick Time
    | StopClock


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick newTime ->
            ( { model | clockTime = newTime }, Cmd.none )

        StopClock ->
            ( { model | clockOn = not (model.clockOn) }, Cmd.none )



--- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    if model.clockOn then
        Time.every second Tick
    else
        Sub.none



--- VIEW


view : Model -> Html Msg
view model =
    let
        hours =
            Date.hour <| Date.fromTime model.clockTime

        minutes =
            Date.minute <| Date.fromTime model.clockTime

        seconds =
            Date.second <| Date.fromTime model.clockTime

        angle =
            --turns (Time.inMinutes model)
            Basics.degrees (Basics.toFloat (seconds * 6) - 90.0)

        handX =
            toString (50 + 35 * cos angle)

        handY =
            toString (50 + 35 * sin angle)

        angleH =
            Basics.degrees (Basics.toFloat (hours * 30) - 90.0)

        handHX =
            toString (50 + 20 * cos angleH)

        handHY =
            toString (50 + 20 * sin angleH)

        angleM =
            Basics.degrees (Basics.toFloat (minutes * 6) - 90.0)

        handMX =
            toString (50 + 40 * cos angleM)

        handMY =
            toString (50 + 40 * sin angleM)

        hourText =
            (if hours < 10 then
                "0"
             else
                ""
            )
                ++ toString hours

        minuteText =
            (if minutes < 10 then
                "0"
             else
                ""
            )
                ++ toString minutes

        secondText =
            (if seconds < 10 then
                "0"
             else
                ""
            )
                ++ toString seconds
    in
        div []
            [ svg
                [ viewBox "0 0 100 100", Svg.Attributes.width "300px" ]
                [ circle [ cx "50", cy "50", r "45", fill "#6B7912" ] []
                , line [ x1 "50", y1 "50", x2 handMX, y2 handMY, stroke "black" ] []
                , line [ x1 "50", y1 "50", x2 handHX, y2 handHY, stroke "black" ] []
                , line [ x1 "50", y1 "50", x2 handX, y2 handY, stroke "red" ] []
                ]
            , span [ Html.Attributes.style [ ( "font-size", "50px" ), ( "font-weight", "800" ) ] ] [ Html.text (hourText ++ ":" ++ minuteText ++ ":" ++ secondText) ]
            , Html.button [ onClick StopClock ] [ Html.text "Stop" ]
            ]
