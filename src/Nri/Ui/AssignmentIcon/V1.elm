module Nri.Ui.AssignmentIcon.V1 exposing
    ( diagnostic, practice, quiz
    , quickWrite, guidedDraft
    , selfReview
    , peerReview, submitting
    )

{-|

@docs diagnostic, practice, quiz
@docs quickWrite, guidedDraft
@docs selfReview
@docs peerReview, submitting

    import Css
    import Html.Styled exposing (..)
    import Html.Styled.Attrbutes exposing (css)
    import Nri.Ui.AssignmentIcon.V1 as AssignmentIcon
    import Nri.Ui.Colors.V1 as Colors
    import Nri.Ui.Svg.V1 as Svg

    view : Html msg
    view =
        div
            [ css [ Css.color Colors.lichen ]
            ]
            [ Svg.toHtml AssignmentIcon.diagnostic ]

-}

import Nri.Ui.Svg.V1
import Svg.Styled as Svg
import Svg.Styled.Attributes as Attributes


{-| -}
diagnostic : Nri.Ui.Svg.V1.Svg
diagnostic =
    Svg.svg
        [ Attributes.x "0px"
        , Attributes.y "0px"
        , Attributes.viewBox "0 0 43.8 41"
        , Attributes.style "enable-background:new 0 0 43.8 41;"
        , Attributes.fill "currentcolor"
        , Attributes.width "100%"
        , Attributes.height "100%"
        ]
        [ Svg.path [ Attributes.d "M32.5,41c-1.1,0-2.1-0.4-2.9-1.1c-1.6-1.5-1.6-3.9-0.2-5.5c0,0,0,0,0,0l0.2-0.2c0.2-0.2,0.3-0.4,0.5-0.6H12.4l-0.1-0.1l0,0 l-0.1-0.1l0,0l-0.1-0.1l0,0L12,33l0,0c0,0,0-0.1,0-0.1l0,0c0,0,0-0.1,0-0.1v-0.1l0,0c0.1-0.9,0.5-1.8,1.2-2.4c0.9-0.8,1-2.2,0.1-3.1 c0,0-0.1-0.1-0.1-0.1c-1-0.9-2.6-0.9-3.6,0c-0.9,0.8-1,2.2-0.1,3.1l0.1,0.2c0.7,0.6,1.1,1.5,1.2,2.4c0.1,0.4-0.1,0.9-0.6,1 c0,0,0,0,0,0H10H0.8c-0.4,0-0.8-0.4-0.8-0.8v-11l0,0c0,0,0,0,0-0.1v-0.4l0.1-0.1h0.1h0.7c0.9,0.1,1.8,0.5,2.4,1.2 c0.4,0.5,1,0.7,1.6,0.7c0.6,0,1.2-0.3,1.6-0.7c0.9-1,0.9-2.6,0-3.7c-0.8-0.9-2.1-1-3-0.2c-0.1,0.1-0.1,0.1-0.2,0.2 c-0.6,0.7-1.5,1.2-2.5,1.2H0.2L0.1,20l0,0l-0.1-0.1l0,0L0,19.9l0,0v-0.1l0,0c0,0,0-0.1,0-0.1l0,0V8.2c0-0.4,0.4-0.8,0.8-0.8h8.1 C8.8,7.2,8.6,7,8.5,6.8C6.9,5.3,6.8,2.9,8.3,1.3l0.2-0.2c1.6-1.5,4.2-1.5,5.8,0c1.6,1.4,1.6,3.9,0.2,5.4l-0.2,0.2 c-0.2,0.2-0.3,0.4-0.5,0.6h17.7h0.1l0,0l0.1,0.1l0,0c0.2,0.2,0.2,0.4,0.2,0.7c-0.1,0.9-0.5,1.8-1.2,2.4c-0.9,0.9-1,2.3-0.1,3.3 c0,0,0.1,0.1,0.1,0.1c1,0.9,2.6,0.9,3.6,0c0.9-0.8,1-2.2,0.2-3.1l-0.2-0.1C33.5,10,33.1,9.2,33,8.3c0-0.1,0-0.2,0-0.2 c0-0.4,0.4-0.8,0.8-0.8H43c0.4,0,0.8,0.4,0.8,0.8v11c0,0,0,0.1,0,0.1l0,0v0.1l0,0v0.1l0,0l-0.1,0.1l0,0l-0.1,0.1l0,0l-0.1,0.1H43 c-0.9-0.1-1.8-0.5-2.4-1.2c-0.4-0.5-1-0.7-1.6-0.7c-0.6,0-1.2,0.3-1.6,0.7c-0.9,1-0.9,2.6,0,3.7c0.8,0.9,2.1,1,3,0.2 c0.1-0.1,0.2-0.1,0.2-0.2c0.6-0.6,1.5-1,2.4-1.1l0,0c0.4,0,0.8,0.3,0.8,0.8c0,0,0,0.1,0,0.1c0,0,0,0.1,0,0.1v10.9 c0,0.4-0.4,0.8-0.8,0.8h-8.1c0.1,0.2,0.3,0.4,0.4,0.6c1.6,1.4,1.6,3.9,0.2,5.4l-0.2,0.2C34.6,40.6,33.5,41,32.5,41z M31.9,33 c-0.1,0.9-0.5,1.8-1.2,2.4c-0.9,0.8-1,2.2-0.2,3.1l0.2,0.2c1,0.9,2.6,0.9,3.6,0c0.9-0.8,1-2.2,0.2-3.1l-0.2-0.2 c-0.7-0.6-1.1-1.5-1.2-2.4c0-0.1,0-0.1,0-0.2c0-0.2,0.1-0.4,0.2-0.5l0,0l0.1-0.1l0,0l0.1-0.1h8.7V23c-0.2,0.1-0.4,0.3-0.6,0.5 c-1.3,1.5-3.7,1.7-5.2,0.3c-0.1-0.1-0.2-0.2-0.3-0.3c-1.5-1.7-1.5-4.2,0-5.9c1.4-1.5,3.7-1.7,5.2-0.3c0.1,0.1,0.2,0.2,0.3,0.3 c0.2,0.2,0.4,0.3,0.6,0.5V9h-7.3c0.1,0.3,0.3,0.6,0.5,0.8c1.6,1.4,1.6,3.9,0.2,5.4l-0.2,0.2c-1.6,1.5-4.2,1.5-5.8,0 C28,14,27.9,11.5,29.4,10l0.2-0.2C29.8,9.6,29.9,9.3,30,9h-7.3v8.8c0.2-0.1,0.4-0.3,0.6-0.5c1.4-1.5,3.7-1.7,5.2-0.3 c0.1,0.1,0.2,0.2,0.3,0.3c1.5,1.7,1.5,4.2,0,5.9c-0.7,0.8-1.7,1.2-2.8,1.2c-1.1,0-2.1-0.5-2.8-1.2c-0.2-0.2-0.4-0.3-0.6-0.5V32h8.4 c0.1,0,0.3,0.1,0.4,0.1l0,0l0.1,0.1l0,0v0.1v0.1l0,0c0.1,0.1,0.1,0.3,0.1,0.4C31.7,32.8,31.8,32.9,31.9,33L31.9,33z M21.1,32V21.7 l0,0c0-0.4,0.3-0.8,0.7-0.8c0,0,0,0,0,0H22c1,0.1,1.8,0.5,2.5,1.2c0.4,0.5,1,0.7,1.6,0.7c0.6,0,1.2-0.3,1.6-0.7c0.9-1,0.9-2.6,0-3.7 c-0.8-0.9-2.1-1-3-0.2c-0.1,0.1-0.1,0.1-0.2,0.2c-0.6,0.7-1.5,1.2-2.5,1.2h-0.1c-0.4,0-0.8-0.3-0.8-0.8c0,0,0-0.1,0-0.1l0,0V9h-8.4 c-0.4,0-0.8-0.4-0.8-0.8l0,0c0.1-1,0.5-1.9,1.2-2.5c0.9-0.8,1-2.2,0.1-3.1l-0.1-0.1c-1-0.9-2.6-0.9-3.6,0c-0.9,0.8-1,2.2-0.1,3.1 l0.1,0.1c0.7,0.6,1.1,1.4,1.2,2.3c0,0.1,0,0.1,0,0.2C10.8,8.6,10.4,9,10,9H1.6v9c0.2-0.1,0.4-0.3,0.6-0.5c1.4-1.5,3.7-1.7,5.2-0.3 c0.1,0.1,0.2,0.2,0.3,0.3c1.5,1.7,1.5,4.2,0,5.9C7,24.2,6,24.7,5,24.7c-1.1,0-2.1-0.5-2.8-1.2c-0.2-0.2-0.4-0.3-0.6-0.5v9H9 c-0.1-0.2-0.3-0.4-0.5-0.6c-1.6-1.4-1.6-3.9-0.2-5.4l0.2-0.2c1.6-1.5,4.2-1.5,5.8,0c1.6,1.4,1.6,3.9,0.2,5.4l-0.2,0.2 c-0.2,0.2-0.3,0.4-0.5,0.6L21.1,32z" ] [] ]
        |> Nri.Ui.Svg.V1.fromHtml


