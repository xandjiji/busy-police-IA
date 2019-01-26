% autor: Alexandre Regali Seleghim (RA: 551473)

% para testar, basta usar no terminal:
% pegaLadrao([X,Y], L).
% (onde [X,Y] sao as coordenadas iniciais do policial e L sera a solucao final)
%
% EXEMPLO:
% pegaLadrao([5, 1], L).
% pegaLadraoEBolovo([5, 1], L).


% FATOS (objetos do mapa) %%%%%%%%%%%%%%%%%%%%%%%%

% ladrao
ladrao([7, 5]).

% bolovo
bolovo([10, 3]).

% paredes
paredes(0, 11).

% tetos
tetos(0, 6).

% carrinhos
carrinho(8, 1).
carrinho(3, 2).
carrinho(7, 3).
carrinho(3, 4).
carrinho(4, 5).

% escadas
escada(2, 1).
escada(9, 1).
escada(10, 1).
escada(6, 2).
escada(1, 3).
escada(8, 3).
escada(1, 4).
escada(8, 4).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% VERIFICACOES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% verifica se pode andar para direita
pode_direita(nao, [X, Y]) :-
    D is X + 1, carrinho(D, Y), pode_pular_direita(nao, [X, Y]), !;
    D is X + 1, paredes(_, D), !.
pode_direita(sim, [X, Y]) :- not(pode_direita(nao, [X, Y])).

% verifica se pode andar para esquerda
pode_esquerda(nao, [X, Y]) :-
    E is X - 1, carrinho(E, Y), pode_pular_esquerda(nao, [X, Y]), !;
    E is X - 1, paredes(E, _), !.
pode_esquerda(sim, [X, Y]) :- not(pode_esquerda(nao, [X, Y])).

% verifica se pode subir a escada
pode_subir_escada(sim, [X, Y]) :-
    N is Y + 1, not(tetos(_, N)), escada(X, Y).
pode_subir_escada(nao, [X, Y]) :- not(pode_subir_escada(sim, [X, Y])).

% verifica se pode descer a escada
pode_descer_escada(sim, [X, Y]) :-
    S is Y + 1, not(tetos(S, _)), NY is Y - 1, escada(X, NY).
pode_descer_escada(nao, [X, Y]) :- not(pode_descer_escada(sim, [X, Y])).

% verifica se pode pular para direita
pode_pular_direita(nao, [X, Y]) :-
    D is X + 1, not(carrinho(D, Y)), !;
    D is X + 2, paredes(_, D), !;
    D is X + 2, carrinho(D, Y), !;
    D is X + 2, escada(D, Y), !;
    D is X + 2, NY is Y - 1, escada(D, NY), !;
    D is X + 2, ladrao([D, Y]), !.
pode_pular_direita(sim, [X, Y]) :- not(pode_pular_direita(nao, [X, Y])).

% verifica se pode pular para esquerda
pode_pular_esquerda(nao, [X, Y]) :-
    E is X - 1, not(carrinho(E, Y)), !;
    E is X - 2, paredes(E, _), !;
    E is X - 2, carrinho(E, Y), !;
    E is X - 2, escada(E, Y), !;
    E is X - 2, NY is Y - 1, escada(E, NY), !;
    E is X - 2, ladrao([E, Y]), !.
pode_pular_esquerda(sim, [X, Y]) :- not(pode_pular_esquerda(nao, [X, Y])).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% ACOES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% movimentar para direita
s([X, Y], [NX, Y]) :-
        NX is X + 1,
        pode_direita(sim, [X, Y]).

% movimentar para esquerda
s([X, Y], [NX, Y]) :-
        NX is X - 1,
        pode_esquerda(sim, [X, Y]).

% movimentar para cima
s([X, Y], [X, NY]) :-
        NY is Y + 1,
        pode_subir_escada(sim, [X, Y]).

% movimentar para baixo
s([X, Y], [X, NY]) :-
        NY is Y - 1,
        pode_descer_escada(sim, [X, Y]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% COMPONDO A SOLUCAO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% chamada principal
pegaLadrao(Inicial, Solucao) :- busca([[Inicial]], Solucao).

% busca a solucao
busca([[Estado|Caminho]|_], [Estado|Caminho]) :- ladrao(Estado).
busca([Primeiro|Outros], Solucao) :-
    estende(Primeiro, Sucessores),
    concatena(Outros, Sucessores, NovaFronteira),
    busca(NovaFronteira, Solucao).

% bagof da solucao
estende([Estado|Caminho], ListaSucessores):-
    bagof([Sucessor, Estado|Caminho], (s(Estado, Sucessor), not(pertence(Sucessor, [Estado|Caminho]))), ListaSucessores), !.
estende(_, []).

% verificar se um elemento pertence a uma lista
pertence(Elem, [Elem|_ ]).
pertence(Elem, [ _| Cauda]) :- pertence(Elem, Cauda).

% concatenar duas listas
concatena([ ], L, L).
concatena([Cab|Cauda], L2, [Cab|Resultado]) :- concatena(Cauda, L2, Resultado).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% BONUS GAME %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pegaLadraoEBolovo(Inicial, Solucao) :-
    buscaBolovo(Inicial, S1),
    buscaLadrao(S1, S2),
    concatena(S2, S1, Solucao).

% busca a solucao (bolovo)
buscaBolovo(Inicial,Solucao) :- bl([[Inicial]],Solucao).
bl([[Estado|Caminho]|_],[Estado|Caminho]) :- bolovo(Estado).
bl([Primeiro|Outros], Solucao) :-
    estende(Primeiro,Sucessores),
    concatena(Outros,Sucessores,NovaFronteira),
    bl(NovaFronteira,Solucao).

% busca a solucao (ladrao)
buscaLadrao([Inicial|_],Solucao) :- bl2([[Inicial]],Solucao).
bl2([[Estado|Caminho]|_],[Estado|Caminho]) :- ladrao(Estado).
bl2([Primeiro|Outros], Solucao) :-
    estende(Primeiro,Sucessores),
    concatena(Outros,Sucessores,NovaFronteira),
    bl2(NovaFronteira,Solucao).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
