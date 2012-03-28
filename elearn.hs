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

type Question = String
type Score = Float
type Word = String
type Answer = String
type Flashcard = (Question, Answer)
type Database = [Flashcard]

exampleBase :: Database
exampleBase = [
    ("What are the main components of HCDP?", 
    "User Study Specification Produce Designs Evaluation"),
    ("What user studies techniques do you know?", 
    "Surveys, ethnographic studies, interviews, focus group")]

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
        answerS = splitWords answer
        inputS = splitWords input 

equalWords :: [Word] -> [Word] -> Int
equalWords wlist1 wlist2 = length (filter equal combinations)
    where 
        equal = \(w1,w2) -> w1 == w2
        combinations = [(w1,w2) | w1 <- wlist1, w2 <- wlist2]

{- Following functions are defined for text processing purpose -}

whitespace :: [Char]
whitespace = ['\n', '\t', ',', ' ']

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

{- The following code handles IO actions -}

ask :: Question -> IO String 
ask question = do
    putStrLn ("<< Question: " ++ question) 
    getLine 

giveAnswer :: Answer -> IO ()
giveAnswer answer = do 
    putStrLn ("<< The right answer is: " ++ answer)

feedback :: Score -> IO () 
feedback score
    | score > 0.90 = putStrLn ("<< Correct, scored " ++ show score)
    | score > 0.75 = putStrLn ("<< Almost correct, scored " ++ show score)
    | score >= 0.5 = putStrLn ("<< Nice try, scored " ++ show score)
    | score < 0.5 = putStrLn ("<< Try harder, scored " ++ show score)

showCumulativeScore :: Score -> IO ()
showCumulativeScore score = putStrLn ("<< Total score: " ++ show score)

asker :: Score -> Database -> IO Database
asker score [] = return []
asker score (x:xs) = do
    input <- ask (question x)
    feedback (fitness input (answer x))
    giveAnswer (answer x)
    showCumulativeScore (score + (fitness input (answer x )))
    asker (score + (fitness input (answer x))) xs
    
main = asker 0.0 exampleBase    


