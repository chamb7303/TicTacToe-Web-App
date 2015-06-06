// listeners
$(document).ready(function() {
  $('#ttt-container .cell').click(submitMove);
  $('#ttt-new-game-form').submit(start_new_game);
});

// variables
var activePlayer = {};
var primaryPlayer = {
  piece: 'X'
};
var secondaryPlayer = {
  piece: 'O'
};

// Game
function start_new_game(e) {
  $.ajax({
    type: 'POST',
    url: $(this).attr('action'),
    data: $(this).serialize(),
    success: function(data, textStatus, xhr) {
      $('#ttt-board').attr('data-game-id', data['id']);
      var primaryPlayer['name'] = data['primary_player']['name'];
      var secondaryPlayer['name'] = data['secondary_player']['name'];
      clearCells();
      toggleActivePlayer();
      renderTurnInfo();
    },
    fail: function(data, textStatus, xhr) {
    }
  })

  return false;
};

function saveGameState(e) {
  $.ajax({
    type: 'PUT',
    url: '/v1/ttt_games/' + $('#ttt-board').data('game-id'),
    data: { "attributes": { "board_state": currentBoardState } },
    success: move,
    fail: function(data, textStatus, xhr) {
    }
  })
};

function toggleActivePlayer() {
  if (playerMovesCount(primaryPlayer) > playerMovesCount(secondaryPlayer)) {
    activePlayer = secondaryPlayer
  } else {
    activePlayer = primaryPlayer
  }
}

function move(data, testStatus, xhr) {
  renderBoard();

  if (isWinner(activePlayer)) {
    var winMessage = activePlayer['name'] + ' wins, Congratulations!';
    renderToTicker(winMessage);
  } else {
    toggleActivePlayer();
    renderTurnInfo();
  }
}

function submitMove(e) {
  var cell = $(this);

  if (cell.html() == '')  {
    cell.attr('data-mark', activePlayer['name'])

    saveGameState()
  }
};

function renderTurnInfo() {
  var infoString = activePlayer.name + "'s turn to play";
  renderToTicker(infoString);
}

// Board
function clearCells() {
  var cells = $('.cell');

  for (var i = 0; i < cells.length; i++) {
    var cell = $(cells[i]);
    cell.html('');
    cell.attr('data-mark', '');
  }
}

function currentBoardState() {
  var boardState = []
  var rowsCount = $('.row').length;
  var cells = $('.cell');

  for (var i = 0; i < cells.length; i++) {
    var cell = $(cells[i]);
    var boardStateIdx = cell.data('row') * rowsCount + cell.data('col');
    boardState[boardStateIdx] = cell.data('mark');
  }

  return boardState;
}

function renderBoard() {
  var cells = $('.cell');

  for (var i = 0; i < cells.length; i++) {
    var cell = $(cells[i]);
    var cellMark = cell.attr('data-mark');

    if (cellMark) { cell.html(playerByName(cellMark)['piece']) }
  }
}

function isWinner(player) {
  var winner = false;
  var rowsCount = $('.row').length;

  for (var rowIndex = 0; rowIndex < rowsCount; rowIndex++) {
    for (var colIndex = 0; colIndex < rowsCount; colIndex++) {
      var rowMarks = map($('.cell[data-row=' + rowIndex + ']'), cellHtml);
      var colMarks = map($('.cell[data-col=' + colIndex + ']'), cellHtml);

      if (isAll(rowMarks, player['piece']) || isAll(colMarks, player['piece'])) {
        winner = true;
      }
    }
  }

  var posDiagonalCells = [$('.cell[data-row=0][data-col=0]'), $('.cell[data-row=1][data-col=1]'), $('.cell[data-row=2][data-col=2]')]
  var negDiagonalCells = [$('.cell[data-row=2][data-col=0]'), $('.cell[data-row=1][data-col=1]'), $('.cell[data-row=0][data-col=2]')]
  var posDiagonalMarks = map(posDiagonalCells, cellHtml)
  var negDiagonalMarks = map(negDiagonalCells, cellHtml)

  if (isAll(posDiagonalMarks, player['piece']) || isAll(negDiagonalMarks, player['piece'])) {
    winner = true;
  }

  return winner;
}

function cellHtml(cell) {
  return $(cell).html();
}

// Player
function playerByName(name) {
  var players = [primaryPlayer, secondaryPlayer];

  for (var i = 0; i < players.length; i++) {
    var player = players[i];

    if (player.name == name) { return player; }
  }
}

function playerMovesCount(player) {
  return $('.cell[data-mark=' + player.name + ']').size()
}

// Ticker
function renderToTicker(message) {
  $('#ttt-ticker').html(message)
}

// helper
function isAll(array, object) {
  var all = true;

  for (var i = 0; i < array.length; i++) {
    if (array[i] !== object) {
      all = false;
    }
  }

  return all;
}

function map(array, funct) {
  var mappedArray = []

  for (var i = 0; i < array.length; i++) {
    mappedArray.push(funct(array[i]));
  }

  return mappedArray;
}

// key board controlls
