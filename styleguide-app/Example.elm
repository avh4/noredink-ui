module Example exposing (Example, view, wrapMsg, wrapState)

import AtomicDesignType exposing (AtomicDesignType)
import Category exposing (Category)
import Css exposing (..)
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attributes
import KeyboardSupport exposing (KeyboardSupport)
import Nri.Ui.Colors.V1 exposing (..)
import Nri.Ui.Html.Attributes.V2 as AttributeExtras exposing (targetBlank)


type alias Example state msg =
    { name : String
    , state : state
    , update : msg -> state -> ( state, Cmd msg )
    , subscriptions : state -> Sub msg
    , view : state -> List (Html msg)
    , categories : List Category
    , atomicDesignType : AtomicDesignType
    , keyboardSupport : List KeyboardSupport
    }


wrapMsg :
    (msg -> msg2)
    -> (msg2 -> Maybe msg)
    -> Example state msg
    -> Example state msg2
wrapMsg wrapMsg_ unwrapMsg example =
    { name = example.name
    , state = example.state
    , update =
        \msg2 state ->
            case unwrapMsg msg2 of
                Just msg ->
                    example.update msg state
                        |> Tuple.mapSecond (Cmd.map wrapMsg_)

                Nothing ->
                    ( state, Cmd.none )
    , subscriptions = \state -> Sub.map wrapMsg_ (example.subscriptions state)
    , view = \state -> List.map (Html.map wrapMsg_) (example.view state)
    , categories = example.categories
    , atomicDesignType = example.atomicDesignType
    , keyboardSupport = example.keyboardSupport
    }


wrapState :
    (state -> state2)
    -> (state2 -> Maybe state)
    -> Example state msg
    -> Example state2 msg
wrapState wrapState_ unwrapState example =
    { name = example.name
    , state = wrapState_ example.state
    , update =
        \msg state2 ->
            case unwrapState state2 of
                Just state ->
                    example.update msg state
                        |> Tuple.mapFirst wrapState_

                Nothing ->
                    ( state2, Cmd.none )
    , subscriptions =
        unwrapState
            >> Maybe.map example.subscriptions
            >> Maybe.withDefault Sub.none
    , view =
        unwrapState
            >> Maybe.map example.view
            >> Maybe.withDefault []
    , categories = example.categories
    , atomicDesignType = example.atomicDesignType
    , keyboardSupport = example.keyboardSupport
    }


view : Bool -> Example state msg -> Html msg
view showFocusLink example =
    Html.div
        [ -- this class makes the axe accessibility checking output easier to parse
          String.replace "." "-" example.name
            |> (++) "module-example__"
            |> Attributes.class
        ]
        [ Html.div
            [ Attributes.css
                [ displayFlex
                , alignItems center
                , justifyContent flexStart
                , flexWrap Css.wrap
                , padding (px 4)
                , backgroundColor glacier
                ]
            ]
            [ Html.styled Html.h2
                [ color gray20
                , fontFamilies [ qt "Source Code Pro", "Consolas", "Courier", "monospace" ]
                , fontSize (px 20)
                , marginTop zero
                , marginBottom zero
                ]
                []
                [ Html.a [ Attributes.href ("#/doodad/" ++ example.name) ] [ Html.text example.name ] ]
            , String.replace "." "-" example.name
                |> (++) "https://package.elm-lang.org/packages/NoRedInk/noredink-ui/latest/"
                |> viewLink "Docs"
            , String.replace "." "/" example.name
                ++ ".elm"
                |> (++) "https://github.com/NoRedInk/noredink-ui/blob/master/src/"
                |> viewLink "Source"
            ]
        , KeyboardSupport.view example.keyboardSupport
        , Html.div [ Attributes.css [ padding2 (px 20) zero ] ] (example.view example.state)
        ]


viewLink : String -> String -> Html msg
viewLink text href =
    Html.a
        ([ Attributes.href href
         , Attributes.css [ Css.display Css.block, marginLeft (px 20) ]
         ]
            ++ targetBlank
        )
        [ Html.text text
        ]
