/*

Obs's.: 

- Implementar de ter tipo de trabalho remoto ou presencial.

Perguntas meta:

1.	Quais candidatos estão aptos a participar do processo seletivo?
2.	Quais as cidades de moradia dos candidatos?
3.	Quais candidatos estão na cidade da empresa recrutadora?
4.	A faixa de salário oferecida é compatível com as pretendidas?
5.	Qual a faixa etária dos candidatos?
6.	O regime de contratação é compatível com o regime de contratação pretendido pelos candidatos?
7.	Quais os melhores candidatos para determinada vaga? Justifique.

senioridade(senior, 3)
senioridade(pleno, 2)
senioridade(junior, 1)

*/

/*
 * qualificacao(quali(junior, 1), quali(pleno, 2), quali(senior, 3)).
 * If-Then-Else statement
 * gt(X,Y) :- X >= Y,write('X maior ou igual a Y').
 * */

/* 7 atributos */
/*  nome_da_candidato, linguagem, nível_de_qualificação, salario_esperado, cidade_que_mora, idade, tipo_de_contratação */
candidate(rogério, python, junior, 1000, cidadeC, 20, pj).
candidate(marcio, python, junior, 1000, cidadeC, 20, pj).
candidate(teste, cmaismais, pleno, 2000, cidadeB, 22, clt).
candidate(marcelo, java, senior, 3000, cidadeC, 24, clt).
candidate(luiz, cmaismais, pleno, 1500, cidadeA, 26, clt).
candidate(piva, java, senior, 4000, cidadeB, 28, clt).

/* 7 atributos */
/*  nome_da_empresa, cidade_da_empresa, forma_de_trabalho, salario_esperado, nível_de_qualificação, linguagem_esperada, tipo_de_contratação_esperada */
company(empresaA, cidadeA, remoto, 1500, junior, python, pj).
company(empresaB, cidadeC, remoto, 4000, junior, java, clt).
company(empresaC, cidadeB, presencial,8000, pleno, python, clt).

/*
 * 1.	Quais candidatos estão aptos a participar do processo seletivo? GUSTAVO
 */

/*Obs.: Implementar o nivel de qualificação como nivel_de_qualificacao_esperado >= nivel_de_qualificacao
*/

/* Os candidatos aptos a participar do processo seletivo devem atender os seguintes parâmetros:
 * salario_esperado <= salario_esperado_empresa
 * nivel_de_qualificacao_esperado = nivel_de_qualificacao
 * tipo_de_contratação = tipo_de_contratação_esperada
 * */

/*seleciona a qualificação de cada candidato*/
match_qualificacao(COMPANY, CANDIDATE, QUALIFICACAO_COMPANY, QUALIFICACAO_CANDIDATE) :-
	company(COMPANY, _, _, _, QUALIFICACAO_COMPANY, _, _),
	candidate(CANDIDATE, _, QUALIFICACAO, _, _, _, _).

/*seleciona as melhores opções para o processo seletivo para a empresa X*/
best_option_processo_seletivo(COMPANY, CANDIDATE, CONTRATACAO, QUALIFICACAO, EXPECTED_SALARY) :-
    match_contratacao(COMPANY, CANDIDATE, CONTRATACAO),
    match_qualificacao(COMPANY, CANDIDATE, QUALIFICACAO),
    salary_lower(CANDIDATE, EXPECTED_SALARY).

/*Mostra melhor escolha para o processo seletivo da empresa X*/
show_best_choice_processo_seletivo_company(COMPANY) :-
    company(COMPANY, _, _, EXPECTED_SALARY, _, _, _),
    best_option_processo_seletivo(COMPANY, CANDIDATE, CONTRATACAO, QUALIFICACAO, EXPECTED_SALARY),
    format('~w Melhor escolha ~w\nmatchs: ~w , ~w, ~w',[CANDIDATE, COMPANY, CONTRATACAO, QUALIFICACAO, EXPECTED_SALARY]).

/*Mostra melhores escolhas para o processo seletivo para a empresa X*/
gshow_best_choice_processo_seletivo_company(Result) :-
    company(COMPANY, _, _, EXPECTED_SALARY, _, _, _),
    findall(CANDIDATE, best_option_processo_seletivo(COMPANY, CANDIDATE, CONTRATACAO, QUALIFICACAO, EXPECTED_SALARY), R),
    sort(R, Result),
    format('~w Melhores escolhas ~w', [COMPANY, Result]).

/*
 * 2.	Quais as cidades de moradia dos candidatos? LUCAS
 */
