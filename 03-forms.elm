module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick, onSubmit)
import Char


main =
    Html.beginnerProgram { model = model, view = view, update = update }



-- MODEL


type alias FormErrors =
    { field : String
    , message : String
    }


type alias Model =
    { name : String
    , age : Int
    , password : String
    , password_conf : String
    , formSubmitted : Bool
    , formErrors : List FormErrors
    }


model : Model
model =
    { name = ""
    , age = 0
    , password = ""
    , password_conf = ""
    , formSubmitted = False
    , formErrors = []
    }



--model =
--    Model "" "" ""
-- UPDATE


silentValidate : Model -> Bool
silentValidate model =
    let
        newModel =
            model
                |> checkName
                |> checkAge
                |> checkPassword
    in
        List.isEmpty newModel.formErrors


validateForm : Model -> Model
validateForm model =
    { model | formSubmitted = True, formErrors = [] }
        |> checkName
        |> checkAge
        |> checkPassword


checkName : Model -> Model
checkName model =
    if String.isEmpty model.name then
        { model | formErrors = model.formErrors ++ [ { field = "name", message = "Name should not be empty." } ] }
    else
        model


checkAge : Model -> Model
checkAge model =
    if (model.age == 0) || (model.age > 120) then
        { model | formErrors = model.formErrors ++ [ { field = "age", message = "Age should be an integer between 1 and 120." } ] }
    else
        model


checkPassword : Model -> Model
checkPassword model =
    if String.length model.password < 8 then
        { model | formErrors = model.formErrors ++ [ { field = "password", message = "Password is too short (Required: 8 character min)." } ] }
    else if String.any Char.isDigit model.password == False then
        { model | formErrors = model.formErrors ++ [ { field = "password", message = "Password should contain at least one digit." } ] }
    else if String.any Char.isUpper model.password == False then
        { model | formErrors = model.formErrors ++ [ { field = "password", message = "Password should contain at least one uppercase character." } ] }
    else if String.any Char.isLower model.password == False then
        { model | formErrors = model.formErrors ++ [ { field = "password", message = "Password should contain at least one lowercase character." } ] }
    else if model.password /= model.password_conf then
        { model | formErrors = model.formErrors ++ [ { field = "password", message = "Passwords don't match!" } ] }
    else
        model


type Msg
    = Name String
    | Password String
    | PasswordConf String
    | Age String
    | FormSubmit


update : Msg -> Model -> Model
update msg model =
    case msg of
        Name name ->
            let
                formErrors =
                    List.filter (\x -> not (x.field == "name")) model.formErrors
            in
                { model | name = name, formErrors = formErrors } |> checkName

        Password password ->
            let
                formErrors =
                    List.filter (\x -> not (x.field == "password")) model.formErrors
            in
                { model | password = password, formErrors = formErrors } |> checkPassword

        --{ model | password = password, formErrors = [] } |> checkPassword
        PasswordConf password_conf ->
            let
                formErrors =
                    List.filter (\x -> not (x.field == "password")) model.formErrors
            in
                { model | password_conf = password_conf, formErrors = formErrors } |> checkPassword

        --{ model | password_conf = password_conf, formErrors = [] } |> checkPassword
        Age age ->
            let
                formErrors =
                    List.filter (\x -> not (x.field == "age")) model.formErrors
            in
                case String.toInt age of
                    Ok val ->
                        { model | age = val, formErrors = formErrors } |> checkAge

                    Err err ->
                        { model | formErrors = formErrors } |> checkAge

        FormSubmit ->
            validateForm model



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ Html.form [ onSubmit FormSubmit ]
            [ viewInput "text" "Name: " "name" "Enter your name" model Name
            , viewInput "text" "Age: " "age" "Enter your age" model Age
            , viewInput "password" "Password: " "password" "Enter your password" model Password
            , viewInput "password" "Password confirmation: " "password_conf" "Re-enter your password" model PasswordConf
            , displaySubmit model
            , viewSubmit model
            ]
        ]


displaySubmit : Model -> Html Msg
displaySubmit model =
    let
        disabledSubmit =
            if (not (List.isEmpty model.formErrors)) || not (silentValidate model) then
                True
            else
                False
    in
        input [ type_ "submit", disabled disabledSubmit ] [ text "Submit form" ]



-- View final form validation


viewSubmit : Model -> Html Msg
viewSubmit model =
    let
        ( color, message ) =
            if not model.formSubmitted then
                ( "grey", "Please fill the form." )
            else if List.isEmpty model.formErrors then
                ( "green", "Form OK" )
            else
                ( "red", List.map .message model.formErrors |> String.join "\n" )
    in
        div [ style [ ( "color", color ) ] ] [ text (message) ]



-- Input helper


viewInput : String -> String -> String -> String -> Model -> (String -> Msg) -> Html Msg
viewInput inputType inputLabel inputModelName placeHolder model msg =
    div []
        [ span [] [ text inputLabel ]
        , input [ type_ inputType, placeholder placeHolder, onInput msg ]
            []
        , span [ style [ ( "color", "red" ), ( "font-weight", "800" ) ] ]
            [ text ((List.filter (\x -> x.field == inputModelName) model.formErrors) |> List.map .message |> String.join "") ]
        ]
