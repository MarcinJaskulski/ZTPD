-- zad 1
CREATE TABLE CYTATY AS SELECT * FROM ZSBD_TOOLS.CYTATY;

SELECT * FROM CYTATY;

-- zad 2
SELECT AUTOR, TEKST
FROM CYTATY
WHERE UPPER(TEKST) LIKE '%PESYMISTA%'
AND UPPER(TEKST) LIKE '%OPTYMISTA%';

-- zad 3
CREATE INDEX CYTATY_TEKST_IDX
ON CYTATY(TEKST)
INDEXTYPE IS CTXSYS.CONTEXT;

-- zad 4
SELECT AUTOR, TEKST
FROM CYTATY
WHERE CONTAINS(TEKST, 'PESYMISTA AND OPTYMISTA', 1) > 0;

-- zad 5
SELECT AUTOR, TEKST
FROM CYTATY
WHERE CONTAINS(TEKST, 'PESYMISTA ~ OPTYMISTA', 1) > 0;

-- zad 6
SELECT AUTOR, TEKST
FROM CYTATY
WHERE CONTAINS(TEKST, 'NEAR((PESYMISTA, OPTYMISTA), 3)') > 0;

-- zad 7
SELECT
    AUTOR,
    TEKST
FROM CYTATY
WHERE CONTAINS(TEKST, 'NEAR((PESYMISTA, OPTYMISTA), 10)') > 0;

-- zad 8
SELECT AUTOR, TEKST
FROM CYTATY
WHERE CONTAINS(TEKST, '¿yci%', 1) > 0;

-- zad 9
SELECT AUTOR, TEKST, SCORE(1) AS DOPASOWANIE
FROM CYTATY
WHERE CONTAINS(TEKST, '¿yci%', 1) > 0;

-- zad 10
SELECT AUTOR, TEKST, SCORE(1) AS DOPASOWANIE
FROM CYTATY
WHERE CONTAINS(TEKST, '¿yci%', 1) > 0
AND ROWNUM <= 1
ORDER BY 3 DESC;

-- zad 11
SELECT AUTOR, TEKST
FROM CYTATY
WHERE CONTAINS(TEKST, 'FUZZY(problem,,,N)', 1) > 0;

-- zad 12
INSERT INTO CYTATY VALUES(
    1000,
    'Bertrand Russell',
    'To smutne, ¿e g³upcy s¹ tacy pewni siebie, a ludzie rozs¹dni tacy pe³ni w¹tpliwoœci.'
);
COMMIT;

-- zad 13
SELECT AUTOR, TEKST
FROM CYTATY
WHERE CONTAINS(TEKST, 'g³upcy', 1) > 0;

-- Odp: Odœwie¿anie indeksu nie jest automatyczne.

-- zad 14
SELECT TOKEN_TEXT
FROM DR$CYTATY_TEKST_IDX$I;

SELECT TOKEN_TEXT
FROM DR$CYTATY_TEKST_IDX$I
WHERE TOKEN_TEXT = 'g³upcy';

-- zad 15
DROP INDEX CYTATY_TEKST_IDX;

CREATE INDEX CYTATY_TEKST_IDX
ON CYTATY(TEKST)
INDEXTYPE IS CTXSYS.CONTEXT;

-- zad 16
SELECT AUTOR, TEKST
FROM CYTATY
WHERE CONTAINS(TEKST, 'g³upcy', 1) > 0;

-- zad 17
DROP INDEX CYTATY_TEKST_IDX;

DROP TABLE CYTATY;


/****** Zaawansowane indeksowanie i wyszukiwanie *****/
-- zad 1
CREATE TABLE QUOTES AS SELECT * FROM ZSBD_TOOLS.QUOTES;

SELECT * FROM QUOTES;

-- zad 2
CREATE INDEX QUOTES_TEXT_IDX
ON QUOTES(TEXT)
INDEXTYPE IS CTXSYS.CONTEXT;

-- zad 3
SELECT AUTHOR, TEXT
FROM QUOTES
WHERE CONTAINS(TEXT, 'work', 1) > 0;

SELECT AUTHOR, TEXT
FROM QUOTES
WHERE CONTAINS(TEXT, '$work', 1) > 0;