{-| -}
peerReview : Nri.Ui.Svg.V1.Svg
peerReview =
    Svg.svg
        [ Attributes.width "100%"
        , Attributes.height "100%"
        , Attributes.viewBox "0 0 57 58"
        ]
        [ Svg.g
            [ Attributes.fill "currentcolor"
            , Attributes.fillRule "evenodd"
            ]
            [ Svg.path [ Attributes.d "M16.441 43.288v-10.59l.002-.095v-3.781l-1.263 2.46c-.373.728-1.244 1.029-1.945.668-.7-.36-.966-1.243-.593-1.97l2.476-4.826c.044-.083.092-.162.147-.232a1.648 1.648 0 0 1 1.558-1.11h4.399l-2.218 4.32c-.723 1.414-.238 3.208 1.228 3.963.919.47 1.944.392 2.758-.08l.056-.036v11.309H20.16v-9.093h-.751v9.093h-2.968zm.45-23.648a2.95 2.95 0 1 1 5.903 0 2.953 2.953 0 0 1-2.952 2.952 2.952 2.952 0 0 1-2.95-2.952z" ] []
            , Svg.path [ Attributes.d "M24.376 43.288v-11.55c0-.035 0-.07.002-.108V27.464l-1.392 2.71c-.412.805-1.373 1.135-2.146.739-.774-.396-1.064-1.371-.653-2.174l2.729-5.319c.047-.091.102-.176.162-.255a1.818 1.818 0 0 1 1.716-1.224h6.54c.796 0 1.472.512 1.717 1.224.06.079.114.164.161.255l2.73 5.32c.412.802.12 1.777-.654 2.173-.773.396-1.734.066-2.144-.739l-1.392-2.708v4.104c0 .054-.002.106-.008.158v11.56h-3.291v-9.901h-.786v9.9h-3.291zm3.744-29.2h.006a3.255 3.255 0 0 1 3.251 3.253 3.255 3.255 0 0 1-3.254 3.254 3.255 3.255 0 0 1-3.254-3.254 3.255 3.255 0 0 1 3.251-3.253z" ] []
            , Svg.path [ Attributes.d "M33.073 43.288V31.972l.065.044c.815.47 1.84.55 2.758.079 1.468-.755 1.951-2.549 1.228-3.963l-2.217-4.32h4.398c.722 0 1.336.464 1.558 1.11.053.072.103.149.147.232l2.476 4.825c.373.728.108 1.612-.593 1.97-.7.362-1.572.06-1.947-.667l-1.261-2.46v3.725c0 .048-.002.095-.007.143V43.288h-2.967v-9.093h-.75v9.093h-2.888zm.37-23.648a2.951 2.951 0 1 1 5.902 0 2.953 2.953 0 0 1-2.951 2.952 2.953 2.953 0 0 1-2.952-2.952zM52.869 45.376c.773-.062 1.091.482 1.13.966.038.483-.191 1.072-.965 1.133l-4.29.343c-.01 0-.02-.005-.032-.004-.017.005-.035.012-.052.013-.483.038-1.07-.192-1.13-.968l-.342-4.303a1.053 1.053 0 0 1 .962-1.133 1.052 1.052 0 0 1 1.13.966l.155 1.953c6.516-8.931 6.1-23.482-1.259-31.686-.599-.663-.442-1.286-.099-1.634.336-.344.997-.505 1.661.226 8.007 8.926 8.49 24.528 1.453 34.262l1.678-.134zm-6.36-37.96c.004.018.011.035.012.053.039.484-.19 1.068-.966 1.13l-4.305.343a1.054 1.054 0 0 1-1.132-.963 1.051 1.051 0 0 1 .964-1.13l1.955-.155C34.105.178 19.554.593 11.35 7.954c-.662.6-1.285.441-1.633.097-.345-.335-.506-.994.227-1.66 8.925-8.008 24.527-8.489 34.26-1.452l-.133-1.678c-.062-.774.481-1.092.965-1.13.485-.04 1.072.19 1.133.963l.344 4.292c0 .01-.004.02-.004.03zm-.573 42.24c.343.34.503 1.001-.227 1.668-8.898 8.032-24.453 8.514-34.157 1.457l.133 1.683c.062.775-.479 1.094-.961 1.134-.483.038-1.068-.192-1.13-.967l-.342-4.304c-.001-.012.004-.022.003-.033-.002-.017-.011-.035-.012-.052-.039-.485.192-1.072.963-1.133l4.292-.343a1.052 1.052 0 0 1 .168 2.098l-1.932.154c8.905 6.53 23.398 6.119 31.573-1.26.66-.602 1.282-.445 1.63-.101zM6.848 15.622l-.154-1.954C.178 22.598.594 37.15 7.953 45.352c.6.663.442 1.288.099 1.634-.335.345-.996.506-1.66-.227-8.008-8.925-8.49-24.526-1.453-34.26l-1.679.134c-.772.062-1.091-.482-1.13-.966-.038-.485.19-1.071.964-1.133l4.292-.343c.01-.001.02.003.03.003.019 0 .036-.01.054-.012.483-.037 1.068.192 1.13.966l.342 4.306a1.052 1.052 0 0 1-.964 1.131 1.052 1.052 0 0 1-1.13-.964z" ] []
            ]
        ]
        |> Nri.Ui.Svg.V1.fromHtml


