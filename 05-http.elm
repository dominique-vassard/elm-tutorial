module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode


main : Program Never Model Msg
main =
    Html.program
        { init = init "cats"
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type alias Model =
    { topic : String
    , new_topic : String
    , gifUrl : String
    , error : String
    , topics : List String
    }


init : String -> ( Model, Cmd Msg )
init topic =
    ( Model "cats" "" "./images/waiting.gif" "" [ "cats", "dogs" ]
    , getRandomGif topic
    )



-- UPDATE


getRandomGif : String -> Cmd Msg
getRandomGif topic =
    let
        url =
            "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag="
                ++ topic

        request =
            Http.get url decodeGifUrl
    in
        Http.send NewGif request


decodeGifUrl : Json.Decode.Decoder String
decodeGifUrl =
    Json.Decode.at [ "data", "image_url" ] Json.Decode.string


type Msg
    = MorePlease
    | NewGif (Result Http.Error String)
    | NewTopic String
    | AddNewTopic
    | ChangeTopic String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MorePlease ->
            ( model, getRandomGif model.topic )

        ChangeTopic change_topic ->
            ( { model | topic = change_topic }, getRandomGif change_topic )

        NewTopic new_topic ->
            ( { model | new_topic = new_topic }, Cmd.none )

        AddNewTopic ->
            if not (String.isEmpty model.new_topic) then
                let
                    topic_list =
                        if (List.filter (\x -> x == model.new_topic) model.topics |> List.length) == 0 then
                            model.topics ++ [ model.new_topic ]
                        else
                            model.topics
                in
                    ( { model
                        | topic = model.new_topic
                        , new_topic = ""
                        , topics = topic_list
                      }
                    , getRandomGif model.new_topic
                    )
            else
                ( model, Cmd.none )

        NewGif (Ok newUrl) ->
            ( { model | gifUrl = newUrl }, Cmd.none )

        NewGif (Err msg) ->
            case msg of
                Http.BadUrl badurl ->
                    ( { model | error = badurl }, Cmd.none )

                Http.Timeout ->
                    ( { model | error = "ERROR: Reques timeout" }, Cmd.none )

                Http.NetworkError ->
                    ( { model | error = "ERROR: Can't contact server." }
                    , Cmd.none
                    )

                Http.BadStatus status ->
                    ( { model
                        | error =
                            "ERROR: Bad request status" ++ (toString status)
                      }
                    , Cmd.none
                    )

                Http.BadPayload reason _ ->
                    ( { model | error = "Bad payload: " ++ reason }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text model.topic ]
        , span [ style [ ( "color", "red" ), ( "font-weight", "800" ) ] ]
            [ text model.error ]
        , br [] []
        , img [ src model.gifUrl ] []
        , button [ onClick MorePlease ] [ text "Moar Please!" ]
        , br [] []
        , input
            [ type_ "text"
            , placeholder "Enter new topic"
            , onInput NewTopic
            ]
            []
        , button [ onClick AddNewTopic ] [ text "Add" ]
        , br [] []
        , Html.select [ value model.topic, onSelect ChangeTopic ]
            (List.map (\x -> option [ value x ] [ text x ]) model.topics)
        ]


onSelect : (String -> Msg) -> Attribute Msg
onSelect msg =
    on "change" (Json.Decode.map msg Html.Events.targetValue)


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
