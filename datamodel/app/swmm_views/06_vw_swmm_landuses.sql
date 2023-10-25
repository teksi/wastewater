-------
-- View for the swmm module class landuses
--------
CREATE OR REPLACE VIEW tww_app.swmm_vw_landuses AS
  SELECT
    value_en as Name,
    0 as sweepingInterval,
    0 as fractionAvailable,
    0 as lastSwept
  FROM tww_vl._planning_zone_kind;
