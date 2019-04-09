module Nri.Ui.SlideModal.V2 exposing
    ( Config, Panel
    , State, closed, open
    , view
    )

{-|

@docs Config, Panel
@docs State, closed, open
@docs view

-}

import Accessibility.Styled as Html exposing (..)
import Accessibility.Styled.Aria exposing (labelledBy)
import Accessibility.Styled.Role as Role
import Accessibility.Styled.Style
import Accessibility.Styled.Widget as Widget
import Css
import Css.Animations
import Css.Global
import Html.Styled
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events exposing (onClick)
import Html.Styled.Keyed as Keyed
import Nri.Ui
import Nri.Ui.AssetPath exposing (Asset(..))
import Nri.Ui.Button.V8 as Button
import Nri.Ui.Colors.Extra
import Nri.Ui.Colors.V1 as Colors
import Nri.Ui.Fonts.V1 as Fonts
import Nri.Ui.Icon.V3 as Icon
import Nri.Ui.Text.V2 as Text


{-| -}
type alias Config msg =
    { panels : List Panel
    , height : Css.Vh
    , parentMsg : State -> msg
    }


{-| -}
type State
    = State
        { currentPanelIndex : Maybe Int
        , previousPanel : Maybe ( Direction, Panel )
        }


{-| Create the open state for the modal (the first panel will show).
-}
open : State
open =
    State
        { currentPanelIndex = Just 0
        , previousPanel = Nothing
        }


{-| Close the modal.
-}
closed : State
closed =
    State
        { currentPanelIndex = Nothing
        , previousPanel = Nothing
        }


{-| View the modal (includes the modal backdrop).
-}
view : Config msg -> State -> Html msg
view config ((State { currentPanelIndex }) as state) =
    case Maybe.andThen (summarize config.panels) currentPanelIndex of
        Just summary ->
            viewBackdrop
                (viewModal config state summary)

        Nothing ->
            Html.text ""


type alias Summary =
    { current : Panel
    , upcoming : List ( State, String )
    , previous : List ( State, String )
    }


summarize : List Panel -> Int -> Maybe Summary
summarize panels current =
    let
        indexedPanels =
            List.indexedMap (\i { title } -> ( i, title )) panels

        toOtherPanel direction currentPanel ( i, title ) =
            ( State
                { currentPanelIndex = Just i
                , previousPanel =
                    Just
                        ( direction
                        , { currentPanel | content = currentPanel.content }
                        )
                }
            , title
            )
    in
    case List.drop current panels of
        currentPanel :: rest ->
            Just
                { current = currentPanel
                , upcoming =
                    indexedPanels
                        |> List.drop (current + 1)
                        |> List.map (toOtherPanel FromRTL currentPanel)
                , previous =
                    indexedPanels
                        |> List.take current
                        |> List.map (toOtherPanel FromLTR currentPanel)
                }

        [] ->
            Nothing


viewModal : Config msg -> State -> Summary -> Html msg
viewModal config ((State { previousPanel }) as state) summary =
    let
        ( labelledById, currentPanel ) =
            viewCurrentPanel config.parentMsg summary
    in
    Keyed.node "div"
        [ css
            [ Css.width (Css.px 600)
            , Css.padding4 (Css.px 35) Css.zero (Css.px 25) Css.zero
            , Css.margin2 (Css.px 75) Css.auto
            , Css.backgroundColor Colors.white
            , Css.borderRadius (Css.px 20)
            , Css.property "box-shadow" "0 1px 10px 0 rgba(0, 0, 0, 0.35)"
            ]
        , Role.dialog
        , Widget.modal True
        , labelledBy labelledById
        ]
        (case previousPanel of
            Just ( direction, panelView ) ->
                [ viewPreviousPanel direction panelView
                    |> Tuple.mapSecond (Html.map (\_ -> config.parentMsg state))
                , ( labelledById, panelContainer config.height direction currentPanel )
                ]

            Nothing ->
                [ ( labelledById, panelContainer config.height FromRTL currentPanel )
                ]
        )


