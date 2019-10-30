module Nri.Ui.Logo.V1 exposing (facebook, twitter, clever)

{-|

@docs facebook, twitter, clever

-}

import Nri.Ui.Svg.V1
import Svg.Styled as Svg
import Svg.Styled.Attributes as Attributes


{-| -}
facebook : Nri.Ui.Svg.V1.Svg
facebook =
    Svg.svg
        [ Attributes.width "100%"
        , Attributes.height "100%"
        , Attributes.fill "currentcolor"
        , Attributes.viewBox "0 0 10 19"
        ]
        [ Svg.path
            [ Attributes.d "M10 3.1H8.2c-1.4 0-1.7.7-1.7 1.6v2.1h3.4l-.5 3.4H6.5v8.6H2.9v-8.6H0V6.9h2.9V4.4C2.9 1.6 4.7 0 7.3 0c1.3 0 2.4.1 2.7.1v3z"
            ]
            []
        ]
        |> Nri.Ui.Svg.V1.fromHtml


{-| -}
clever : Nri.Ui.Svg.V1.Svg
clever =
    Svg.svg
        [ Attributes.width "100%"
        , Attributes.height "100%"
        , Attributes.fill "currentcolor"
        , Attributes.viewBox "0 0 87 20"
        ]
        [ Svg.g
            [ Attributes.fillRule "evenodd"
            ]
            [ Svg.path
                [ Attributes.d "M20.476 13.846a3.623 3.623 0 0 1-1.303-.726l.407-.836c.38.308.777.532 1.188.671.41.14.872.209 1.386.209.586 0 1.04-.11 1.363-.33.323-.22.485-.532.485-.935 0-.337-.15-.592-.451-.764-.301-.173-.778-.332-1.43-.479-.624-.132-1.133-.284-1.53-.457-.396-.172-.707-.403-.934-.692-.228-.29-.341-.662-.341-1.117 0-.455.12-.856.363-1.205.242-.348.584-.62 1.028-.813.444-.195.955-.292 1.534-.292.55 0 1.066.084 1.546.253.48.169.882.407 1.204.715l-.407.836c-.359-.3-.73-.522-1.11-.666a3.449 3.449 0 0 0-1.221-.214c-.565 0-1.009.12-1.331.358a1.146 1.146 0 0 0-.485.973c0 .352.142.62.424.803.282.183.735.348 1.358.495.653.147 1.181.3 1.584.462.404.161.726.381.968.66.243.279.363.638.363 1.078 0 .455-.12.85-.363 1.188-.242.337-.588.6-1.039.786-.451.188-.98.281-1.59.281-.608 0-1.164-.08-1.666-.242zm10.698-2.596h-3.96c.036 1.298.626 1.947 1.77 1.947.639 0 1.221-.209 1.75-.627l.34.792c-.249.22-.566.394-.951.522a3.65 3.65 0 0 1-1.16.193c-.888 0-1.584-.255-2.09-.764-.507-.51-.76-1.209-.76-2.096 0-.565.112-1.067.336-1.507.224-.44.537-.781.94-1.023a2.62 2.62 0 0 1 1.376-.363c.748 0 1.336.242 1.765.726.429.484.643 1.155.643 2.013v.187zm-3.41-1.727c-.265.25-.433.605-.506 1.067h2.937c-.045-.47-.187-.827-.43-1.072-.242-.246-.568-.369-.979-.369-.418 0-.758.125-1.023.374zm5.637 4.202a2.352 2.352 0 0 1-.952-.995c-.22-.43-.33-.93-.33-1.502s.116-1.078.347-1.518c.231-.44.555-.781.974-1.023.418-.242.905-.363 1.463-.363.388 0 .762.064 1.122.193.359.128.648.302.869.522l-.341.803c-.521-.41-1.045-.616-1.573-.616-.536 0-.954.174-1.255.522-.3.349-.45.838-.45 1.469 0 .63.15 1.116.45 1.457.301.342.72.512 1.255.512.542 0 1.066-.205 1.573-.616l.34.803c-.234.22-.533.392-.896.517a3.48 3.48 0 0 1-1.139.187c-.557 0-1.043-.117-1.457-.352zm9.355-5.269V14h-1.078v-.924a1.84 1.84 0 0 1-.725.742 2.103 2.103 0 0 1-1.046.259c-1.334 0-2.001-.74-2.001-2.222V8.456h1.1v3.388c0 .455.093.79.28 1.007.187.216.471.324.852.324.455 0 .82-.147 1.095-.44.275-.293.413-.682.413-1.166V8.456h1.11zm4.917-.055l-.022 1.012a1.855 1.855 0 0 0-.649-.11c-.506 0-.885.152-1.138.456-.253.305-.38.688-.38 1.15V14h-1.1v-3.982c0-.58-.029-1.1-.087-1.562h1.034l.098 1.001c.147-.367.374-.647.682-.841a1.898 1.898 0 0 1 1.035-.292c.168 0 .344.026.527.077zm5.468 2.849h-3.96c.036 1.298.626 1.947 1.77 1.947.639 0 1.221-.209 1.75-.627l.34.792c-.249.22-.566.394-.951.522a3.65 3.65 0 0 1-1.16.193c-.888 0-1.584-.255-2.09-.764-.507-.51-.76-1.209-.76-2.096 0-.565.112-1.067.336-1.507.224-.44.537-.781.94-1.023a2.62 2.62 0 0 1 1.375-.363c.749 0 1.337.242 1.766.726.429.484.644 1.155.644 2.013v.187zm-3.41-1.727c-.265.25-.433.605-.507 1.067h2.938c-.045-.47-.187-.827-.43-1.072-.242-.246-.568-.369-.978-.369-.419 0-.76.125-1.023.374zm8.618 4.323a3.623 3.623 0 0 1-1.303-.726l.407-.836c.38.308.777.532 1.188.671.41.14.872.209 1.386.209.586 0 1.04-.11 1.364-.33.322-.22.483-.532.483-.935 0-.337-.15-.592-.45-.764-.301-.173-.778-.332-1.43-.479-.624-.132-1.133-.284-1.53-.457-.396-.172-.707-.403-.934-.692-.228-.29-.342-.662-.342-1.117 0-.455.121-.856.363-1.205.243-.348.585-.62 1.029-.813.444-.195.955-.292 1.535-.292.55 0 1.065.084 1.545.253.48.169.882.407 1.205.715l-.407.836c-.36-.3-.73-.522-1.111-.666a3.449 3.449 0 0 0-1.221-.214c-.565 0-1.009.12-1.331.358a1.146 1.146 0 0 0-.485.973c0 .352.142.62.424.803.282.183.735.348 1.358.495.653.147 1.181.3 1.584.462.404.161.726.381.968.66.243.279.364.638.364 1.078 0 .455-.121.85-.364 1.188-.242.337-.588.6-1.039.786-.451.188-.98.281-1.59.281-.608 0-1.164-.08-1.666-.242zm10.929-5.39l-2.586 5.995c-.286.653-.643 1.131-1.072 1.435-.429.305-.959.508-1.59.611l-.242-.858c.521-.117.915-.27 1.183-.457s.482-.467.644-.841l.198-.462-2.333-5.423h1.178l1.737 4.29 1.772-4.29h1.11zm5.796 2.09V14h-1.11v-3.388c0-.484-.094-.836-.281-1.056-.187-.22-.486-.33-.897-.33-.469 0-.845.147-1.127.44-.282.293-.424.686-.424 1.177V14h-1.1v-3.982c0-.58-.029-1.1-.088-1.562h1.035l.099.957c.176-.352.43-.621.764-.809.334-.187.713-.28 1.139-.28 1.327 0 1.99.74 1.99 2.222zm2.536 3.179a2.352 2.352 0 0 1-.951-.995c-.22-.43-.33-.93-.33-1.502s.115-1.078.346-1.518c.231-.44.555-.781.974-1.023.418-.242.905-.363 1.463-.363.388 0 .762.064 1.122.193.359.128.648.302.869.522l-.341.803c-.521-.41-1.045-.616-1.573-.616-.536 0-.954.174-1.254.522-.301.349-.451.838-.451 1.469 0 .63.15 1.116.45 1.457.301.342.72.512 1.255.512.542 0 1.066-.205 1.573-.616l.34.803c-.234.22-.533.392-.896.517a3.48 3.48 0 0 1-1.139.187c-.557 0-1.043-.117-1.457-.352zM5 9.656C5 6.533 7.322 4 10.65 4c2.044 0 3.266.684 4.273 1.678l-1.517 1.756c-.836-.761-1.688-1.227-2.771-1.227-1.827 0-3.143 1.522-3.143 3.387 0 1.896 1.285 3.45 3.143 3.45 1.238 0 1.997-.498 2.848-1.275L15 13.308c-1.115 1.196-2.353 1.942-4.443 1.942C7.368 15.25 5 12.78 5 9.656z"
                ]
                []
            ]
        ]
        |> Nri.Ui.Svg.V1.fromHtml


