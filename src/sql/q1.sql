DECLARE
  jurong_port_geom GEOGRAPHY;
DECLARE
  jurong_port_index STRING;
SET
  (jurong_port_index,
    jurong_port_geom) = (
  SELECT
    AS STRUCT index_number,
    port_geom
  FROM
    `bigquery-public-data.geo_international_ports.world_port_index`
  WHERE
    country = 'SG'
    AND port_name = 'JURONG ISLAND');
CREATE OR REPLACE TABLE
  `test-bot-pcraev.yuhao_test.q1` AS
WITH
  t1 AS (
  SELECT
    port_name,
    ST_DISTANCE(port_geom,
      jurong_port_geom) AS distance_in_meters
  FROM
    `bigquery-public-data.geo_international_ports.world_port_index`
  WHERE
    index_number <> jurong_port_index ),
  t2 AS (
  SELECT
    port_name,
    distance_in_meters,
    RANK() OVER (ORDER BY distance_in_meters ASC) AS rank
  FROM
    t1
  ORDER BY
    rank )
SELECT
  port_name,
  distance_in_meters
FROM
  t2
WHERE
  rank <= 5;