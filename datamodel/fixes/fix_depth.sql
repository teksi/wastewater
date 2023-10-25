ALTER TABLE qgep_od.cover
DROP COLUMN depth;

ALTER TABLE qgep_od.manhole
DROP COLUMN depth;

ALTER TABLE qgep_od.discharge_point
DROP COLUMN depth;

ALTER TABLE qgep_od.special_structure
DROP COLUMN depth;

ALTER TABLE qgep_od.infiltration_installation
DROP COLUMN depth;

ALTER TABLE qgep_od.wastewater_structure ADD COLUMN _depth numeric(6,3);
COMMENT ON COLUMN qgep_od.wastewater_structure._depth IS 'yyy_Funktion (berechneter Wert) = repräsentative Abwasserknoten.Sohlenkote minus zugehörige Deckenkote des Bauwerks falls Detailgeometrie vorhanden, sonst Funktion (berechneter Wert) = Abwasserknoten.Sohlenkote minus zugehörige Deckel.Kote des Bauwerks / Funktion (berechneter Wert) = repräsentative Abwasserknoten.Sohlenkote minus zugehörige Deckenkote des Bauwerks falls Detailgeometrie vorhanden, sonst Funktion (berechneter Wert) = Abwasserknoten.Sohlenkote minus zugehörige Deckel.Kote des Bauwerks / Fonction (valeur calculée) = NOEUD_RESEAU.COTE_RADIER représentatif moins COTE_PLAFOND de l’ouvrage correspondant si la géométrie détaillée est disponible, sinon fonction (valeur calculée) = NŒUD_RESEAU.COT_RADIER moins COUVERCLE.COTE de l’ouvrage correspondant';

