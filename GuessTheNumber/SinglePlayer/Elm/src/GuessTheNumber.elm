{- GTPL
 - Game: GuessTheNumber
 - Type: SinglePlayer
 - Lang: Elm
 - External Dependency: elm/random
 -}

module GuessTheNumber exposing (main)

import Browser
import Html exposing (Html)
import Html.Events exposing (onClick, onInput)
import Html.Attributes as Attribute
import Random

main : Program () Model Msg
main = Browser.element
  { init = init
  , subscriptions = \_ -> Sub.none
  , update = update
  , view = view
  }

type alias Model =
  { secret : Int
  , guess : String
  , lines : List String
  , gameOver : Bool
  }

init : () -> (Model, Cmd Msg)
init _ =
  ( { secret = 0, guess = "", lines = [], gameOver = False }
  , Random.generate Initialise (Random.int 0 upperLimit)
  )

upperLimit : Int
upperLimit = 1000

type Msg = Initialise Int | Guess String | ChangeGuess String

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Initialise n -> (initialiseModel n model, Cmd.none)
    ChangeGuess guess -> (setGuess guess model, Cmd.none)
    Guess n -> (processGuess n model, Cmd.none)

initialiseModel : Int -> Model -> Model
initialiseModel n =
  writeLine ("I'm thinking of a number between 0 and " ++ String.fromInt upperLimit)
  >> setSecret n

processGuess : String -> Model -> Model
processGuess guess model =
  let
    change =
      case String.toInt guess of
        Nothing ->
          writeLine "Not a number"
        Just g ->
          if g > model.secret then
            writeLine (guess ++ " is too big.")
          else if g < model.secret then
            writeLine (guess ++ " is too small.")
          else
            writeLine (guess ++ " is just right, you win!")
            >> endGame
  in
    model
    |> change
    |> clearInput

writeLine : String -> Model -> Model
writeLine msg m = { m | lines = m.lines ++ [msg] }

clearInput : Model -> Model
clearInput m = { m | guess = "" }

endGame : Model -> Model
endGame m = { m | gameOver = True }

setSecret : Int -> Model -> Model
setSecret s m = { m | secret = s }

setGuess : String -> Model -> Model
setGuess g m = { m | guess = g }

view : Model -> Html Msg
view model =
  Html.div []
    [ textLines model.lines
    , if model.gameOver
      then Html.div [] []
      else guessInput model.guess
    ]

textLines : List String -> Html Msg
textLines lines =
  Html.div []
    (List.map (\l -> Html.div [] [Html.text l]) lines)

guessInput : String -> Html Msg
guessInput guess =
  Html.div []
    [ Html.input [ Attribute.value guess, onInput ChangeGuess ] []
    , Html.button
        [ onClick (Guess guess) ]
        [ Html.text "Guess" ]
    ]
