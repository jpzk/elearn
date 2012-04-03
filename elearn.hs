{-
This file is part of elearn.

elearn is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

elearn is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with elearn.  If not, see <http://www.gnu.org/licenses/>.
-}

import System(getArgs)
import Data.Char(toUpper)

type Question = String
type Score = Float
type Word = String
type Answer = String
type Stack = [Flashcard]

data Flashcard = Flashcard 
    {question :: Question, answer :: Answer}

{- Following functions are defined for fitness quality purpose -}

fitness :: String -> Answer -> Score 
fitness input answer = equal / amountAnswer
    where 
        equal = conv (equalWords answerS inputS) :: Float
        amountAnswer = conv (length answerS) :: Float
        answerS = map toUpperWord (splitWords answer)
        inputS = map toUpperWord (splitWords input)
        conv = fromIntegral

equalWords :: [Word] -> [Word] -> Int
equalWords wlist1 wlist2 = length (filter equal combinations)
    where 
        equal = \(w1,w2) -> w1 == w2
        combinations = [(w1,w2) | w1 <- wlist1, w2 <- wlist2]

{- The following code handles IO actions -}

ask :: Question -> IO String 
ask question = do
    putStrLn ("\nQuestion: " ++ question) 
    getLine 

giveAnswer :: Answer -> IO ()
giveAnswer answer = do 
    putStrLn ("The right answer is: " ++ answer)

feedback :: Score -> IO () 
feedback score
    | score > 0.90 = putStrLn ("Correct" ++ scoreMsg)
    | score > 0.75 = putStrLn ("Almost correct" ++ scoreMsg)
    | score >= 0.5 = putStrLn ("Nice try" ++ scoreMsg)
    | score < 0.5 = putStrLn ("Try harder" ++ scoreMsg)
    where scoreMsg = ", scored " ++ show score

showTotalScore :: Score -> IO ()
showTotalScore score = putStrLn ("Total score: " ++ show score)

asker :: Score -> Stack -> IO ()
asker score [] = return () 
asker score (x:xs) = do
    input <- ask (question x)
    putStrLn ""
    feedback (fitness input (answer x))
    giveAnswer (answer x)
    showTotalScore (score + (fitness input (answer x)))
    asker (score + (fitness input (answer x))) xs

handleArgs :: [String] -> IO ()
handleArgs args  
    | length args < 1 = putStrLn "./elearn flashcards.stack"
    | otherwise = do 
        content <- readFile (head args)
        asker 0.0 (parseStack content) 

main = do
    args <- getArgs
    handleArgs args

{- Following functions are defined for text processing purpose -}

whitespace :: [Char]
whitespace = ['\n', '\t', ',', ' ']

toUpperWord :: Word -> Word
toUpperWord word = map toUpper word

getWord :: String -> String
getWord [] = []
getWord (x:xs)
    | elem x whitespace = []
    | otherwise = x : getWord xs 

dropSpace :: String -> String
dropSpace [] = []
dropSpace (x:xs)
    | elem x whitespace = dropSpace xs
    | otherwise = (x:xs)

dropWord :: String -> String
dropWord [] = []
dropWord (x:xs) 
    | elem x whitespace = (x:xs)
    | otherwise = dropWord xs

splitWords :: String -> [Word]
splitWords st = split(dropSpace(st))

split :: String -> [Word]
split [] = []
split st = (getWord st) : (split (dropSpace(dropWord st)))

parseStack :: String -> Stack 
parseStack content = map parseFlashcard (lines content)

parseQuestion :: String -> Question
parseQuestion [] = [] 
parseQuestion (x:xs) 
    | x == ';' = []
    | otherwise = x : parseQuestion xs 

parseAnswer :: String -> Answer
parseAnswer [] = []
parseAnswer (x:xs)
    | x == ';' = xs
    | otherwise = parseAnswer xs

parseFlashcard :: String -> Flashcard 
parseFlashcard st = Flashcard (parseQuestion st) (parseAnswer st)

