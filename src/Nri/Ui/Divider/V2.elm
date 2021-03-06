module Nri.Ui.Divider.V2 exposing (view)

{-| Patch changes:

  - Title is navy, Muli, fontWeight 600

@docs view

-}

import Css exposing (..)
import Html.Styled as Html exposing (..)
import Nri.Ui.Colors.V1 as Colors
import Nri.Ui.Fonts.V1 as Fonts


{-| -}
view : String -> Html msg
view text =
    Html.styled div
        [ containerStyles ]
        []
        [ Html.styled div [ leftLineStyles ] [] []
        , Html.styled div [ titleStyles ] [] [ Html.text text ]
        , Html.styled div [ rightLineStyles ] [] []
        ]


containerStyles : Style
containerStyles =
    batch
        [ Css.width (pct 100)
        , Css.displayFlex
        , Css.alignItems Css.center
        ]


leftLineStyles : Style
leftLineStyles =
    batch
        [ Css.width (px 10)
        , Css.height (px 1)
        , backgroundColor Colors.gray75
        , marginTop (px 2)
        ]


rightLineStyles : Style
rightLineStyles =
    batch
        [ Css.flexGrow (Css.int 1)
        , backgroundColor Colors.gray75
        , Css.height (px 1)
        , marginTop (px 2)
        ]


titleStyles : Style
titleStyles =
    batch
        [ margin2 zero (px 5)
        , fontSize (px 12)
        , color Colors.navy
        , Fonts.baseFont
        , fontWeight (int 600)
        ]
