% INSERT NAMES AND EMAIL ADDRESSES OF YOUR GROUP MEMBERS:
%
%
maxsteps(40).

field(1..7,1..4).
start(3,3).
goal(2,1).
mino(1,3).

wall(1,3,2,3).
wall(2,3,3,3).
wall(2,2,2,3).
wall(5,2,6,2).
wall(6,2,7,2).
wall(6,1,6,2).

% walls are in both directions
wall(X1,Y1,X2,Y2) :- wall(X2,Y2,X1,Y1).

% move predicates where there is a legal move
move(X,Y,X+1,Y) :- field(X,Y), field(X+1,Y), not wall(X,Y,X+1,Y).
move(X,Y,X,Y+1) :- field(X,Y), field(X,Y+1), not wall(X,Y,X,Y+1).
move(X,Y,X-1,Y) :- field(X,Y), field(X-1,Y), not wall(X,Y,X-1,Y).
move(X,Y,X,Y-1) :- field(X,Y), field(X,Y-1), not wall(X,Y,X,Y-1).
move(X,Y,X,Y) :- field(X,Y).

% ground all possible minotaur movements
rightleft(MX,MY,TX,TY,X',Y') :- field(MX,MY), field(TX,TY), move(MX,MY,X',Y'), |(TX-MX)| > |(TX-X')|.
updown(MX,MY,TX,TY,X',Y') :- not rightleft(MX,MY,TX,TY,_,_), field(MX,MY), field(TX,TY), move(MX,MY,X',Y'), |(TY-MY)| > |(TY-Y')|.
stay(MX,MY,TX,TY,MX,MY) :- not rightleft(MX,MY,TX,TY,_,_), not updown(MX,MY,TX,TY,_,_), field(MX,MY), field(TX,TY).

minomove(MX,MY,TX,TY,X',Y') :- rightleft(MX,MY,TX,TY,X',Y').
minomove(MX,MY,TX,TY,X',Y') :- updown(MX,MY,TX,TY,X',Y').
minomove(MX,MY,TX,TY,X',Y') :- stay(MX,MY,TX,TY,X',Y').

% initial movement predicates are at start, mino, and turn = 0
at(X,Y,0) :- start(X,Y).
minotaur(X,Y,0) :- mino(X,Y).

% pick any move for at while turns are less than maxsteps(T) and at isn't at goal
1{at(X',Y',T+1):move(X,Y,X',Y')}1 :- at(X,Y,T), maxsteps(S), T<S, not goal(X,Y), not minotaur(X,Y,T).

minotaurstep(X',Y',T+1) :- minotaur(MX,MY,T), at(TX,TY,T+1), minomove(MX,MY,TX,TY,X',Y').
minotaur(X',Y',T) :- minotaurstep(MX,MY,T), at(TX,TY,T), minomove(MX,MY,TX,TY,X',Y').

fat(X,Y,T):- at(X,Y,T).
#minimize { 1, T:fat(_,_,T) }.

:- minotaur(X,Y,T), at(X,Y,T).
:- goal(X,Y), not at(X,Y,_).

#show fat/3.
