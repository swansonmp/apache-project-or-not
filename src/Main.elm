module Main exposing (..)

-- Apache Project or Not?
--
-- Matthew Swanson

import Browser
import Html exposing (Html, button, code, div, h1, h3, li, p, table, td, text, tr, ul)
import Html.Events exposing (onClick)
import Random
import Random.Extra
import Random.List
import RealProjects exposing (RealProject)
import FakeProjects exposing (FakeProject)
import Style


-- MAIN

main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }


-- MODEL

type Model
  = Initialize
  | Start FutureQuestions
  | TakingQuestion QuestionBank
  | QuestionResult QuestionBank
  | End PastQuestions
  | Error String

type alias FutureQuestions = List Question
type alias PastQuestions = List Question
type alias QuestionBank = (FutureQuestions, Question, PastQuestions)

type alias Question =
  { realProject : RealProject
  , fakeProject : FakeProject
  , correctAnswer : Maybe Bool
  , order : Order
  }

defaultQuestion : Question
defaultQuestion =
  { realProject = RealProjects.default
  , fakeProject = FakeProjects.default
  , correctAnswer = Nothing
  , order = Left
  }

type Project = Real RealProject | Fake FakeProject

init : () -> (Model, Cmd Msg)
init _ = (Initialize, generateFutureQuestions)

questionCount : Int
questionCount = 25

generateFutureQuestions : Cmd Msg
generateFutureQuestions =
  Random.generate Generated futureQuestionsGenerator

futureQuestionsGenerator : Random.Generator FutureQuestions
futureQuestionsGenerator =
  Random.list questionCount questionGenerator

questionGenerator : Random.Generator Question
questionGenerator =
  Random.map4 Question
    (Random.uniform RealProjects.default RealProjects.projects)
    (Random.uniform FakeProjects.default FakeProjects.projects)
    (Random.constant Nothing)
    (Random.Extra.choice Left Right)


-- UPDATE

type Msg
  = Generated FutureQuestions
  | StartQuiz
  | Correct
  | Incorrect
  | Next

type Order = Left | Right

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Generated futureQuestions ->
      (Start futureQuestions, Cmd.none)
    StartQuiz ->
      (start model, Cmd.none)
    Correct ->
      (processAnswer model True, Cmd.none)
    Incorrect ->
      (processAnswer model False, Cmd.none)
    Next ->
      (advance model, Cmd.none)

start : Model -> Model
start model =
  case model of
    Start futureQuestions ->
      case (List.head futureQuestions) of
        Just firstQuestion ->
          TakingQuestion
            ( []
            , firstQuestion
            , Maybe.withDefault [] (List.tail futureQuestions)
            )
        Nothing ->
          Error ("There are no questions to start from!")
    _ ->
      Error ("Tried to start while model is " ++ (Debug.toString model) ++ ".")

advance : Model -> Model
advance model =
  case model of
    QuestionResult (pastQuestions, currentQuestion, futureQuestions) ->
      case (List.head futureQuestions) of
        Just nextQuestion ->
          TakingQuestion
            ( pastQuestions ++ [currentQuestion]
            , nextQuestion
            , Maybe.withDefault [] (List.tail futureQuestions)
            )
        Nothing ->
          End (pastQuestions ++ [currentQuestion])
    _ ->
      Error ("Tried to advance while model is " ++ (Debug.toString model) ++ ".")

processAnswer : Model -> Bool -> Model
processAnswer model correct =
  case model of
    TakingQuestion (pastQuestions, currentQuestion, futureQuestions) ->
      QuestionResult
        ( pastQuestions
        , { currentQuestion | correctAnswer = Just correct }
        , futureQuestions
        )
    _ ->
      Error ("Tried to processAnswer while model is " ++ (Debug.toString model) ++ ".")


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


-- VIEW

view : Model -> Html Msg
view model =
  case model of
    Initialize ->
      withPageHeader initializeContent
    Start futureQuestions ->
      withPageHeader startContent
    TakingQuestion questionBank ->
      withPageHeader (questionContent questionBank False)
    QuestionResult questionBank ->
      withPageHeader (questionContent questionBank True)
    End pastQuestions ->
      withPageHeader (endContent pastQuestions)
    Error message ->
      withPageHeader (errorContent message)

withPageHeader : List (Html Msg) -> Html Msg
withPageHeader content =
  div
    [Style.center, Style.font, Style.fontSize]
    ([pageHeader] ++ content)

