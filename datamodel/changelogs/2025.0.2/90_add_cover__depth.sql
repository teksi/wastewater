
ALTER TABLE tww_od.cover ADD COLUMN _depth numeric(6,3);
COMMENT ON COLUMN tww_od.cover._depth IS 'Function (calculated value) = cover level minus wastewater_node.bottom_level  / Funktion (berechneter Wert) = repräsentative Deckel.Deckelkote minus Abwasserknoten.Sohlenkote  / Fonction (valeur calculée) = COUVERCLE.COTE moins NOEUD_RESEAU.COTE_RADIER';
