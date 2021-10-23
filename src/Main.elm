module Main exposing (..)

-- Apache Project or Not?
--
-- Matthew Swanson

import Browser
import Html exposing (Html, button, div, h1, strong, table, td, text)
import Html.Attributes
import Html.Events exposing (onClick)
import Random
import Random.List
import RealProjects exposing (RealProject)
import FakeProjects exposing (FakeProject)


-- MAIN

main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }


-- MODEL

type alias Model =
  { currentQuestion : Maybe Question
  , futureQuestions : List Question
  , pastQuestions : List Question
  , order : Order
  }

type alias Question =
  { realProject : RealProject
  , fakeProject : FakeProject
  , correctAnswer : Maybe Bool
  }

type Project = Real RealProject | Fake FakeProject

init : () -> (Model, Cmd Msg)
init _ =
  (
    { currentQuestion = Nothing
    , futureQuestions = []
    , pastQuestions = []
    , order = Left
    }
  , Random.generate
      Start
      (Random.pair
        (Random.List.shuffle RealProjects.projects)
        (Random.List.shuffle FakeProjects.projects))
  )


-- UPDATE

type Msg
  = Start (List RealProject, List FakeProject)
  | Ready Order
  | Correct
  | Incorrect
  | Next

type Order = Left | Right

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Start (realProjects, fakeProjects) ->
      (start model realProjects fakeProjects, generateOrder)
    Ready order ->
      ({ model | order = order }, Cmd.none)
    Correct ->
      (processAnswer model True, Cmd.none)
    Incorrect ->
      (processAnswer model False, Cmd.none)
    Next ->
      (model, generateOrder)

generateOrder : Cmd Msg
generateOrder = Random.generate Ready (Random.uniform Left [Left, Right])

start : Model -> List RealProject -> List FakeProject -> Model
start model realProjects fakeProjects =
  let
    projects = List.map2 Tuple.pair realProjects fakeProjects
    questions = List.map makeQuestion projects
  in
    { model
    | currentQuestion = List.head questions
    , futureQuestions = Maybe.withDefault [] (List.tail questions)
    }

makeQuestion : (RealProject, FakeProject) -> Question
makeQuestion (realProject, fakeProject) =
  { realProject = realProject
  , fakeProject = fakeProject
  , correctAnswer = Nothing
  }

processAnswer : Model -> Bool -> Model
processAnswer model correct =
  { currentQuestion = List.head model.futureQuestions
  , futureQuestions = Maybe.withDefault [] (List.tail model.futureQuestions)
  , pastQuestions = model.pastQuestions ++ (getCurrentQuestion model)
  , order = model.order
  }

getCurrentQuestion : Model -> List Question
getCurrentQuestion model =
  case model.currentQuestion of
    Just question ->
      [question]
    Nothing ->
      []


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


-- VIEW


view : Model -> Html Msg
view model =
  case model.currentQuestion of
    Nothing ->
      div [] [text "No Questions!"]
    Just currentQuestion ->
      let
        (leftProject, rightProject) = orderedProjects model.order currentQuestion
      in
        case currentQuestion.correctAnswer of
          Nothing ->
            div []
              [ pageHeader
              , questionInfo model
              , table []
                [ td [] [questionDiv leftProject]
                , td [] [questionDiv rightProject]
                ]
              ]
          Just answer ->
            div []
              [ button [onClick Next] [text "Next"]
              ]
        

orderedProjects : Order -> Question -> (Project, Project)
orderedProjects order currentQuestion =
  let
    realProject = currentQuestion.realProject
    fakeProject = currentQuestion.fakeProject
  in
    case order of
      Left ->
        (Real realProject, Fake fakeProject)
      Right ->
        (Fake fakeProject, Real realProject)

pageHeader : Html Msg
pageHeader =
  h1 [] [text "Apache Project or Not?"]

questionInfo : Model -> Html Msg
questionInfo model =
  strong [] [text ("Question " ++ (String.fromInt (questionNumber model)))]

questionNumber : Model -> Int
questionNumber model = 1 + List.length model.pastQuestions 

questionDiv : Project -> Html Msg
questionDiv project =
  case project of
    Real realProject ->
      div []
        [button [onClick Correct] [text realProject.name]]
    Fake fakeProject ->
      div []
        [button [onClick Incorrect] [text fakeProject.name]]
