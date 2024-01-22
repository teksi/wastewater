--drop label COLUMNS

ALTER TABLE tww_od.wastewater_structure
DROP COLUMN _label,
DROP COLUMN cover_label,
DROP COLUMN bottom_label,
DROP COLUMN input_label,
DROP COLUMN output_label;


CREATE TABLE IF NOT EXISTS tww_app.tww_labels
(
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
	obj_id character varying(16) COLLATE pg_catalog."default" NOT NULL,
    label_type character varying(10),
	label_text text COLLATE pg_catalog."default"
	CONSTRAINT pkey_tww_od_labels_id PRIMARY KEY (id)
	, CONSTRAINT unique_tww_od_labels UNIQUE (obj_id,label_type)
);

COMMENT ON TABLE tww_app.tww_labels IS 'stores all labels. not part of the VSA-DSS data model,
added solely for TEKSI wastewater. has to be updated by triggers';

--------------------------------------------------------
-- UPDATE reach point label
-- Argument:
--  * obj_id of wastewater structure or NULL to update all
--------------------------------------------------------


CREATE OR REPLACE FUNCTION tww_app.update_reach_point_label(_obj_id text,
	_all boolean default false
	)
  RETURNS VOID AS
 $BODY$
  DECLARE
  _labeled_ws_status bigint[] ;
  _labeled_ch_func_hier bigint[];

  BEGIN
  -- Updates the reach_point labels of the wastewater_structure
  -- Function inputs
  -- _obj_id: obj_id of the associatied wastewater structure
  -- _all: optional boolean to update all reach points

  -- Function Variables
  -- _labeled_ws_status: codes of the ws_status to be labeled.
  -- _labeled_ch_func_hier: codes of the ch_function_hierarchic to be labeled.
  --

-- check value lists for label inclusion
SELECT array_agg(code) INTO _labeled_ws_status
FROM tww_vl.wastewater_structure_status
WHERE cfg_include_in_ws_labels;