initializeContent : List (Html Msg)
initializeContent =
  [ p Style.paragraph [text "Loading..."]
  ]

startContent : List (Html Msg)
startContent =
  [ p Style.paragraph [text "Can you guess the real Apache Software Foundation project?"]
  , button ([onClick StartQuiz] ++ Style.startButton) [text "Start"]
  ]

questionContent : QuestionBank -> Bool -> List (Html Msg)
questionContent questionBank showResults =
  let
    (pastQuestions, currentQuestion, futureQuestions) = questionBank
    (leftProject, rightProject) = orderedProjects currentQuestion
  in
    [ questionInfo questionBank
    , table [Style.tableWidth]
      ((questionButtonRow (leftProject, rightProject) currentQuestion showResults)
      ++ (questionResultRow (leftProject, rightProject) currentQuestion showResults)
      )
    , advanceButton showResults
    ]

questionButtonRow : (Project, Project) -> Question -> Bool -> List (Html Msg)
questionButtonRow (leftProject, rightProject) question showResults =
  [ tr []
      [ td [] [questionButton leftProject question showResults]
      , td [] [questionButton rightProject question showResults]
      ]
  ]

questionButton : Project -> Question -> Bool-> Html Msg
questionButton project question showResults =
  case project of
    Real realProject ->
      div []
        [button ([onClick Correct] ++ Style.questionButton) [text realProject.name]]
    Fake fakeProject ->
      div []
        [button ([onClick Incorrect] ++ Style.questionButton) [text fakeProject.name]]

questionResultRow : (Project, Project) -> Question -> Bool -> List (Html Msg)
questionResultRow (leftProject, rightProject) question showResults =
  if showResults
    then questionResultContent (leftProject, rightProject) question
    else []

questionResultContent : (Project, Project) -> Question -> List (Html Msg)
questionResultContent (leftProject, rightProject) question =
  [ tr []
      [ td [] (projectInfoContent leftProject question)
      , td [] (projectInfoContent rightProject question)
      ]
  ]

projectInfoContent : Project -> Question -> List (Html Msg)
projectInfoContent project question =
  case project of
    Real realProject ->
      realProjectInfoContent realProject question
    Fake fakeProject ->
      fakeProjectInfoContent fakeProject question

realProjectInfoContent : RealProject -> Question -> List (Html Msg)
realProjectInfoContent realProject question =
  [ div []
    [ p [] [text realProject.description]
    , listContent
        [("Category", realProject.category)
        , ("Initial release", realProject.initialRelease)
        , ("Written in", realProject.writtenIn)
        , ("See", realProject.link)
        ]
    ]
  ]

fakeProjectInfoContent : FakeProject -> Question -> List (Html Msg)
fakeProjectInfoContent fakeProject question =
  [ div []
    [ p [] [text fakeProject.description]
    , listContent
        [ ("Category", fakeProject.category)
        , ("See", fakeProject.link)
        ]
    ]
  ]

listContent : List (String, String) -> Html Msg
listContent items =
  ul []
    ( List.map
        (\(label, content) -> li [] [text (label ++ ": " ++ content)])
        items
    )

advanceButton : Bool -> Html Msg
advanceButton showResults =
  button ([onClick Next] ++ Style.advanceButton) [text "Next"] 

endContent : FutureQuestions -> List (Html Msg)
endContent futureQuestions = [text "TODO endContent"]

errorContent : String -> List (Html Msg)
errorContent message =
  [ p [] [text "Oops, I encountered an error I can't recover from. Here's the error:"]
  , div []
    [ code [] [text message]
    ]
  ]

orderedProjects : Question -> (Project, Project)
orderedProjects question =
    case question.order of
      Left ->
        (Real question.realProject, Fake question.fakeProject)
      Right ->
        (Fake question.fakeProject, Real question.realProject)

pageHeader : Html Msg
pageHeader =
  h1
    [Style.center, Style.font]
    [text "Apache Project or Not?"]

questionInfo : QuestionBank -> Html Msg
questionInfo questionBank =
  h3 []
    [ text
        ( "Question "
        ++ (String.fromInt (questionNumber questionBank))
        ++ " of "
        ++ (String.fromInt questionCount)
        )
    ]

questionNumber : QuestionBank -> Int
questionNumber (pastQuestions, _, _) =
  1 + List.length pastQuestions
