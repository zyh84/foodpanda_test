CREATE OR REPLACE TABLE
  `test-bot-pcraev.yuhao_test.q3` AS
WITH
  t1 AS (
  SELECT
    country,
    port_name,
    port_latitude,
    port_longitude,
    ST_DISTANCE(port_geom,
      ST_GEOGPOINT(-38.706256,
        32.610982)) AS distance_in_meters
  FROM
    `bigquery-public-data.geo_international_ports.world_port_index`
  WHERE
    provisions IS TRUE
    AND water IS TRUE
    AND fuel_oil IS TRUE
    AND diesel IS TRUE ),
  t2 AS (
  SELECT
    country,
    port_name,
    port_latitude,
    port_longitude,
    RANK() OVER (ORDER BY distance_in_meters ASC) AS rank
  FROM
    t1 )
SELECT
  country,
  port_name,
  port_latitude,
  port_longitude
FROM
  t2
WHERE
  rank <= 1;