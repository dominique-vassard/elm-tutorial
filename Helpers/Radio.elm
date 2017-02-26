module Helpers.Radio exposing (viewPicker)

import Html exposing (Html, fieldset, label, input, text)
import Html.Attributes exposing (type_, name)
import Html.Events exposing (onClick)


viewPicker : List ( message, String ) -> String -> Html message
viewPicker options groupname =
    fieldset [] (List.map (\x -> radio x groupname) options)


radio : ( message, String ) -> String -> Html message
radio ( msg, rtext ) groupname =
    label []
        [ input [ type_ "radio", name groupname, onClick msg ] []
        , text rtext
        ]
