CREATE OR REPLACE TABLE
  `test-bot-pcraev.yuhao_test.q2` AS
WITH
  t1 AS (
  SELECT
    country,
    COUNT(1) AS port_count
  FROM
    `bigquery-public-data.geo_international_ports.world_port_index`
  WHERE
    cargo_wharf IS TRUE
  GROUP BY
    country ),
  t2 AS (
  SELECT
    country,
    port_count,
    RANK() OVER (ORDER BY port_count DESC ) AS rank
  FROM
    t1 )
SELECT
  country,
  port_count
FROM
  t2
WHERE
  rank <= 1;