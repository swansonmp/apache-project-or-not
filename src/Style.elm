module Style exposing (..)

import Html exposing (Html)
import Html.Attributes exposing (style)

padding : Int -> Html.Attribute msg
padding px = style "padding" ((String.fromInt px) ++ "px")

center : Html.Attribute msg
center = style "text-align" "center"

font : Html.Attribute msg
font = style "font-family" "Helvetica, sans-serif"

fontSize : Html.Attribute msg
fontSize = style "font-size" "1.25em"

buttonFontSize : Html.Attribute msg
buttonFontSize = style "font-size" "1em"

tableWidth : Html.Attribute msg
tableWidth = style "width" "100%"

questionButton : List (Html.Attribute msg)
questionButton = button ++
  [ style "width" "50%"
  , style "background-color" "Grey"
  ]

advanceButton : List (Html.Attribute msg)
advanceButton = button ++
  [ style "background-color" "DodgerBlue"
  ]

startButton : List (Html.Attribute msg)
startButton = advanceButton

button : List (Html.Attribute msg)
button =
  [ style "padding" "12px 100px"
  , style "border-radius" "5px"
  , style "color" "white"
  , font
  , buttonFontSize
  , style "border" "none"
  , style "font-weight" "bold"
  ]

paragraph : List (Html.Attribute msg)
paragraph =
  [ padding 20
  ]
