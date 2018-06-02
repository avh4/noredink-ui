module Nri.Ui.TextArea.V3
    exposing
        ( Height(..)
        , HeightBehavior(..)
        , Model
        , contentCreation
        , generateId
        , view
        , writing
        )

{-|


## Upgrading to V3

  - Do nothing! (This just uses new elm-css styles)


## The Nri styleguide-specified textarea with overlapping label

@docs view, writing, contentCreation, Height, HeightBehavior, Model, generateId

-}

import Accessibility.Styled.Style
import Css exposing ((|+|))
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attributes
import Html.Styled.Events as Events
import Json.Encode as Encode
import Nri.Ui
import Nri.Ui.InputStyles.V2 as InputStyles
    exposing
        ( Theme(..)
        , input
        , label
        )
import Nri.Ui.Util exposing (dashify, removePunctuation)


{-| -}
type alias Model msg =
    { value : String
    , autofocus : Bool
    , onInput : String -> msg
    , isInError : Bool
    , height : HeightBehavior
    , placeholder : String
    , label : String
    , showLabel : Bool
    }


{-| Control whether to auto-expand the height.
-}
type HeightBehavior
    = Fixed
    | AutoResize Height


{-| For specifying the actual height.
-}
type Height
    = DefaultHeight
    | SingleLine


{-| -}
view : Model msg -> Html msg
view model =
    view_ Standard model


{-| Used for Writing Cycles
-}
writing : Model msg -> Html msg
writing model =
    view_ Writing2 model


{-| Used for Content Creation
-}
contentCreation : Model msg -> Html msg
contentCreation model =
    view_ ContentCreation2 model


{-| -}
view_ : Theme -> Model msg -> Html msg
view_ theme model =
    let
        ( minHeight, autoresize ) =
            case model.height of
                Fixed ->
                    ( Css.batch [], False )

                AutoResize minimumHeight ->
                    ( Css.minHeight (calculateMinHeight theme minimumHeight)
                    , True
                    )
    in
    Nri.Ui.styled Html.div
        "Nri.TextArea.V3"
        [ Css.position Css.relative ]
        []
        [ Html.node "nri-textarea-v3"
            [ Attributes.property "autoresize" (Encode.bool autoresize) ]
            [ Html.textarea
                [ Events.onInput model.onInput
                , Attributes.id (generateId model.label)
                , Attributes.autofocus model.autofocus
                , Attributes.placeholder model.placeholder
                , Attributes.attribute "data-gramm" "false" -- disables grammarly to prevent https://github.com/NoRedInk/NoRedInk/issues/14859
                , Attributes.css
                    [ minHeight
                    , Css.boxSizing Css.borderBox
                    , InputStyles.input theme model.isInError
                    ]
                ]
                [ Html.text model.value ]
            ]
        , if not model.showLabel then
            Html.label
                [ Attributes.for (generateId model.label)
                , Attributes.css [ InputStyles.label theme model.isInError ]
                , Accessibility.Styled.Style.invisible
                ]
                [ Html.text model.label ]
          else
            Html.label
                [ Attributes.for (generateId model.label)
                , Attributes.css [ InputStyles.label theme model.isInError ]
                ]
                [ Html.text model.label ]
        ]


calculateMinHeight : Theme -> Height -> Css.Px
calculateMinHeight textAreaStyle specifiedHeight =
    {- On including padding in this calculation:

       When the textarea is autoresized, TextArea.js updates the textarea's
       height by taking its scrollHeight. Because scrollHeight's calculation
       includes the element's padding no matter what [1], we need to set the
       textarea's box-sizing to border-box in order to use the same measurement
       for its height as scrollHeight.

       So, min-height also needs to be specified in terms of padding + content
       height.

       [1] https://developer.mozilla.org/en-US/docs/Web/API/Element/scrollHeight
    -}
    case specifiedHeight of
        SingleLine ->
            case textAreaStyle of
                Standard ->
                    singleLineHeight

                Writing2 ->
                    writingSingleLineHeight

                ContentCreation2 ->
                    singleLineHeight

        DefaultHeight ->
            case textAreaStyle of
                Standard ->
                    InputStyles.textAreaHeight

                Writing2 ->
                    InputStyles.writingMinHeight

                ContentCreation2 ->
                    InputStyles.textAreaHeight


singleLineHeight : Css.Px
singleLineHeight =
    InputStyles.inputPaddingVertical |+| InputStyles.inputLineHeight |+| InputStyles.inputPaddingVertical


writingSingleLineHeight : Css.Px
writingSingleLineHeight =
    InputStyles.writingPaddingTop |+| InputStyles.writingLineHeight |+| InputStyles.writingPadding


{-| -}
generateId : String -> String
generateId labelText =
    "nri-ui-text-area-" ++ (dashify <| removePunctuation labelText)