{-| -}
twitter : Nri.Ui.Svg.V1.Svg
twitter =
    Svg.svg
        [ Attributes.width "100%"
        , Attributes.height "100%"
        , Attributes.fill "currentcolor"
        , Attributes.viewBox "0 0 20 16"
        ]
        [ Svg.path
            [ Attributes.d "M17.9 4.5c0 5.3-4.1 11.4-11.6 11.4-2.3 0-4.5-.7-6.3-1.8h1c1.9 0 3.7-.6 5.1-1.7-1.8 0-3.3-1.2-3.8-2.8.3 0 .5.1.8.1.4 0 .7 0 1.1-.1C2.3 9.2.9 7.6.9 5.7c.5.2 1.1.4 1.8.4C1.6 5.4.9 4.1.9 2.7c0-.7.2-1.4.6-2 2 2.4 5 4 8.4 4.2-.2-.3-.2-.6-.2-.9 0-2.2 1.8-4 4.1-4 1.2 0 2.2.5 3 1.3.9-.2 1.8-.5 2.6-1-.3.9-.9 1.7-1.8 2.2.8-.1 1.6-.3 2.3-.6-.6.8-1.3 1.5-2 2.1v.5z"
            ]
            []
        ]
        |> Nri.Ui.Svg.V1.fromHtml
