-- Views for network following with the Python NetworkX module and the TWW Python plugins

/*
This generates a graph representing the network.
It also provides backwards-compatible views for the plugin.
*/

CREATE TABLE tww_od.network_node (
  id SERIAL PRIMARY KEY,
  node_type TEXT, -- one of wastewater_node, reachpoint or blind_connection
  ne_id TEXT NULL REFERENCES tww_od.wastewater_networkelement(obj_id) ON DELETE CASCADE, -- reference to the network element (this will reference the reach object for reachpoints)
  rp_id TEXT NULL REFERENCES tww_od.reach_point(obj_id) ON DELETE CASCADE, -- will only be set for reachpoints
  geom geometry('POINT', {SRID})
);

CREATE TABLE tww_od.network_segment (
  id SERIAL PRIMARY KEY,
  segment_type TEXT, -- either reach (if it's a reach segment) or junction (if it represents junction from/to a reachpoint)
  from_node INT REFERENCES tww_od.network_node(id) ON DELETE CASCADE,
  to_node INT REFERENCES tww_od.network_node(id) ON DELETE CASCADE,
  ne_id TEXT NULL REFERENCES tww_od.wastewater_networkelement(obj_id) ON DELETE CASCADE, -- reference to the network element (will only be set for segments corresponding to reaches)
  geom geometry('LINESTRING', {SRID})
);