panelContainer : Css.Vh -> Direction -> List (Html msg) -> Html msg
panelContainer height direction panel =
    div
        [ css
            [ -- Layout
              Css.height height
            , Css.width (Css.px 600)
            , Css.minHeight (Css.px 360)
            , Css.maxHeight <| Css.calc (Css.vh 100) Css.minus (Css.px 100)

            -- Interior positioning
            , Css.displayFlex
            , Css.alignItems Css.center
            , Css.flexDirection Css.column
            , Css.flexWrap Css.noWrap

            -- Styles
            , Fonts.baseFont
            , animateIn direction
            ]
        ]
        panel


type Direction
    = FromRTL
    | FromLTR


animateIn : Direction -> Css.Style
animateIn direction =
    let
        ( start, end ) =
            case direction of
                FromRTL ->
                    ( Css.px 300, Css.zero )

                FromLTR ->
                    ( Css.px -300, Css.zero )
    in
    Css.batch
        [ Css.animationDuration (Css.ms 300)
        , Css.property "animation-timing-function" "ease-in-out"
        , Css.animationName
            (Css.Animations.keyframes
                [ ( 0
                  , [ Css.Animations.transform [ Css.translateX start ]
                    , Css.Animations.opacity (Css.int 0)
                    ]
                  )
                , ( 100
                  , [ Css.Animations.transform [ Css.translateX end ]
                    , Css.Animations.opacity (Css.int 100)
                    ]
                  )
                ]
            )
        ]


animateOut : Direction -> Css.Style
animateOut direction =
    let
        ( start, end ) =
            case direction of
                FromRTL ->
                    ( Css.zero, Css.px -100 )

                FromLTR ->
                    ( Css.zero, Css.px 100 )
    in
    Css.batch
        [ Css.position Css.absolute
        , Css.zIndex (Css.int -1)
        , Css.animationDuration (Css.ms 150)
        , Css.property "animation-timing-function" "ease-out"
        , Css.animationName
            (Css.Animations.keyframes
                [ ( 0
                  , [ Css.Animations.transform [ Css.translateX start ]
                    , Css.Animations.opacity (Css.int 100)
                    ]
                  )
                , ( 30, [ Css.Animations.opacity (Css.int 30) ] )
                , ( 100
                  , [ Css.Animations.transform [ Css.translateX end ]
                    , Css.Animations.opacity (Css.int 0)
                    ]
                  )
                ]
            )
        ]


viewBackdrop : Html msg -> Html msg
viewBackdrop modal =
    Nri.Ui.styled div
        "modal-backdrop-container"
        (Css.backgroundColor (Nri.Ui.Colors.Extra.withAlpha 0.9 Colors.navy)
            :: [ Css.height (Css.vh 100)
               , Css.left Css.zero
               , Css.overflow Css.hidden
               , Css.position Css.fixed
               , Css.top Css.zero
               , Css.width (Css.pct 100)
               , Css.zIndex (Css.int 200)
               , Css.displayFlex
               , Css.alignItems Css.center
               , Css.justifyContent Css.center
               ]
        )
        []
        [ -- This global <style> node sets overflow to hidden on the body element,
          -- thereby preventing the page from scrolling behind the backdrop when the modal is
          -- open (and this node is present on the page).
          Css.Global.global [ Css.Global.body [ Css.overflow Css.hidden ] ]
        , modal
        ]


{-| Configuration for a single modal view in the sequence of modal views.
-}
type alias Panel =
    { icon : Html Never
    , title : String
    , content : Html Never
    , buttonLabel : String
    }


viewCurrentPanel : (State -> msg) -> Summary -> ( String, List (Html msg) )
viewCurrentPanel parentMsg ({ current } as summary) =
    ( panelId current
    , [ viewIcon current.icon
      , Text.subHeading
            [ span [ Html.Styled.Attributes.id (panelId current) ] [ Html.text current.title ]
            ]
      , viewContent current.content
      , viewFooter summary |> Html.map parentMsg
      ]
    )


