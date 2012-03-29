# elearn 

elearn is a very simple flashcard-based e-learning system for the command line. It is written in Haskell. This little program is not yet finished but can already be used. The user/programmer can add (Question, Answer)-pairs into the example database list. After compiling, you can even interpret this program with e.g. ghci, the user is in dialog with the program. The answer of the user is checked word-based with the right answer. In fact every word which is mentioned by the user and is in the right answer is a partial correct answer. The overall score for the answer is calculated by matched words divided by the amount of words of the correct answer. Therefore the maximum score for an answer is 1.0. Each score will be cumulated.

## Example

In the following is an example of an interaction between the program and the user. 

<pre>
Question: What are the main components of HCDP?
$ Produce Designs User Study

Nice try, scored 0.6666667
The right answer is: User Study Specification Produce Designs Evaluation
Total score: 0.6666667
</pre>

## License 

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



