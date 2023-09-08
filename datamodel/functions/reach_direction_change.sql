/***************************************************************************
    reach_direction_change.sql
    ---------------------
    begin                : August 2018
    copyright            : (C) 2018 by Matthias Kuhn, OPENGIS.ch
    email                : matthias@opengis.ch
 ***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/

/**
 * This function changes the direction of a set of reaches.
 * It will change the direction of the line itself as well as switch the two reach points
 * to make sure the topology and reach point attributes stay the way they were.
 * 
 * With the parameter `reach_obj_ids` it is possible to specify on which reaches this operation
 * should be performed by passing in an array of obj_ids
 */
CREATE OR REPLACE FUNCTION qgep_od.reach_direction_change(reach_obj_ids text[])RETURNS void AS $BODY$

BEGIN 
 
UPDATE qgep_od.reach 
  SET
    progression_geometry = (ST_ForceCurve(ST_Reverse(ST_CurveToLine(progression_geometry)))),
    fk_reach_point_from = fk_reach_point_to,
    fk_reach_point_to = fk_reach_point_from
  WHERE obj_id = ANY(reach_obj_ids);
END;
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;
