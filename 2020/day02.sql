\timing on

DROP SCHEMA IF EXISTS y2020d02 CASCADE;
CREATE SCHEMA y2020d02;

SET search_path=y2020d02;

CREATE TABLE dec02 (
  lineno BIGINT NOT NULL GENERATED ALWAYS AS IDENTITY,
  line TEXT NOT NULL
);

\copy dec02 (line) FROM PROGRAM 'curl -b session.netscape https://adventofcode.com/2020/day/2/input';


WITH
  re_splits (ms) AS (
    SELECT regexp_match(line, '^(\d+)-(\d+) (.): ([[:alpha:]]+)$')
      FROM dec02),
  tokenized (min_count, max_count, token, pw, token_count) AS (
    SELECT ms[1]::int AS min_count, ms[2]::int AS max_count, ms[3] AS token, ms[4] AS pw,
           (SELECT count(*) FROM regexp_matches(ms[4], ms[3], 'g')) AS token_count
      FROM re_splits),
  tokenized_plus AS (
     SELECT *
       FROM tokenized
       WHERE min_count <= token_count
             AND token_count <= max_count)
SELECT count(*)
  FROM tokenized_plus;


WITH
  re_splits (ms) AS (
    SELECT regexp_match(line, '^(\d+)-(\d+) (.): ([[:alpha:]]+)$')
      FROM dec02),
  tokenized (pos_1, pos_2, token, pw, tokens) AS (
    SELECT ms[1]::int AS pos_1, ms[2]::int AS pos_2, ms[3] AS token, ms[4] AS pw,
           regexp_split_to_array(ms[4], '') AS tokens
      FROM re_splits),
  tokenized_plus AS (
     SELECT pw, token, pos_1, tokens[pos_1] AS tok_1, pos_2, tokens[pos_2] AS tok_2
       FROM tokenized AS t)
SELECT count(*)
  FROM tokenized_plus
  WHERE (CAST(tok_1 = token AS int) + CAST(tok_2 = token AS int)) = 1;