{-| -}
practice : Nri.Ui.Svg.V1.Svg
practice =
    Svg.svg
        [ Attributes.x "0px"
        , Attributes.y "0px"
        , Attributes.viewBox "0 0 42.1 42"
        , Attributes.style "enable-background:new 0 0 42.1 42;"
        , Attributes.fill "currentcolor"
        , Attributes.width "100%"
        , Attributes.height "100%"
        ]
        [ Svg.path [ Attributes.d "M36.1,9.5l-1.9-0.3l2.9-2.9L39,6.6L36.1,9.5z M20.5,40c-3.7,0-7.2-1.1-10.3-3.1c-0.3-0.2-0.6-0.2-0.9-0.1l-6.7,2.5l2.5-6.7 c0.1-0.3,0.1-0.6-0.1-0.9c-5.7-8.5-3.4-20,5.1-25.6c6-4,13.7-4.2,19.9-0.5L26.7,9c-6.9-3.4-15.3-0.6-18.8,6.3s-0.6,15.3,6.3,18.8 c6.9,3.4,15.3,0.6,18.8-6.3c2-3.9,2-8.6,0-12.5l3.3-3.3c5.3,8.7,2.5,20.1-6.2,25.4C27.2,39.1,23.9,40,20.5,40z M31.5,14l-1.9-0.3 l2.9-2.9l1.9,0.3L31.5,14z M31.1,9.5l-2.9,2.9L28,10.5l2.9-2.9L31.1,9.5z M26.1,21.5c0,3.1-2.5,5.5-5.5,5.5c-3.1,0-5.5-2.5-5.5-5.5 c0-3.1,2.5-5.5,5.5-5.5c1.1,0,2.2,0.3,3.2,1l-3.4,3.4c-0.6,0.2-1,0.8-0.8,1.4c0.2,0.6,0.8,1,1.4,0.8c0.4-0.1,0.7-0.4,0.8-0.8 l3.4-3.4C25.7,19.3,26,20.4,26.1,21.5z M26.1,10.9l0.5,3.2l-1.5,1.5c-3.3-2.5-8-1.9-10.5,1.4c-2.5,3.3-1.9,8,1.4,10.5 s8,1.9,10.5-1.4c2.1-2.7,2.1-6.4,0-9.1l1.5-1.5l3.2,0.5c3.1,5.9,0.8,13.1-5,16.2c-5.9,3.1-13.1,0.8-16.2-5s-0.8-13.1,5-16.2 C18.4,9.1,22.6,9.1,26.1,10.9z M35.5,3l0.3,1.9l-2.9,2.9l-0.3-1.9L35.5,3z M42,5.5c-0.1-0.3-0.4-0.6-0.8-0.7l-3.5-0.5l-0.5-3.6 C37,0.3,36.5-0.1,36,0c-0.2,0-0.4,0.1-0.5,0.2l-4,4C22-1.8,9.4,0.9,3.3,10.4c-4.3,6.7-4.3,15.4,0,22.1l-3.1,8.2 c-0.2,0.5,0.1,1.1,0.7,1.2c0.1,0,0.2,0,0.3,0c0.1,0,0.2,0,0.3-0.1l8.2-3.1c9.5,6,22.2,3.2,28.2-6.4c4.2-6.7,4.2-15.2,0-21.9l4-4 C42,6.3,42.1,5.9,42,5.5L42,5.5z" ] [] ]
        |> Nri.Ui.Svg.V1.fromHtml


