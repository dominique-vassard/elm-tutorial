module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (src, width, height)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Random


main =
    Html.program
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



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
            ( model
            , Random.list (List.length model.dieFaces) (Random.int 1 6)
                |> Random.generate NewFace
            )

        NewFace newFace ->
            ( Model newFace, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ Html.text "Roll the dice" ]
        , br []
            []
        , div [] (List.map viewDiceSvg model.dieFaces)
        , br [] []
        , button [ onClick Roll ] [ Html.text "Roll" ]
        ]


viewDiceSvg : Int -> Html Msg
viewDiceSvg dieface =
    let
        size =
            200

        margin =
            10

        fill_color =
            "orange"

        stroke_color =
            "black"

        stroke_width =
            5
    in
        svg
            [ viewBox ("0 0 " ++ toString size ++ " " ++ toString size)
            , Svg.Attributes.width (toString size)
            , Svg.Attributes.height (toString size)
            ]
            [ rect
                [ x (toString margin)
                , y (toString margin)
                , Svg.Attributes.width (toString (size - 2 * margin))
                , Svg.Attributes.height (toString (size - 2 * margin))
                , rx (toString margin)
                , ry (toString margin)
                , stroke stroke_color
                , strokeWidth (toString stroke_width)
                , fill fill_color
                ]
                []
            , viewPip dieface size margin
            ]



-- Draw pipe for the given number


viewPip : Int -> Int -> Int -> Html Msg
viewPip dieface size margin =
    let
        pip_size =
            size * 8 // 100

        fill_color =
            "green"

        -- Dice is a square then each measurement fits vertical and horizontal
        step =
            (size - 2 * margin) // 4

        first =
            margin // 2 + step

        middle =
            first + step

        last =
            middle + step

        pip_top_left =
            Svg.circle
                [ cx (toString first)
                , cy (toString first)
                , r (toString pip_size)
                ]
                []

        pip_bottom_left =
            Svg.circle
                [ cx (toString first)
                , cy (toString last)
                , r (toString pip_size)
                ]
                []

        pip_top_right =
            Svg.circle
                [ cx (toString last)
                , cy (toString first)
                , r (toString pip_size)
                ]
                []

        pip_bottom_right =
            Svg.circle
                [ cx (toString last)
                , cy (toString last)
                , r (toString pip_size)
                ]
                []

        pip_center =
            Svg.circle
                [ cx (toString middle)
                , cy (toString middle)
                , r (toString pip_size)
                ]
                []

        pip_center_left =
            Svg.circle
                [ cx (toString first)
                , cy (toString middle)
                , r (toString pip_size)
                ]
                []

        pip_center_right =
            Svg.circle
                [ cx (toString last)
                , cy (toString middle)
                , r (toString pip_size)
                ]
                []
    in
        case (clamp 1 6 dieface) of
            1 ->
                Svg.g [ fill fill_color ]
                    [ pip_center
                    ]

            2 ->
                Svg.g [ fill fill_color ]
                    [ pip_top_left
                    , pip_bottom_right
                    ]

            3 ->
                Svg.g [ fill fill_color ]
                    [ pip_top_left
                    , pip_center
                    , pip_bottom_right
                    ]

            4 ->
                Svg.g [ fill fill_color ]
                    [ pip_top_left
                    , pip_bottom_left
                    , pip_top_right
                    , pip_bottom_right
                    ]

            5 ->
                Svg.g [ fill fill_color ]
                    [ pip_top_left
                    , pip_bottom_left
                    , pip_center
                    , pip_top_right
                    , pip_bottom_right
                    ]

            6 ->
                Svg.g [ fill fill_color ]
                    [ pip_top_left
                    , pip_center_left
                    , pip_bottom_left
                    , pip_top_right
                    , pip_center_right
                    , pip_bottom_right
                    ]

            _ ->
                Debug.crash "Impossible"



-- INIT


init : ( Model, Cmd Msg )
init =
    ( Model (List.repeat 5 1), Cmd.none )
