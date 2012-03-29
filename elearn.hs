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
type Flashcard = (Question, Answer)
type Stack = [Flashcard]

question :: Flashcard -> Question
question = \(question, answer) -> question 

answer :: Flashcard -> Answer
answer = \(question, answer) -> answer 

{- Following functions are defined for fitness quality purpose -}

fitness :: String -> Answer -> Score 
fitness input answer = equal / amountAnswer
    where 
        equal = fromIntegral (equalWords answerS inputS) :: Float
        amountAnswer = fromIntegral (length answerS) :: Float
        answerS = map toUppercaseWord (splitWords answer)
        inputS = map toUppercaseWord (splitWords input)

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
    | score > 0.90 = putStrLn ("Correct, scored " ++ show score)
    | score > 0.75 = putStrLn ("Almost correct, scored " ++ show score)
    | score >= 0.5 = putStrLn ("Nice try, scored " ++ show score)
    | score < 0.5 = putStrLn ("Try harder, scored " ++ show score)

showCumulativeScore :: Score -> IO ()
showCumulativeScore score = putStrLn ("Total score: " ++ show score)

asker :: Score -> Stack -> IO Stack
asker score [] = return []
asker score (x:xs) = do
    input <- ask (question x)
    putStrLn ""
    feedback (fitness input (answer x))
    giveAnswer (answer x)
    showCumulativeScore (score + (fitness input (answer x )))
    asker (score + (fitness input (answer x))) xs
    
main = do
    args <- getArgs
    content <- readFile (head args)
    asker 0.0 (parseStack content) 

{- Following functions are defined for text processing purpose -}

whitespace :: [Char]
whitespace = ['\n', '\t', ',', ' ']

toUppercaseWord :: Word -> Word
toUppercaseWord word = map toUpper word

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
parseFlashcard st = (parseQuestion st, parseAnswer st)