SELECT array_agg(code) INTO _labeled_ch_func_hier
FROM tww_vl.channel_function_hierarchic
WHERE cfg_include_in_ws_labels;

    with
	--outputs
	outp as( SELECT
    ne.fk_wastewater_structure
    , rp.obj_id
	, ST_Azimuth(rp.situation_geometry,ST_PointN(re.progression_geometry,2)) as azimuth
    , row_number() OVER(PARTITION BY NE.fk_wastewater_structure
			ORDER BY (rp.fk_wastewater_networkelement=ws_nd.fk_main_wastewater_node)::int*-1 -- prioritise main wastewater node, invert due to asc order
	    			, vl_fh.order_fct_hierarchic
				, vl_uc.order_usage_current
	    			, ST_Azimuth(rp.situation_geometry
	    				, ST_PointN(ST_CurveToLine(re.progression_geometry),2))/pi()*180 ASC)
					as idx
    , count	(*) OVER(PARTITION BY NE.fk_wastewater_structure ) as max_idx
      FROM tww_od.reach_point rp
	  -- node
      LEFT JOIN tww_od.wastewater_networkelement ne ON rp.fk_wastewater_networkelement = ne.obj_id
	  LEFT JOIN tww_od.wastewater_node wn ON ne.obj_id = wn.obj_id
	  LEFT JOIN tww_od.wastewater_structure ws_nd ON ne.fk_wastewater_structure = ws_nd.obj_id
	  LEFT JOIN tww_od.channel ch_nd ON ne.fk_wastewater_structure = ch_nd.obj_id
	  -- network element from
      INNER JOIN tww_od.reach re ON rp.obj_id = re.fk_reach_point_from
      LEFT JOIN tww_od.wastewater_networkelement ne_re ON ne_re.obj_id = re.obj_id
      LEFT JOIN tww_od.channel ch ON ne_re.fk_wastewater_structure = ch.obj_id
	  LEFT JOIN tww_od.wastewater_structure ws ON ne_re.fk_wastewater_structure = ws.obj_id
	  LEFT JOIN tww_vl.channel_function_hierarchic vl_fh ON vl_fh.code = ch.function_hierarchic
	  LEFT JOIN tww_vl.channel_usage_current vl_uc ON vl_uc.code = ch.usage_current
	    WHERE ch_nd.obj_id is null -- do not label channels
	  AND ch.function_hierarchic= ANY(_labeled_ch_func_hier)
			AND ws.status = ANY(_labeled_ws_status)
		    AND ((_all AND ne.fk_wastewater_structure IS NOT NULL)
			  OR ne.fk_wastewater_structure= _obj_id)) ,

	--inputs
	inp as( SELECT
    ne.fk_wastewater_structure
    , rp.obj_id
    , row_number() OVER(PARTITION BY NE.fk_wastewater_structure
					ORDER BY (mod((((ST_Azimuth(rp.situation_geometry
												,ST_PointN(ST_CurveToLine(re.progression_geometry),-2)
											   )
									 - coalesce(o.azimuth,0))/pi()*180)+360)::numeric
								  ,360::numeric)
							 ) ASC
					   )
					as idx
    , count	(*) OVER(PARTITION BY NE.fk_wastewater_structure ) as max_idx
      FROM tww_od.reach_point rp
      LEFT JOIN tww_od.wastewater_networkelement ne ON rp.fk_wastewater_networkelement = ne.obj_id
      INNER JOIN tww_od.reach re ON rp.obj_id = re.fk_reach_point_to
      LEFT JOIN tww_od.wastewater_networkelement ne_re ON ne_re.obj_id = re.obj_id
      LEFT JOIN tww_od.channel ch ON ne_re.fk_wastewater_structure = ch.obj_id
	  LEFT JOIN tww_od.wastewater_structure ws ON ne_re.fk_wastewater_structure = ws.obj_id
	  LEFT JOIN outp o on o.fk_wastewater_structure=ne.fk_wastewater_structure AND o.idx=1
	  WHERE ch.function_hierarchic= ANY(_labeled_ch_func_hier)
			AND ws.status = ANY(_labeled_ws_status)
		    AND ((_all AND ne.fk_wastewater_structure IS NOT NULL)
			  OR ne.fk_wastewater_structure= _obj_id)),

  -- non-labeled rp
  null_label as(
     SELECT
    ne.fk_wastewater_structure
    , rp.obj_id
      FROM tww_od.reach_point rp
      LEFT JOIN tww_od.wastewater_networkelement ne ON rp.fk_wastewater_networkelement = ne.obj_id
      INNER JOIN tww_od.reach re ON rp.obj_id IN(re.fk_reach_point_to,re.fk_reach_point_from)
      LEFT JOIN tww_od.wastewater_networkelement ne_re ON ne_re.obj_id = re.obj_id
      LEFT JOIN tww_od.channel ch ON ne_re.fk_wastewater_structure = ch.obj_id
	  LEFT JOIN tww_od.wastewater_structure ws ON ne_re.fk_wastewater_structure = ws.obj_id
	  WHERE NOT(ch.function_hierarchic = ANY(_labeled_ch_func_hier)
			AND ws.status = ANY(_labeled_ws_status))
		    AND ((_all AND ne.fk_wastewater_structure IS NOT NULL)
			  OR ne.fk_wastewater_structure= _obj_id)),

  -- actual labels
  rp_label as
  (
  SELECT 'I'||CASE WHEN max_idx=1 THEN '' ELSE idx::text END as new_label
  , obj_id
  FROM inp
  UNION
  SELECT 'O'||CASE WHEN max_idx=1 THEN '' ELSE idx::text END as new_label
  , obj_id
  FROM outp
  UNION
  SELECT NULL as new_label
  , obj_id
  FROM null_label)
 --Upsert reach_point labels
  INSERT INTO tww_app.tww_labels (obj_id,label_type,label_text)
  SELECT  rp_label.obj_id,'main',rp_label.new_label
  FROM rp_label
  ON CONFLICT ON CONSTRAINT unique_tww_od_labels
  DO UPDATE
  SET label_text=EXCLUDED.label_text;

END;
$BODY$
LANGUAGE plpgsql
VOLATILE;


--------------------------------------------------------
-- UPDATE wastewater structure label
-- Argument:
--  * obj_id of wastewater structure or NULL to update all
--------------------------------------------------------


CREATE OR REPLACE FUNCTION tww_app.update_wastewater_structure_label(_obj_id text, _all boolean default false)
  RETURNS VOID AS
  $BODY$
  DECLARE
  myrec record;

BEGIN

EXECUTE tww_app.update_reach_point_label(_obj_id,_all);

