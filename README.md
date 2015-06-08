June 8, 2015

TeeSpring coding challange: TicTacToe web App

J.C.

###Notes
* Tic-Tac-Toe web app hosted on heroku (might need to wait for sleeping dyno) [here](https://chamb-tictactoe.herokuapp.com/)
* Any feedback is welcome
* mongo, rails, html, javascript, css
* The majority of time spent on this project was on implementing javascript. 
* It has been a while since writing javascript from scrach and this project was a good front-end refresher for me.

###Todo's
* add keyboard controls (arrow keys toggle css border attribute on/off over tic-tac-toe cells via incrementing cell indices, space to execute move)
* add styling
* add integration specs
* implement better javascript ```isWinner``` function

###Improvments
* better job to namespace and use a more object-oriented approach in javascript code
* write enumerator functions for javascript Array class and string interpolation function for String class
* persist a log of all game moves, to 'take back' a move or replay game
* pass full serialized user objects to front end for richer game play
* partialize view for ```v1/ttt_game#new``` and ```v1/ttt_game#show``` to allow return to unfinished game (via show endpoint w/game-id in cookies)

###Limitations
* User collection is unique by name