{-| -}
quiz : Nri.Ui.Svg.V1.Svg
quiz =
    Svg.svg
        [ Attributes.x "0px"
        , Attributes.y "0px"
        , Attributes.viewBox "0 0 37.9 44.7"
        , Attributes.style "enable-background:new 0 0 37.9 44.7;"
        , Attributes.fill "currentcolor"
        , Attributes.width "100%"
        , Attributes.height "100%"
        ]
        [ Svg.path [ Attributes.d "M35.8,3.8l0.9,0.1l-0.9,8.5V3.8z M34.6,3.6v38.8H2.8V2.6h31.9L34.6,3.6z M1.2,40.8l0.5-3.1v3.1L1.2,40.8z M4.9,1.2L9,1.6 H4.9V1.2z M35.8,2.6V1.5H22.3L3.9,0L3.8,1.5H1.6v22.8L0,41.8l1.6,0.1v1.6h18.7L34,44.7l0.1-1.1h1.7V25.8l2.1-22.9L35.8,2.6z" ] [], Svg.path [ Attributes.d "M9.5,8.1l-2.3,2.8l-0.7-1C6.3,9.6,6,9.5,5.7,9.7c-0.3,0.2-0.3,0.5-0.2,0.8l0,0l0,0l1.1,1.7c0.1,0.1,0.3,0.2,0.4,0.2l0,0 c0.2,0,0.3-0.1,0.4-0.2l2.8-3.3c0.2-0.2,0.2-0.6-0.1-0.8C10,7.8,9.6,7.9,9.5,8.1L9.5,8.1z" ] [], Svg.path [ Attributes.d "M9.5,14.2l-2.3,2.8l-0.7-1c-0.2-0.3-0.5-0.3-0.8-0.2c-0.3,0.2-0.3,0.5-0.2,0.8l0,0l1.1,1.7c0.1,0.1,0.3,0.2,0.4,0.2l0,0 c0.2,0,0.3-0.1,0.4-0.2l2.8-3.3c0.2-0.2,0.2-0.6-0.1-0.8C10.1,14,10,14,9.9,14C9.7,14,9.6,14.1,9.5,14.2z" ] [], Svg.path [ Attributes.d "M9.5,26.4l-2.3,2.8l-0.7-1c-0.2-0.3-0.5-0.3-0.8-0.2c-0.3,0.2-0.3,0.5-0.1,0.8l1.1,1.7c0.1,0.1,0.3,0.2,0.4,0.2l0,0 c0.2,0,0.3-0.1,0.4-0.2l2.8-3.3c0.2-0.2,0.2-0.6-0.1-0.8c-0.1-0.1-0.2-0.2-0.3-0.2C9.7,26.2,9.6,26.2,9.5,26.4z" ] [], Svg.path [ Attributes.d "M9.5,32.4l-2.3,2.8l-0.7-1C6.3,33.9,6,33.9,5.7,34c-0.3,0.2-0.3,0.5-0.2,0.8l0,0l1.1,1.7c0.1,0.1,0.3,0.2,0.4,0.2l0,0 c0.2,0,0.3-0.1,0.4-0.2l2.8-3.3c0.2-0.2,0.2-0.6-0.1-0.8C10,32.2,9.6,32.2,9.5,32.4L9.5,32.4z" ] [], Svg.path [ Attributes.d "M5.9,20.8C5.7,21,5.7,21.4,6,21.6l1.1,1l-1.1,1c-0.2,0.2-0.2,0.5-0.1,0.8c0.1,0.1,0.2,0.2,0.4,0.2c0.1,0,0.2,0,0.3-0.1 l1.2-1.1l1.2,1.1c0.1,0.1,0.2,0.1,0.3,0.1c0.2,0,0.3-0.1,0.4-0.2c0.2-0.2,0.2-0.6-0.1-0.8l-1.1-1l1.1-1c0.2-0.2,0.2-0.5,0.1-0.8 c-0.2-0.2-0.5-0.3-0.7-0.1l0,0l-1.2,1.1l-1.2-1.1c-0.1-0.1-0.3-0.1-0.4,0C6.1,20.6,6,20.7,5.9,20.8z" ] [], Svg.path [ Attributes.d "M13.1,35.9c-0.6,0-1-0.4-1-1s0.4-1,1-1h6.2c0.6,0,1,0.4,1,1s-0.4,1-1,1H13.1z" ] [], Svg.path [ Attributes.d "M13.1,29.5c-0.6,0-1-0.4-1-1s0.4-1,1-1H30c0.6,0,1,0.4,1,1s-0.4,1-1,1H13.1z" ] [], Svg.path [ Attributes.d "M13.1,22.9c-0.6,0-1-0.4-1-1s0.4-1,1-1H30c0.6,0,1,0.4,1,1s-0.4,1-1,1H13.1z" ] [], Svg.path [ Attributes.d "M13.1,16.5c-0.5,0-1-0.4-1-0.9v-0.1c0-0.6,0.4-1,1-1H30c0.6,0,1,0.4,1,1s-0.4,1-1,1L13.1,16.5z" ] [], Svg.path [ Attributes.d "M13.1,10.1c-0.5,0-1-0.4-1-0.9V9c0-0.6,0.4-1,1-1H30c0.6,0,1,0.4,1,1s-0.4,1-1,1L13.1,10.1z" ] [] ]
        |> Nri.Ui.Svg.V1.fromHtml