SELECT AUTHOR, TEXT
FROM QUOTES
WHERE CONTAINS(TEXT, 'working’', 1) > 0;

SELECT AUTHOR, TEXT
FROM QUOTES
WHERE CONTAINS(TEXT, '$working’', 1) > 0;

-- zad 4
SELECT AUTHOR, TEXT
FROM QUOTES
WHERE CONTAINS(TEXT, 'it', 1) > 0;

-- "it" jest na liscie stopwords, co powoduje brak wyniku.

-- zad 5
SELECT * FROM CTX_STOPLISTS;

-- zad 6
SELECT * FROM CTX_STOPWORDS;

-- zad 7
DROP INDEX QUOTES_TEXT_IDX;

CREATE INDEX QUOTES_TEXT_IDX
ON QUOTES(TEXT)
INDEXTYPE IS CTXSYS.CONTEXT
PARAMETERS ('stoplist CTXSYS.EMPTY_STOPLIST');

-- zad 8
SELECT AUTHOR, TEXT
FROM QUOTES
WHERE CONTAINS(TEXT, 'it', 1) > 0;

-- Odp: Tak

-- zad 9
SELECT AUTHOR, TEXT
FROM QUOTES
WHERE CONTAINS(TEXT, 'fool AND humans', 1) > 0;

-- zad 10
SELECT AUTHOR, TEXT
FROM QUOTES
WHERE CONTAINS(TEXT, 'fool AND computer', 1) > 0;

-- zad 11
SELECT AUTHOR, TEXT
FROM QUOTES
WHERE CONTAINS(TEXT, '(fool AND humans) WITHIN SENTENCE', 1) > 0;

-- Odp: Sekcja SENTENCE nie istnieje.

-- zad 12
DROP INDEX QUOTES_TEXT_IDX;

-- zad 13
BEGIN
    ctx_ddl.create_section_group('nullgroup', 'NULL_SECTION_GROUP');
    ctx_ddl.add_special_section('nullgroup',  'SENTENCE');
    ctx_ddl.add_special_section('nullgroup',  'PARAGRAPH');
END;


-- zad 14
CREATE INDEX QUOTES_TEXT_IDX
ON QUOTES(TEXT)
INDEXTYPE IS CTXSYS.CONTEXT
PARAMETERS ('stoplist CTXSYS.EMPTY_STOPLIST section group nullgroup');

-- zad 15
SELECT AUTHOR, TEXT
FROM QUOTES
WHERE CONTAINS(TEXT, '(fool AND humans) WITHIN SENTENCE', 1) > 0;

SELECT AUTHOR, TEXT
FROM QUOTES
WHERE CONTAINS(TEXT, '(fool AND computer) WITHIN SENTENCE', 1) > 0;

-- zad 16
SELECT AUTHOR, TEXT
FROM QUOTES
WHERE CONTAINS(TEXT, 'humans', 1) > 0;

-- Odp: Tak - laxer potraktowa znak "-" jako niealfanumeryczny

-- zad 17
DROP INDEX QUOTES_TEXT_IDX;

BEGIN
    ctx_ddl.create_preference('lex_z_m','BASIC_LEXER');
    ctx_ddl.set_attribute('lex_z_m', 'printjoins', '-');
    ctx_ddl.set_attribute('lex_z_m', 'index_text', 'YES');
END;


CREATE INDEX QUOTES_TEXT_IDX
ON QUOTES(TEXT)
INDEXTYPE IS CTXSYS.CONTEXT
PARAMETERS ('
    stoplist CTXSYS.EMPTY_STOPLIST
    section group nullgroup
    LEXER lex_z_m');

-- zad 18
SELECT AUTHOR, TEXT
FROM QUOTES
WHERE CONTAINS(TEXT, 'humans', 1) > 0;

-- Odp: Nie.

--- zad 19
SELECT AUTHOR, TEXT
FROM QUOTES
WHERE CONTAINS(TEXT, 'non\-humans', 1) > 0;

-- zad 20
DROP TABLE QUOTES;

BEGIN
    ctx_ddl.drop_preference('lex_z_m');
END;