viewPreviousPanel : Direction -> Panel -> ( String, Html () )
viewPreviousPanel direction previousPanel =
    ( panelId previousPanel
    , div
        [ css [ animateOut direction ]
        ]
        [ viewIcon previousPanel.icon
        , Text.subHeading
            [ span [ Html.Styled.Attributes.id (panelId previousPanel) ] [ Html.text previousPanel.title ]
            ]
        , viewContent previousPanel.content
        , Html.div
            [ css
                [ Css.displayFlex
                , Css.flexDirection Css.column
                , Css.alignItems Css.center
                , Css.margin4 (Css.px 20) Css.zero Css.zero Css.zero
                ]
            ]
            [ Button.button
                { onClick = ()
                , size = Button.Large
                , style = Button.Primary
                , width = Button.WidthExact 230
                }
                { label = previousPanel.buttonLabel
                , state = Button.Disabled
                , icon = Nothing
                }
            , div [ css [ Css.marginTop (Css.px 16) ] ] []
            ]
        ]
    )


panelId : Panel -> String
panelId { title } =
    "modal-header__" ++ String.replace " " "-" title


viewContent : Html Never -> Html msg
viewContent content =
    Nri.Ui.styled div
        "modal-content"
        [ Css.overflowY Css.auto
        , Css.padding2 (Css.px 30) (Css.px 45)
        , Css.width (Css.pct 100)
        , Css.marginBottom Css.auto
        , Css.boxSizing Css.borderBox
        ]
        []
        [ Html.map never content ]


viewIcon : Html Never -> Html msg
viewIcon svg =
    div
        [ css
            [ Css.width (Css.px 100)
            , Css.height (Css.px 100)
            , Css.displayFlex
            , Css.alignItems Css.center
            , Css.justifyContent Css.center
            , Css.Global.children
                [ Css.Global.svg
                    [ Css.maxHeight (Css.px 100)
                    , Css.width (Css.px 100)
                    ]
                ]
            ]
        ]
        [ svg ]
        |> Html.map never


viewFooter : Summary -> Html State
viewFooter { previous, current, upcoming } =
    let
        nextPanel =
            List.head upcoming
                |> Maybe.map Tuple.first
                |> Maybe.withDefault closed
    in
    Nri.Ui.styled div
        "modal-footer"
        [ Css.displayFlex
        , Css.flexDirection Css.column
        , Css.alignItems Css.center
        , Css.margin4 (Css.px 20) Css.zero Css.zero Css.zero
        ]
        []
        [ viewFooterButton { label = current.buttonLabel, msg = nextPanel }
        , (List.map (uncurry Inactive) previous
            ++ Active
            :: List.map (uncurry InactiveDisabled) upcoming
          )
            |> List.map dot
            |> div [ css [ Css.marginTop (Css.px 16) ] ]
        ]


uncurry : (a -> b -> c) -> ( a, b ) -> c
uncurry f ( a, b ) =
    f a b


viewFooterButton : { label : String, msg : msg } -> Html msg
viewFooterButton { label, msg } =
    Button.button
        { onClick = msg
        , size = Button.Large
        , style = Button.Primary
        , width = Button.WidthExact 230
        }
        { label = label
        , state = Button.Enabled
        , icon = Nothing
        }


type Dot
    = Active
    | Inactive State String
    | InactiveDisabled State String


dot : Dot -> Html.Html State
dot type_ =
    let
        styles backgroundColor cursor =
            css
                [ Css.height (Css.px 10)
                , Css.width (Css.px 10)
                , Css.borderRadius (Css.px 5)
                , Css.margin2 Css.zero (Css.px 2)
                , Css.display Css.inlineBlock
                , Css.cursor cursor
                , Css.backgroundColor backgroundColor

                -- resets
                , Css.borderWidth Css.zero
                , Css.padding Css.zero
                , Css.hover [ Css.outline Css.none ]
                ]
    in
    case type_ of
        Active ->
            Html.div
                [ styles Colors.azure Css.auto
                ]
                []

        Inactive goTo title ->
            Html.button
                [ styles Colors.gray75 Css.pointer
                , onClick goTo
                ]
                [ span Accessibility.Styled.Style.invisible
                    [ text ("Go to " ++ title) ]
                ]

        InactiveDisabled goTo title ->
            Html.button
                [ styles Colors.gray75 Css.auto
                , Html.Styled.Attributes.disabled True
                ]
                [ span Accessibility.Styled.Style.invisible
                    [ text ("Go to " ++ title) ]
                ]
