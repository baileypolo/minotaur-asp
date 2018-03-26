% INSERT NAMES AND EMAIL ADDRESSES OF YOUR GROUP MEMBERS:
%
%

maxsteps(50).

field(1..7,1..7).
start(6,1).
goal(1,2).
mino(4,6).

wall(1,1,1,2).
wall(4,1,5,1).
wall(4,1,4,2).
wall(6,1,7,1).
wall(6,1,6,2).

wall(1,2,2,2).
wall(4,2,4,3).
wall(5,2,6,2).

wall(1,3,1,4).
wall(2,3,3,3).
wall(5,3,6,3).

wall(1,4,1,5).
wall(2,4,3,4).
wall(3,4,3,5).
wall(4,4,4,5).
wall(5,4,5,5).

wall(1,5,2,5).
wall(5,5,6,5).
wall(6,5,7,5).
wall(7,5,7,6).

wall(1,6,2,6).
wall(1,6,1,7).
wall(3,6,3,7).
wall(4,6,5,6).
wall(6,6,7,6).

wall(2,7,3,7).
wall(5,7,6,7).


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

state(X,Y,MX,MY,0) :- start(X,Y), mino(MX,MY).

% pick any move for at while turns are less than maxsteps(T) and at isn't at goal

1{state(X',Y',MX'',MY'',T+1):move(X,Y,X',Y'),minomove(MX,MY,X',Y',MX',MY'),minomove(MX',MY',X',Y',MX'',MY'')}1 :- state(X,Y,MX,MY,T), maxsteps(S), T<S, not goal(X,Y), not (X,Y)=(MX,MY).

at(X,Y,T) :- state(X,Y,_,_,T).

#minimize { 1, T:at(_,_,T) }.

:- state(X,Y,MX,MY,_), (X,Y)=(MX,MY).
:- goal(X,Y), not at(X,Y,_).

#show at/3.
