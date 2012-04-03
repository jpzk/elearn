# elearn 

elearn is a very simple flashcard-based e-learning system for the command line. It is written in Haskell. After compiling, you can even interpret this program with e.g. ghci, the user is in dialog with the program. The answer of the user is checked word-based with the correct answer. In fact every word which is mentioned by the user and is in the correct answer is a partial correct answer. The overall score for the answer is calculated by matched words divided by the amount of words of the correct answer. Therefore the maximum score for an answer is 1.0. Each score will be cumulated. Happy learning!

## Installation 

At first you have to clone the repository, configure the elearn cabal package and build the cabal package. Here's how you can do it, assuming zsh% is your user-shell. If this is your first haskell compilation it might be possible that cabal is not on your system (install it!).

<pre>
zsh% git clone git://github.com/jpzk/elearn.git
zsh% cd elearn
zsh% cabal install
</pre>

After configuration, compilation and installing the binary executable is placed in ~/.cabal/bin/elearn. You're now able to elearn a stack by executing the program with a flashcard stack (CSV-file) as program argument. Assuming elearn is cloned to the home directoy one can read the example stack by: 

<pre>
zsh% ~/.cabal/bin/elearn ~/elearn/stacks/human-computer-interaction.stack
</pre>

## Adding a new stack

A stack is a simple CSV with question and answer seperated by a semicolon. Store stacks whereever you like and call elearn with the stack path of choice as program argument.  

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



