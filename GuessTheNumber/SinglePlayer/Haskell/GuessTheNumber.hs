{- GTPL
 - Game: GuessTheNumber
 - Type: SinglePlayer
 - Lang: Haskell
 -
 - External Dependency: random
 -}

import System.Random

main :: IO ()
main = do
  putStrLn $ "I'm thinking of a number between 0 and " ++ show upperBound
  randomInt <- randomIO
  loop (modBy upperBound $ abs $ randomInt)

upperBound :: Int
upperBound = 1000

modBy :: Int -> Int -> Int
modBy = flip mod

loop :: Int -> IO ()
loop secret =
  getLine >>= maybe notANumber (check secret) . safeRead

safeRead :: Read n => String -> Maybe n
safeRead = fmap fst . safeHead . reads

safeHead :: [a] -> Maybe a
safeHead [] = Nothing
safeHead (h:_) = Just h

notANumber :: IO ()
notANumber = putStrLn "Your guess is not a number!"

check :: Int -> Int -> IO ()
check secret guess
  | secret == guess = putStrLn "You win!"
  | secret < guess  = putStrLn "Your guess was too high." >> loop secret
  | secret > guess  = putStrLn "Your guess was too low."  >> loop secret
