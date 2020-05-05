module Spec.Nri.Ui.FormValidation.V1 exposing (all)

import Accessibility.Styled as Html
import Html.Attributes
import Nri.Ui.Button.V10 as Button
import Nri.Ui.FormValidation.V1 as FormValidation
import Nri.Ui.TextInput.V6 as TextInput
import ProgramTest exposing (..)
import String.Verify
import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector exposing (..)
import Verify exposing (Validator)


type alias ProgramTest =
    ProgramTest.ProgramTest FormModel FormMsg ()


type alias FormModel =
    { formData : UnvalidatedForm
    , submitted : Bool
    }


type FormField
    = FirstName
    | LastName
    | Username


type alias UnvalidatedForm =
    { firstName : String
    , lastName : String
    , username : String
    }


type alias ValidatedForm =
    { firstName : String
    , lastName : String
    , username : Maybe String
    }


validator : Validator ( FormField, String ) UnvalidatedForm ValidatedForm
validator =
    let
        maybeBlank s =
            if s == "" then
                Ok Nothing

            else
                Ok (Just s)
    in
    Verify.validate ValidatedForm
        |> Verify.verify .firstName (String.Verify.notBlank ( FirstName, "First name is required" ))
        |> Verify.verify .lastName (String.Verify.notBlank ( LastName, "Last name is required" ))
        |> Verify.verify .username maybeBlank


type FormMsg
    = OnInput FormField String
    | SubmitForm


start : ProgramTest
start =
    let
        init =
            { formData =
                { firstName = ""
                , lastName = ""
                , username = ""
                }
            , submitted = False
            }

        update msg model =
            case msg of
                OnInput field newString ->
                    let
                        formData =
                            model.formData
                    in
                    { model
                        | formData =
                            case field of
                                FirstName ->
                                    { formData | firstName = newString }

                                LastName ->
                                    { formData | lastName = newString }

                                Username ->
                                    { formData | username = newString }
                    }

                SubmitForm ->
                    { model | submitted = True }

        view model =
            FormValidation.view <|
                \_ ->
                    let
                        errors =
                            if model.submitted then
                                case validator model.formData of
                                    Ok _ ->
                                        []

                                    Err ( first, rest ) ->
                                        first :: rest

                            else
                                []

                        errorFor field =
                            List.filter (Tuple.first >> (==) field) errors
                                |> List.head
                                |> Maybe.map Tuple.second
                    in
                    Html.div
                        []
                        [ Html.text "Form heading"
                        , TextInput.view "First name"
                            (TextInput.text (OnInput FirstName))
                            [ TextInput.errorMessage (errorFor FirstName)
                            ]
                            model.formData.firstName
                        , TextInput.view "Last name"
                            (TextInput.text (OnInput LastName))
                            []
                            model.formData.lastName
                        , TextInput.view "Username"
                            (TextInput.text (OnInput Username))
                            []
                            model.formData.username
                        , Button.button "Submit"
                            [ if errors == [] then
                                Button.unfulfilled

                              else
                                Button.error
                            , Button.onClick SubmitForm
                            ]
                        ]
    in
    ProgramTest.createSandbox
        { init = init
        , update = update
        , view = view >> Html.toUnstyled
        }
        |> ProgramTest.start ()


all : Test
all =
    describe "Nri.Ui.FormValidation.V1"
        [ test "renders the provided form" <|
            \() ->
                start
                    |> expectViewHas [ text "Form heading" ]
        , test "clicking the unfulfilled submit button shows validation errors" <|
            \() ->
                start
                    |> clickButton "Submit"
                    |> expectViewHas [ text "First name is required" ]
        , test "form starts without validation errors" <|
            \() ->
                start
                    |> expectViewHasNot [ text "First name is required" ]
        , test "clicking submit does not show errors for valid fields" <|
            \() ->
                start
                    |> fillIn (TextInput.generateId "First name") "First name" "Jeffy"
                    |> clickButton "Submit"
                    |> expectViewHasNot [ text "First name is required" ]
        , test "submitting with validation errors puts the button into error state" <|
            \() ->
                start
                    |> fillIn (TextInput.generateId "First name") "First name" " "
                    |> fillIn (TextInput.generateId "Last name") "Last name" "   "
                    |> clickButton "Submit"
                    |> expectView
                        (Query.find [ tag "button", containing [ text "Submit" ] ]
                            >> Query.has [ attribute (Html.Attributes.attribute "data-nri-button-state" "error") ]
                        )
        ]