WITH labeled_ws as
(

    SELECT   ws_obj_id as obj_id,
          Array[COALESCE(ws_identifier, '') ,
          CASE WHEN count(co_level)<2 THEN array_to_string(array_agg(E'\nC' || '=' || co_level ORDER BY idx DESC), '', '') ELSE
		  array_to_string(array_agg(E'\nC' || idx || '=' || co_level ORDER BY idx ASC), '', '') END,
          array_to_string(array_agg(E'\nB' || '=' || bottom_level), '', ''),
		  array_to_string(array_agg(E'\n'||rpi_label|| '=' || rpi_level ORDER BY rpi_label ASC), '', '') ,
		  array_to_string(array_agg(E'\n'||rpo_label|| '=' || rpo_level ORDER BY rpo_label ASC), '', '')] as label_array
		  FROM (
		  SELECT ws.obj_id AS ws_obj_id
		  , ws.identifier AS ws_identifier
		  , parts.co_level AS co_level
		  , parts.rpi_level AS rpi_level
		  , parts.rpo_level AS rpo_level
		  , parts.rpi_label AS rpi_label
		  , parts.rpo_label AS rpo_label
		  , parts.obj_id, idx
		  , parts.bottom_level AS bottom_level
    FROM tww_od.wastewater_structure WS

    LEFT JOIN (
	  --cover
      SELECT
		coalesce(round(CO.level, 2)::text, '?') AS co_level
		, SP.fk_wastewater_structure ws
		, SP.obj_id
		, row_number() OVER(PARTITION BY SP.fk_wastewater_structure) AS idx
		, NULL::text AS bottom_level
		, NULL::text AS rpi_level
		, NULL::text  AS rpo_level
		, NULL::text as rpi_label
		, NULL::text  AS rpo_label
      FROM tww_od.structure_part SP
      RIGHT JOIN tww_od.cover CO ON CO.obj_id = SP.obj_id
      WHERE _all OR SP.fk_wastewater_structure = _obj_id
      -- Bottom
      UNION
      SELECT
		NULL AS co_level
		, ws1.obj_id ws
		, NULL as obj_id
		, NULL as idx
		, coalesce(round(wn.bottom_level, 2)::text, '?') AS wn_bottom_level
		, NULL::text AS rpi_level
		, NULL::text  AS rpo_level
		, NULL::text as rpi_label
		, NULL::text  AS rpo_label
      FROM tww_od.wastewater_structure ws1
      LEFT JOIN tww_od.wastewater_node wn ON wn.obj_id = ws1.fk_main_wastewater_node
      WHERE _all OR ws1.obj_id = _obj_id
	  UNION
	  --input
      SELECT
		NULL AS co_level
		, NE.fk_wastewater_structure ws
		, RP.obj_id
		,NULL as idx
		, NULL::text AS bottom_level
		, coalesce(round(RP.level, 2)::text, '?') AS rpi_level
		, NULL::text AS rpo_level
		, lb.label_text as rpi_label
		,  NULL::text AS rpo_label
      FROM tww_od.reach_point RP
      LEFT JOIN tww_od.wastewater_networkelement NE ON RP.fk_wastewater_networkelement = NE.obj_id
	  LEFT JOIN tww_app.tww_labels lb on RP.obj_id=lb.obj_id and lb.label_type='main'
      WHERE (_all OR NE.fk_wastewater_structure = _obj_id) and left(lb.label_text,1)='I'
      -- output
      UNION
      SELECT
		NULL AS co_level
		, NE.fk_wastewater_structure ws
		, RP.obj_id
		,NULL as idx
		, NULL::text AS bottom_level
		, coalesce(round(RP.level, 2)::text, '?') AS rpi_level
		, NULL::text AS rpo_level
		, lb.label_text as rpi_label
		,  NULL::text AS rpo_label
      FROM tww_od.reach_point RP
      LEFT JOIN tww_od.wastewater_networkelement NE ON RP.fk_wastewater_networkelement = NE.obj_id
	  LEFT JOIN tww_app.tww_labels lb on RP.obj_id=lb.obj_id and lb.label_type='main'
      WHERE (_all OR NE.fk_wastewater_structure = _obj_id) and left(lb.label_text,1)='O'
	) parts ON parts.ws = ws.obj_id
    WHERE _all OR ws.obj_id =_obj_id
    ) all_parts
	GROUP BY ws_obj_id, COALESCE(ws_identifier, '')
)
  INSERT INTO tww_app.tww_labels lab (obj_id,label_type,label_text)
  SELECT
      ws_obj_id
    , unnest(
      Array[
	      'main'
		, 'cover'
		, 'bottom'
		, 'input'
		, 'output'
		]
	  )
	, unnest(label_array)
  FROM labeled_ws
  ON CONFLICT ON CONSTRAINT unique_tww_od_labels
  DO UPDATE
  SET label_text=EXCLUDED.label_text;

END

$BODY$
LANGUAGE plpgsql
VOLATILE;

--------------------------------------------------
-- ON WASTEWATER STRUCTURE CHANGE
--------------------------------------------------
-- previously, instead of executing tww_app.update_wastewater_structure_label(_ws_obj_id), remove returning label
CREATE OR REPLACE FUNCTION tww_app.on_wastewater_structure_update()
  RETURNS trigger AS
$BODY$
DECLARE
  _ws_obj_id TEXT;
BEGIN
  -- Prevent recursion
  IF COALESCE(OLD.identifier, '') = COALESCE(NEW.identifier, '') THEN
    RETURN NEW;
  END IF;
  _ws_obj_id = OLD.obj_id;
  EXECUTE tww_app.update_wastewater_structure_label(_ws_obj_id);

  IF OLD.fk_main_cover != NEW.fk_main_cover THEN
    EXECUTE tww_app.update_depth(_ws_obj_id);
  END IF;


  RETURN NEW;
END; $BODY$
LANGUAGE plpgsql VOLATILE;


--------------------------------------------------
-- Update all labels
--------------------------------------------------
SELECT tww_app.update_wastewater_structure_label(NULL,TRUE);
