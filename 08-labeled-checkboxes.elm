module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


main : Program Never Model Msg
main =
    Html.program
        { init = init, update = update, subscriptions = subscriptions, view = view }



--- MODEL


type alias Model =
    { notifications : Bool
    , autoplay : Bool
    , location : Bool
    }


init : ( Model, Cmd Msg )
init =
    ( Model False False False, Cmd.none )



--- UPDATE


type Msg
    = ToggleNotifications
    | ToggleAutoplay
    | ToggleLocation


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToggleNotifications ->
            ( { model | notifications = not model.notifications }, Cmd.none )

        ToggleAutoplay ->
            ( { model | autoplay = not model.autoplay }, Cmd.none )

        ToggleLocation ->
            ( { model | location = not model.location }, Cmd.none )



--- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



--- VIEW


view : Model -> Html Msg
view model =
    div []
        [ checkbox ToggleNotifications "Email notifications"
        , checkbox ToggleAutoplay "Video autoplay"
        , checkbox ToggleLocation "Location"
        ]


checkbox : Msg -> String -> Html Msg
checkbox msg name =
    label []
        [ input [ type_ "checkbox", onClick msg ] []
        , text name
        ]