get_candidate_city(Result) :-
    findall(CITY, candidate(_, _, _, _, CITY, _, _), R), sort(R, Result),
    format('Cidades dos candidados: ~w\n', [Result]).

/*
 * 3.	Quais candidatos estão na cidade da empresa recrutadora? LUCAS
 */
is_remote(COMPANY, OUT) :-
	company(COMPANY, _, IsREMOTE, _, _, _, _),
	(IsREMOTE = 'remoto', OUT=1; IsREMOTE \= 'remoto', OUT=2).

match_city(COMPANY) :-
    (is_remote(COMPANY, _OUT) = 1,
        candidate(CANDIDATE, _, _, _, _, _, _);
     is_remote(COMPANY, OUT) \= 1,
        company(COMPANY, CITY, _, _, _, _, _),
        candidate(CANDIDATE, _, _, _, CITY, _, _)
    ).
    /*msort(R, Result),
    format('Empresa ~w na cidade ~w\ntem os seguintes candidatos:\n~w', [COMPANY, CITY, Result]).*/

/*
 * 4.	A faixa de salário oferecida é compatível com as pretendidas? LUCAS
 */
salary_lower(CANDIDATE, EXPECTED_SALARY) :-
    candidate(CANDIDATE, _, _, SALARY, _, _, _),
    SALARY =< EXPECTED_SALARY.

salary_company_expected(COMPANY, Result) :-
    company(COMPANY, _, EXPECTED_SALARY, _, _, _, _),
    findall(CANDIDATE, salary_lower(CANDIDATE, EXPECTED_SALARY) , R),
    msort(R, Result),
    format('Esses candidatos tem expectatvas de sálario,\ncompatíveis com a empresa ~w:\n~w', [COMPANY, Result]).

/*
 * 5.	Qual a faixa etária dos candidatos? GUSTAVO
 */

get_canditates_ages(Result) :-
    findall(AGE, candidate(_, _, _, _, _, AGE, _), R), sort(R, Result),
    format('Idade dos candidados: ~w\n', [Result]).
    
/*
 * 6.	O regime de contratação é compatível com o regime de
 * contratação pretendido pelos candidatos? LUCAS
 */
match_contratacao(EMPRESA, CANDIDATE, CONTRATACAO) :-
    company(EMPRESA, _, _, _, _, _,CONTRATACAO),
	candidate(CANDIDATE, _, _, _, _, _, CONTRATACAO).

show_match_contratacao :-
    match_contratacao(EMPRESA, CANDIDATE, CONTRATACAO),
    format('~w match ~w (~w)', [CANDIDATE, EMPRESA, CONTRATACAO]).

/*
 * 7.	Quais os melhores candidatos para determinada vaga? Justifique.
 * 
 * salário					<=		oferecido empresa,	ok
 * (remote ou presencial)	match	empresa				-
 * linguagem				match	empresa,			ok
 * contratação				match	empresa,			ok
 */
match_language(COMPANY, CANDIDATE, LANGUAGE) :-
    company(COMPANY, _, _, _, _, LANGUAGE, _),
	candidate(CANDIDATE, LANGUAGE, _, _, _, _, _).

show_match_language :-
    match_language(COMPANY, CANDIDATO, LANGUAGE),
    format('~w match ~w (~w)', [CANDIDATO, COMPANY, LANGUAGE]).
    
best_choice_company(COMPANY, CANDIDATE, CONTRATACAO, LANGUAGE, EXPECTED_SALARY) :-
    match_contratacao(COMPANY, CANDIDATE, CONTRATACAO),
    match_language(COMPANY, CANDIDATE, LANGUAGE),
    salary_lower(CANDIDATE, EXPECTED_SALARY).

show_best_choice_company(COMPANY) :-
    company(COMPANY, _, _, EXPECTED_SALARY, _, _, _),
    best_choice_company(COMPANY, CANDIDATE, CONTRATACAO, LANGUAGE, EXPECTED_SALARY),
    format('~w Melhor escolha ~w\nmatchs: ~w , ~w, ~w',[CANDIDATE, COMPANY, CONTRATACAO, LANGUAGE, EXPECTED_SALARY]).

gshow_best_choice_company(Result) :-
    company(COMPANY, _, _, EXPECTED_SALARY, _, _, _),
    findall(CANDIDATE, best_choice_company(COMPANY, CANDIDATE, _CONTRATACAO, _LANGUAGE, EXPECTED_SALARY), R),
    sort(R, Result),
    format('~w Melhores escolhas ~w', [COMPANY, Result]).