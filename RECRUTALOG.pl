/*

Perguntas meta:

1.	Quais as cidades de moradia dos candidatos?
2.	Qual a faixa etária dos candidatos?
3.	O regime de contratação é compatível com o regime pretendido pelos candidatos?
4.	A faixa de salário oferecida é compatível com as pretendidas?
5.	Quais candidatos estão na cidade da empresa recrutadora?
6.	Quais candidatos estão aptos a participar do processo seletivo?
7.	Quais os melhores candidatos para determinada vaga? Justifique.

*/

/*
 * menu de ajuda
 */
help :- 
    writeln('Menu de ajuda:'),
    writeln(''),
    writeln(''),
    writeln('1 - Utilizar get_candidate_city(Result) para encontrar as cidades dos candidatos'),
    writeln(''),
    writeln('2 - Utilizar get_canditates_ages(Result) para encontrar a idade dos candidatos'),
    writeln(''),
    writeln('3 - Utilizar show_match_contratacao para encontrar O regime de contratação é compatível 
             com o regime pretendido pelos candidatos'),
    writeln(''),
    writeln('4 - Utilizar salary_company_expected(COMPANY) para encontrar a faixa de salário oferecida 
             pela as empresas é compatível com as pretendidas pelos candidatos'),
    writeln(''),
    writeln('5 - Utilizar match_city(COMPANY) para encontrar candidatos que estão na cidade da empresa 
             recrutadora'),
    writeln(''),
    writeln('6 - Utilizar gshow_best_choice_selective_process_company(Result) para encontrar quais candidatos estão aptos a participar 
             do processo seletivo de determinada empresa'),
    writeln(''),
    writeln('7 - Utilizar gshow_best_choice_company(Result) para encontrar quais os melhores candidatos para determinada vaga').

/* 7 atributos */
/*  nome_da_candidato, linguagem, nível_de_qualificação, salario_esperado, cidade_que_mora, idade, tipo_de_contratação */
candidate(antonio, python, senior, 4000, cidadeB, 28, pj).
candidate('bob esponja', python, senior, 4000, cidadeB, 28, clt).
candidate(luiz, cmaismais, pleno, 1500, cidadeA, 26, clt).
candidate(marcelo, java, senior, 3000, cidadeC, 24, clt).
candidate(marcio, python, junior, 1000, cidadeC, 20, pj).
candidate(patrick, java, pleno, 3000, cidadeA, 33, clt).
candidate(piva, java, senior, 4000, cidadeB, 28, clt).
candidate(rogério, python, junior, 1000, cidadeC, 20, pj).
candidate(teste, cmaismais, pleno, 2000, cidadeB, 22, clt).

/* 7 atributos */
/*  nome_da_empresa, cidade_da_empresa, forma_de_trabalho, salario_esperado, nível_de_qualificação, linguagem_esperada, tipo_de_contratação_esperada */
company(empresaA, cidadeA, remoto, 1500, junior, python, pj).
company(empresaB, cidadeC, remoto, 4000, pleno, java, clt).
company(empresaC, cidadeB, presencial, 8000, senior, python, clt).

/*
 * 1.	Quais as cidades de moradia dos candidatos?
 */
get_candidate_city(Result) :-
    findall(CITY, candidate(_, _, _, _, CITY, _, _), R), sort(R, Result),
    format('Cidades dos candidados: ~w\n', [Result]).

/*
 * 2.	Qual a faixa etária dos candidatos?
 */

get_canditates_ages(Result) :-
    findall(AGE, candidate(_, _, _, _, _, AGE, _), R), sort(R, Result),
    format('Idade dos candidados: ~w\n', [Result]).

/*
 * 3.	O regime de contratação é compatível com o regime pretendido pelos candidatos?
 * 
 * clt/pj
 */
match_contratacao(COMPANY, CANDIDATE, CONTRATACAO) :-
    company(COMPANY, _, _, _, _, _,CONTRATACAO),
	candidate(CANDIDATE, _, _, _, _, _, CONTRATACAO).

show_match_contratacao :-
    company(COMPANY, _, _, _, _, _,CONTRATACAO),
    findall(CANDIDATE, match_contratacao(COMPANY, CANDIDATE, CONTRATACAO), R),
    sort(R, Result),
    format('Candidatos que dão match com as vagas da empresa ~w:\n', [COMPANY]),
    format('- Vaga ~w da empresa ~w: ~w', [CONTRATACAO, COMPANY, Result]).

/*
 * 4.	A faixa de salário oferecida é compatível com as pretendidas?
 */
salary_lower(CANDIDATE, EXPECTED_SALARY) :-
    candidate(CANDIDATE, _, _, SALARY, _, _, _),
    SALARY =< EXPECTED_SALARY.

salary_company_expected(COMPANY) :-
    company(COMPANY, _, _, EXPECTED_SALARY, _, _, _),
    findall(CANDIDATE, salary_lower(CANDIDATE, EXPECTED_SALARY) , R),
    msort(R, Result),
    format('Esses candidatos tem expectatvas de sálario,\ncompatíveis com a empresa ~w:\n~w', [COMPANY, Result]).
/*
 * 5.	Quais candidatos estão na cidade da empresa recrutadora?
 */
is_remote(COMPANY, OUT) :-
	company(COMPANY, _, IsREMOTE, _, _, _, _),
	(IsREMOTE = 'remoto', OUT=1; IsREMOTE = 'presencial', OUT=2).

match_city(COMPANY) :-
    is_remote(COMPANY, OUT), OUT = 1,
    findall(CANDIDATE, candidate(CANDIDATE, _, _, _, _, _, _), R),
    sort(R, Result),
    format('Candidatos que dão match com as vagas da empresa ~w:\n', [COMPANY]),
    format('~w', [Result]);
    is_remote(COMPANY, OUT), OUT = 2, company(COMPANY, CITY, _, _, _, _, _),
    findall(CANDIDATE, candidate(CANDIDATE, _, _, _, CITY, _, _), R),
    sort(R, Result),
    format('Candidatos que dão match com as vagas da empresa ~w:\n', [COMPANY]),
    format('~w', [Result]).

/*
 * 6.	Quais candidatos estão aptos a participar do processo seletivo?
 *
 * Os candidatos aptos a participar do processo seletivo devem atender os seguintes parâmetros:
 * tipo_de_contratação = tipo_de_contratação_esperada
 * nivel_de_qualificacao_esperado = nivel_de_qualificacao
 * salario_esperado <= salario_esperado_empresa
 */

match_qualification(COMPANY, CANDIDATE, QUALIFICATION) :-
	company(COMPANY, _, _, _, QUALIFICATION, _, _),
	candidate(CANDIDATE, _, QUALIFICATION, _, _, _, _).

/*seleciona as melhores opções para o processo seletivo para a empresa X*/
best_option_selective_process(COMPANY, CANDIDATE, CONTRATACAO, QUALIFICATION, EXPECTED_SALARY) :-
    match_contratacao(COMPANY, CANDIDATE, CONTRATACAO),
    match_qualification(COMPANY, CANDIDATE, QUALIFICATION),
    salary_lower(CANDIDATE, EXPECTED_SALARY).

/*Mostra melhores escolhas para o processo seletivo para a empresa X*/
gshow_best_choice_selective_process_company(Result) :-
    company(COMPANY, _, _, EXPECTED_SALARY, _, _, _),
    findall(CANDIDATE, best_option_selective_process(COMPANY, CANDIDATE, _CONTRATACAO, _QUALIFICATION, EXPECTED_SALARY), R),
    sort(R, Result),
    format('~w Melhores escolhas ~w', [COMPANY, Result]).

/*
 * 7.	Quais os melhores candidatos para determinada vaga? Justifique.
 * 
 * salário					<=		oferecido empresa,	ok
 * (remote ou presencial)	match	empresa				ok
 * linguagem				match	empresa,			ok
 * contratação				match	empresa,			ok
 * qualificação				match	empresa,			ok
 */
match_language(COMPANY, CANDIDATE, LANGUAGE) :-
    company(COMPANY, _, _, _, _, LANGUAGE, _),
	candidate(CANDIDATE, LANGUAGE, _, _, _, _, _).

show_match_language :-
    match_language(COMPANY, CANDIDATO, LANGUAGE),
    format('~w match ~w (~w)', [CANDIDATO, COMPANY, LANGUAGE]).
    
best_choice_company(COMPANY, CANDIDATE, CONTRATACAO, LANGUAGE, EXPECTED_SALARY) :-
    best_option_selective_process(COMPANY, CANDIDATE, CONTRATACAO, _QUALIFICATION, EXPECTED_SALARY),
    match_language(COMPANY, CANDIDATE, LANGUAGE).

show_best_choice_company(COMPANY) :-
    company(COMPANY, _, _, EXPECTED_SALARY, _, _, _),
    best_choice_company(COMPANY, CANDIDATE, _CONTRATACAO, _LANGUAGE, EXPECTED_SALARY),
    format('~w Melhor escolha ~w\n',[CANDIDATE, COMPANY]).

gshow_best_choice_company(Result) :-
    company(COMPANY, _, _, EXPECTED_SALARY, _, _, _),
    findall(CANDIDATE, best_choice_company(COMPANY, CANDIDATE, _CONTRATACAO, _LANGUAGE, EXPECTED_SALARY), R),
    sort(R, Result),
    format('~w Melhores escolhas ~w', [COMPANY, Result]).