{-| -}
quickWrite : Nri.Ui.Svg.V1.Svg
quickWrite =
    Svg.svg
        [ Attributes.width "100%"
        , Attributes.height "100%"
        , Attributes.viewBox "0 0 48 37"
        ]
        [ Svg.g
            [ Attributes.fill "currentcolor"
            , Attributes.fillRule "evenodd"
            ]
            [ Svg.path
                [ Attributes.d "M33.427 6.4l-2.666 2.667H0V6.4h33.427zm-5.333 5.333L25.427 14.4H5.867v-2.667h22.227zm-5.333 5.334l-2.667 2.666H2.134v-2.666H22.76zm-4.8 4.8l-2.667 2.666h-8.36v-2.666H17.96zM13.244 29.2l5.556 5.556-7.777 2.221 2.22-7.777zM47.717 5.854l-3.692 3.692-5.5-5.5L42.217.355l5.5 5.5zM14.935 27.558L36.933 5.561l5.5 5.5-21.998 21.997-5.5-5.5z"
                ]
                []
            ]
        ]
        |> Nri.Ui.Svg.V1.fromHtml


{-| -}
guidedDraft : Nri.Ui.Svg.V1.Svg
guidedDraft =
    Svg.svg
        [ Attributes.width "100%"
        , Attributes.height "100%"
        , Attributes.viewBox "0 0 98 72"
        , Attributes.fill "currentcolor"
        ]
        [ Svg.path [ Attributes.d "M97.801,68.699 L97.80078,68.699 C98.10156,69.3006 98,69.9998 97.60156,70.4998 C97.30076,70.9998 96.70312,71.30058 96.10156,71.30058 L1.800561,71.30058 C1.199001,71.30058 0.601341,70.9998 0.300561,70.4998 C-0.0002189,69.8982 -0.1017789,69.30056 0.199001,68.699 L18.5,28.597 C18.8008,27.89384 19.49998,27.4954 20.1992,27.4954 L41.6992,27.4954 L44.3984,32.6946 C45.1992,34.4914 47,35.593 49,35.593 C50.9024,35.593 52.70316,34.4954 53.6016,32.6946 C53.8008,32.3938 54.9024,30.1946 56.3008,27.4954 L77.8008,27.4954 C78.60156,27.4954 79.19922,27.89778 79.5,28.597 L97.801,68.699 Z M24.60201,47.801 L25.80121,47.801 C26.90277,47.801 27.80121,46.9026 27.80121,45.801 C27.80121,44.69944 26.90281,43.801 25.80121,43.801 L24.60201,43.801 C23.50045,43.801 22.60201,44.6994 22.60201,45.801 C22.60201,46.90256 23.5004,47.801 24.60201,47.801 Z M33.8012,56.1018 L33.80124,56.10174 C34.10206,55.39864 33.69967,54.69943 33.00436,54.39474 C32.9028,54.39474 32.50436,54.19552 32.4028,54.19552 C31.0044,53.49632 29.7036,52.59792 28.7036,51.29712 C28.60594,51.29712 28.40672,50.89868 28.30516,50.79712 C27.90276,50.19556 27.10592,50.0979 26.50436,50.49634 C25.9028,50.89874 25.80514,51.69558 26.20358,52.29714 C26.30514,52.3987 26.70358,52.79714 26.70358,52.8987 C27.90278,54.5979 29.50438,55.79712 31.40278,56.5979 C31.50434,56.5979 32.102,56.89868 32.20356,56.89868 C32.30122,57.00024 32.50044,57.00024 32.602,57.00024 C33.10198,57.00024 33.60198,56.6018 33.8012,56.1018 Z M45.1022,55.80102 L45.10208,55.80104 C45.69974,55.50024 46.00052,54.69944 45.50052,54.19944 C45.19972,53.59788 44.40288,53.39866 43.80132,53.69944 C43.69976,53.801 43.19976,54.00022 43.19976,54.00022 C42.00056,54.60182 40.69976,54.9026 39.19976,55.10182 C39.00056,55.10182 37.90292,55.20338 37.80136,55.20338 C37.10216,55.20338 36.60216,55.80496 36.60216,56.50418 C36.60216,57.20338 37.20374,57.70338 37.90296,57.70338 C37.90296,57.70338 38.60218,57.60182 38.70374,57.60182 C39.00062,57.60182 39.3014,57.50026 39.60218,57.50026 C41.40298,57.30106 43.00458,56.89868 44.40298,56.19946 C44.40298,56.1018 45.00064,55.90258 45.1022,55.80102 Z M53.3014,46.19942 L53.30152,46.19942 C53.69995,45.60172 53.50073,44.80094 53.00464,44.59782 C52.40304,44.19938 51.60228,44.29704 51.20384,44.8986 C51.10618,45.00016 50.8054,45.3986 50.8054,45.50016 C50.40302,46.00016 50.00458,46.5978 49.7038,47.19936 C49.1022,48.10176 48.50456,49.10172 47.903,50.00016 C47.903,50.00016 47.60612,50.3986 47.50456,50.50016 C47.00456,51.10176 47.10222,51.90252 47.70378,52.30096 C48.00456,52.50018 48.20378,52.60174 48.50456,52.60174 C48.903,52.60174 49.20378,52.40252 49.50456,52.10174 C49.60612,52.00018 50.00456,51.60174 50.00456,51.50018 C50.70376,50.50018 51.3014,49.50018 51.90296,48.50018 C52.20374,47.90258 52.60218,47.30098 52.90296,46.80098 C53.00062,46.69942 53.19984,46.30098 53.3014,46.19942 Z M62.6022,41.60172 L62.60202,41.6018 C63.30125,41.6018 63.89891,41.00019 64.09422,40.5041 C64.09422,39.80486 63.49264,39.2033 62.79342,39.2033 L61.99264,39.2033 C61.19584,39.2033 60.39502,39.30096 59.59424,39.40252 C58.29744,39.60174 57.19584,39.90252 56.19584,40.40252 C56.19584,40.40252 55.59818,40.6994 55.49662,40.80096 C54.89506,41.10176 54.59818,41.8986 54.99662,42.50016 C55.19978,42.9025 55.69978,43.10172 56.09822,43.10172 C56.30134,43.10172 56.50056,43.00406 56.69978,42.9025 C56.69978,42.80094 57.19978,42.60172 57.19978,42.60172 C58.00058,42.19938 58.80138,41.9025 59.80138,41.80094 C60.50458,41.70328 61.20376,41.60172 61.90298,41.60172 L62.6022,41.60172 Z M67.3014,42.50016 L67.3014,42.50026 C67.39906,42.50026 67.8014,42.80104 67.8014,42.9026 C69.8014,43.9026 70.70376,45.30102 71.1022,46.1018 C71.1022,46.19946 71.30142,46.50024 71.30142,46.50024 C71.50062,47.00024 72.00062,47.30102 72.50062,47.30102 C72.59828,47.30102 72.7975,47.30102 72.89906,47.19946 C73.59828,46.99626 73.89906,46.29708 73.69984,45.59786 C73.69984,45.59786 73.39906,45.0002 73.39906,44.89864 C72.89906,43.89864 71.59826,41.99624 69.09826,40.59784 C69.09826,40.50018 68.5006,40.30096 68.39904,40.1994 C67.80144,39.90252 67.00062,40.1994 66.69984,40.80096 C66.40296,41.39856 66.69984,42.19938 67.3014,42.50016 Z M76.6998,56.00016 L76.69974,56.00016 C77.19974,55.39866 77.19974,54.60177 76.49662,54.09786 L74.79742,52.59786 L76.19582,50.89866 C76.59816,50.39866 76.4966,49.59786 75.9966,49.09786 C75.4966,48.69552 74.6958,48.79708 74.1958,49.29708 L72.895,50.89868 L71.4966,49.59788 C70.9966,49.09788 70.1958,49.19944 69.6958,49.69944 C69.1958,50.19944 69.29736,51.00024 69.79736,51.50024 L71.29736,52.89864 L69.89896,54.59784 C69.49662,55.09784 69.59818,55.89864 70.09818,56.39864 C70.2974,56.59786 70.59818,56.69942 70.89896,56.69942 C71.2974,56.69942 71.59818,56.5002 71.89896,56.19942 L73.19976,54.59782 L74.80136,56.09782 C75.09824,56.29704 75.39902,56.3986 75.6998,56.3986 C76.09824,56.3986 76.39902,56.30094 76.6998,56.00016 Z" ] []
        , Svg.path [ Attributes.d "M47.602,31.199 L47.6023,31.1986 C47.6023,31.1986 42.2,20.6008 39.7,15.6946 C37.2,10.7966 39.2,4.3982 44.3016,1.7966 C49.3988,-0.801 55.598,1.2966 58.1996,6.3982 C59.6996,9.3982 59.6996,12.8006 58.1996,15.699 C56.6996,18.699 50.3012,31.199 50.3012,31.199 C49.8012,32.3006 48.20356,32.3006 47.602,31.199 Z M49.0004,5.601 C46.0004,5.601 43.602,8.101 43.602,10.9994 C43.602,13.9994 46.0004,16.3978 49.0004,16.3978 C52.0004,16.3978 54.3988,13.9994 54.3988,10.9994 C54.3988,7.9994 52.0004,5.601 49.0004,5.601 Z" ] []
        ]
        |> Nri.Ui.Svg.V1.fromHtml


