% =========================
% Project 2 - Maze Solver
% CS4337 Fall 2025
% Author: Aamer Goual-Belhamidi
% =========================

% ----------- ENTRY POINT -----------

find_exit(Maze, Actions) :-
    valid_maze(Maze),
    find_start(Maze, StartRow, StartCol),
    solve(Maze, StartRow, StartCol, [], Actions).

% ----------- MAZE VALIDATION -----------

valid_maze(Maze) :-
    Maze \= [],
    maplist(same_length(Maze), Maze),
    flatten(Maze, Cells),
    include(==(s), Cells, Starts),
    length(Starts, 1),
    include(==(e), Cells, Exits),
    length(Exits, N),
    N > 0.

% ----------- FIND START -----------

find_start(Maze, R, C) :-
    nth0(R, Maze, Row),
    nth0(C, Row, s).

% ----------- SOLVER -----------

solve(Maze, R, C, Visited, []) :-
    cell(Maze, R, C, e).

solve(Maze, R, C, Visited, [Action | Actions]) :-
    move(Action, R, C, R2, C2),
    inside(Maze, R2, C2),
    cell(Maze, R2, C2, Cell),
    Cell \= w,
    \+ member((R2,C2), Visited),
    solve(Maze, R2, C2, [(R,C)|Visited], Actions).

% ----------- ACTION MOVES -----------

move(left,  R, C, R, C2) :- C2 is C - 1.
move(right, R, C, R, C2) :- C2 is C + 1.
move(up,    R, C, R2, C) :- R2 is R - 1.
move(down,  R, C, R2, C) :- R2 is R + 1.

% ----------- BOUNDS CHECK -----------

inside(Maze, R, C) :-
    R >= 0, C >= 0,
    length(Maze, Rows),
    R < Rows,
    nth0(R, Maze, Row),
    length(Row, Cols),
    C < Cols.

% ----------- CELL ACCESS -----------

cell(Maze, R, C, Value) :-
    nth0(R, Maze, Row),
    nth0(C, Row, Value).
