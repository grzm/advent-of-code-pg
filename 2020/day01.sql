\timing on

DROP SCHEMA IF EXISTS y2020d01 CASCADE;
CREATE SCHEMA y2020d01;
SET search_path=y2020d01;

CREATE TABLE dec01 (
  lineno BIGINT NOT NULL GENERATED ALWAYS AS IDENTITY,
  val BIGINT NOT NULL
);

\copy dec01 (val) FROM PROGRAM 'curl -b session.netscape https://adventofcode.com/2020/day/1/input';
VACUUM ANALYZE dec01;

CREATE INDEX ON dec01 (val, lineno);

WITH x (a, al, b, bl) AS (
  SELECT a.val AS a, a.lineno AS al,
         b.val AS b, b.lineno AS bl
    FROM dec01 a
    CROSS JOIN dec01 b)
SELECT a, b, a * b AS result
  FROM x
  WHERE a + b = 2020
  AND al < bl;

WITH x (a, al, b, bl, c, cl) AS (
  SELECT a.val AS a, a.lineno AS al,
         b.val AS b, b.lineno AS bl,
         c.val AS c, c.lineno AS cl
    FROM dec01 a
    CROSS JOIN dec01 b
    CROSS JOIN dec01 c)
SELECT a, b, c, a * b * c AS result
  FROM x
  WHERE a + b + c = 2020
        AND al < bl
        AND bl < cl;