{-| -}
selfReview : Nri.Ui.Svg.V1.Svg
selfReview =
    Svg.svg
        [ Attributes.viewBox "0 -7 64 84"
        , Attributes.width "100%"
        , Attributes.height "100%"
        ]
        [ Svg.path [ Attributes.d "M62.16365,17.60935 C62.57365,17.60935 62.97265,17.76935 63.26565,18.06235 C63.55865,18.35535 63.72265,18.75035 63.72565,19.16435 C63.72565,38.98435 50.33265,55.21435 33.56165,56.16835 L33.56165,73.66435 L40.98365,73.66435 C41.84765,73.66435 42.54665,74.36335 42.54665,75.22635 C42.54665,76.08935 41.84765,76.78935 40.98365,76.78935 L22.82065,76.78935 C21.95665,76.78935 21.25765,76.08935 21.25765,75.22635 C21.25765,74.36335 21.95665,73.66435 22.82065,73.66435 L30.43765,73.66435 L30.43765,56.16835 C13.66465,55.21435 0.27365,38.98835 0.27365,19.16435 C0.27765,18.75035 0.44165,18.35535 0.73465,18.06235 C1.02765,17.76935 1.42565,17.60935 1.83565,17.60935 L8.17165,17.60935 L8.17165,20.73435 L3.42965,20.73435 C4.12065,38.70335 16.67165,53.10535 31.99965,53.10535 C47.32765,53.10535 59.87865,38.70335 60.56965,20.73435 L55.43665,20.73435 L55.43665,17.60935 L62.16365,17.60935 Z", Attributes.fill "currentcolor" ] [], Svg.path [ Attributes.d "M31.99955,37.54295 C23.45655,37.54295 16.50755,29.24195 16.50755,19.03495 C16.50755,8.83195 23.45655,0.52695 31.99955,0.52695 C40.54255,0.52695 47.49155,8.83195 47.49155,19.03495 C47.49155,29.23795 40.54255,37.54295 31.99955,37.54295 Z M35.83955,15.34395 L35.83955,15.34795 C36.44855,14.73495 36.44855,13.74695 35.83955,13.13695 C35.22655,12.52795 34.23755,12.52795 33.62855,13.13695 L27.34755,19.41795 C26.73755,20.02795 26.73755,21.01595 27.34755,21.62595 C27.96055,22.23895 28.94855,22.23895 29.55855,21.62595 L35.83955,15.34395 Z M20.73755,12.80495 C20.12755,13.41795 20.12755,14.40695 20.73755,15.01595 C21.34655,15.62595 22.33855,15.62595 22.94855,15.01595 L29.22955,8.73895 C29.83855,8.12595 29.83855,7.13695 29.22955,6.52795 C28.61655,5.91795 27.62755,5.91795 27.01855,6.52795 L20.73755,12.80495 Z M21.83855,18.31295 L21.83855,18.31695 C21.22955,18.92595 21.22955,19.91495 21.83855,20.52395 C22.44855,21.13695 23.44055,21.13695 24.04955,20.52395 L34.73755,9.83995 C35.34755,9.23095 35.34755,8.23795 34.73755,7.62895 C34.12855,7.01995 33.13655,7.01995 32.52655,7.62895 L21.83855,18.31295 Z", Attributes.fill "currentcolor" ] [], Svg.mask [ Attributes.fill "currentcolor" ] [ Svg.path [ Attributes.d "M31.99955,44.85935 C20.03055,44.85935 10.29255,33.27335 10.29255,19.03535 C10.29255,4.79735 20.03055,-6.78865 31.99955,-6.78865 C43.96855,-6.78865 53.70655,4.79735 53.70655,19.03535 C53.70655,33.27335 43.96855,44.85935 31.99955,44.85935 Z M31.99955,-2.59765 C21.73355,-2.59765 13.38255,7.10535 13.38255,19.03535 C13.38255,30.96435 21.73355,40.66835 31.99955,40.66835 C42.26555,40.66835 50.61655,30.96535 50.61655,19.03535 C50.61655,7.10535 42.26555,-2.59765 31.99955,-2.59765 Z" ] [] ], Svg.path [ Attributes.d "M31.99955,44.85935 C20.03055,44.85935 10.29255,33.27335 10.29255,19.03535 C10.29255,4.79735 20.03055,-6.78865 31.99955,-6.78865 C43.96855,-6.78865 53.70655,4.79735 53.70655,19.03535 C53.70655,33.27335 43.96855,44.85935 31.99955,44.85935 Z M31.99955,-2.59765 C21.73355,-2.59765 13.38255,7.10535 13.38255,19.03535 C13.38255,30.96435 21.73355,40.66835 31.99955,40.66835 C42.26555,40.66835 50.61655,30.96535 50.61655,19.03535 C50.61655,7.10535 42.26555,-2.59765 31.99955,-2.59765 Z", Attributes.fill "currentcolor" ] [] ]
        |> Nri.Ui.Svg.V1.fromHtml


