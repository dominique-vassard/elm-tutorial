module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Helpers.Radio exposing (viewPicker)


main : Program Never Model Msg
main =
    Html.program
        { init = init, update = update, subscriptions = subscriptions, view = view }



--- MODEL


type alias Model =
    { fontSize : FontSize
    , content : String
    }


type FontSize
    = Small
    | Medium
    | Large


init : ( Model, Cmd Msg )
init =
    ( Model Small "This is the content.", Cmd.none )



--- UPDATE


type Msg
    = SwitchTo FontSize


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SwitchTo fontSize ->
            ( { model | fontSize = fontSize }, Cmd.none )



--- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



--- VIEW


view : Model -> Html Msg
view model =
    let
        fSize =
            case model.fontSize of
                Small ->
                    "5pt"

                Medium ->
                    "20pt"

                Large ->
                    "50pt"
    in
        div []
            [ --fieldset []
              --    [ radio (SwitchTo Small) "fontSize" "Small"
              --    , radio (SwitchTo Medium) "fontSize" "Medium"
              --    , radio (SwitchTo Large)
              --        "fontSize"
              --        "Large"
              --    ]
              viewPicker
                [ ( SwitchTo Small, "Small" )
                , ( SwitchTo Medium, "Medium" )
                , ( SwitchTo Large, "Large" )
                ]
                "fontSize"
            , br [] []
            , section
                [ style [ ( "font-size", fSize ) ] ]
                [ text model.content ]
            ]



--viewPicker : List ( Msg, String ) -> String -> Html Msg
--viewPicker options groupname =
--    fieldset [] (List.map (\x -> radio x groupname) options)
--radio : ( Msg, String ) -> String -> Html Msg
--radio ( msg, rtext ) groupname =
--    label []
--        [ input [ type_ "radio", name groupname, onClick msg ] []
--        , text rtext
--        ]