{-| -}
submitting : Nri.Ui.Svg.V1.Svg
submitting =
    Svg.svg
        [ Attributes.width "100%"
        , Attributes.height "100%"
        , Attributes.viewBox "0 0 25 25"
        , Attributes.fill "currentcolor"
        ]
        [ Svg.path
            [ Attributes.fillOpacity ".5"
            , Attributes.d "M0 1.875v1.406h22.5V1.875H0zm0 3.867v1.406h24.32V5.742H0zM0 9.61v1.407h15.117V9.609H0zm0 5.625v1.407h24.32v-1.407H0zm0 3.868v1.406h23.125v-1.406H0zm0 3.867v1.406h13.75v-1.406H0z"
            ]
            []
        , Svg.path
            [ Attributes.fill "#FFF"
            , Attributes.d "M13.15 23.552l.867-5.111 6.325-12.527 1.15-.069.71-1.69 1.909.877-.702 1.715.338.924-6.827 12.878-3.178 3.069z"
            ]
            []
        , Svg.path
            [ Attributes.d "M24.32 5.78a.906.906 0 0 0-.405-1.249l-1.181-.602c-.237-.12-.444-.151-.711-.064-.268.087-.417.234-.538.47l-.481.945c-.178.058-.297-.002-.475.056-.267.087-.417.234-.537.47l-.662 1.3-.945-.482a.453.453 0 0 0-.624.203l-3.01 5.906a.453.453 0 0 0 .203.624c.058.179.236.12.325.092.09-.03.268-.087.328-.205l2.74-5.523.472.24-5.477 10.75c-.06.118-.031.208-.091.326l-.625 4.146c-.062.414.143.742.526 1.012.236.12.444.151.711.064.178-.058.268-.087.328-.205l2.987-2.942c.089-.029.15-.147.21-.265l6.62-12.995a.997.997 0 0 0-.169-1.127l.482-.945zm-2.008-1.024l1.182.602-.482.945-1.181-.602.481-.945zm-8.739 18.612l.591-3.642 2.127 1.083-2.718 2.559zm3.228-3.415L14.44 18.75l4.695-9.214 2.362 1.204-4.695 9.214zm5.116-10.041l-2.362-1.204 1.264-2.48 2.363 1.203-1.265 2.48z"
            ]
            []
        ]
        |> Nri.Ui.Svg.V1.fromHtml
