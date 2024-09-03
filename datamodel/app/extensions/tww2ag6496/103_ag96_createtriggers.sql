
DROP TRIGGER IF EXISTS on_gepknoten_insert ON tww_app.vw_agxx_gepknoten;
CREATE TRIGGER on_gepknoten_insert
    INSTEAD OF INSERT
    ON tww_app.vw_agxx_gepknoten
    FOR EACH ROW
    EXECUTE FUNCTION tww_app.ft_agxx_gepknoten_insert();

DROP TRIGGER IF EXISTS on_gepknoten_update ON tww_app.vw_agxx_gepknoten;
CREATE TRIGGER on_gepknoten_update
    INSTEAD OF UPDATE 
    ON tww_app.vw_agxx_gepknoten
    FOR EACH ROW
    EXECUTE FUNCTION tww_app.ft_agxx_gepknoten_update();


DROP TRIGGER IF EXISTS on_gepknoten_delete ON tww_app.vw_agxx_gepknoten;	
CREATE TRIGGER on_gepknoten_delete
    INSTEAD OF DELETE 
    ON tww_app.vw_agxx_gepknoten
    FOR EACH ROW
    EXECUTE FUNCTION tww_app.ft_agxx_gepknoten_delete();


DROP TRIGGER IF EXISTS on_gephaltung_insert ON tww_app.vw_agxx_gephaltung;	
CREATE TRIGGER on_gephaltung_insert
    INSTEAD OF INSERT
    ON tww_app.vw_agxx_gephaltung
    FOR EACH ROW
    EXECUTE FUNCTION tww_app.ft_agxx_gephaltung_insert();
	
DROP TRIGGER IF EXISTS on_gephaltung_update ON tww_app.vw_agxx_gephaltung;	
CREATE TRIGGER on_gephaltung_update
    INSTEAD OF UPDATE 
    ON tww_app.vw_agxx_gephaltung
    FOR EACH ROW
    EXECUTE FUNCTION tww_app.ft_agxx_gephaltung_update();
	
DROP TRIGGER IF EXISTS on_gephaltung_delete ON tww_app.vw_agxx_gephaltung;		
CREATE TRIGGER on_gephaltung_delete
    INSTEAD OF DELETE 
    ON tww_app.vw_agxx_gephaltung
    FOR EACH ROW
    EXECUTE FUNCTION tww_app.ft_agxx_gephaltung_delete();

DROP TRIGGER IF EXISTS on_gepmassnahme_upsert ON tww_app.vw_agxx_gepmassnahme;	
CREATE TRIGGER on_gepmassnahme_upsert
    INSTEAD OF INSERT OR UPDATE 
    ON tww_app.vw_agxx_gepmassnahme
    FOR EACH ROW
    EXECUTE FUNCTION tww_app.ft_agxx_gepmassnahme_upsert();

DROP TRIGGER IF EXISTS on_gepmassnahme_delete ON tww_app.vw_agxx_gepmassnahme;		
CREATE TRIGGER on_gepmassnahme_delete
    INSTEAD OF DELETE 
    ON tww_app.vw_agxx_gepmassnahme
    FOR EACH ROW
    EXECUTE FUNCTION tww_app.ft_agxx_gepmassnahme_delete();

DROP TRIGGER IF EXISTS on_einzugsgebiet_upsert ON tww_app.vw_agxx_einzugsgebiet;	
CREATE TRIGGER on_einzugsgebiet_upsert
    INSTEAD OF INSERT OR UPDATE 
    ON tww_app.vw_agxx_einzugsgebiet
    FOR EACH ROW
    EXECUTE FUNCTION tww_app.ft_agxx_einzugsgebiet_upsert();

DROP TRIGGER IF EXISTS on_einzugsgebiet_delete ON tww_app.vw_agxx_einzugsgebiet;		
CREATE TRIGGER on_einzugsgebiet_delete
    INSTEAD OF DELETE 
    ON tww_app.vw_agxx_einzugsgebiet
    FOR EACH ROW
    EXECUTE FUNCTION tww_app.ft_agxx_einzugsgebiet_delete();

DROP TRIGGER IF EXISTS on_ueberlauf_foerderaggregat_insert ON tww_app.vw_agxx_ueberlauf_foerderaggregat;		
CREATE TRIGGER on_ueberlauf_foerderaggregat_insert
    INSTEAD OF INSERT
    ON tww_app.vw_agxx_ueberlauf_foerderaggregat
    FOR EACH ROW
    EXECUTE FUNCTION tww_app.ft_agxx_ueberlauf_foerderaggregat_insert();

DROP TRIGGER IF EXISTS on_ueberlauf_foerderaggregat_update ON tww_app.vw_agxx_ueberlauf_foerderaggregat;		
CREATE TRIGGER on_ueberlauf_foerderaggregat_update
    INSTEAD OF UPDATE 
    ON tww_app.vw_agxx_ueberlauf_foerderaggregat
    FOR EACH ROW
    EXECUTE FUNCTION tww_app.ft_agxx_ueberlauf_foerderaggregat_update();

DROP TRIGGER IF EXISTS on_ueberlauf_foerderaggregat_delete ON tww_app.vw_agxx_ueberlauf_foerderaggregat;		
CREATE TRIGGER on_ueberlauf_foerderaggregat_delete
    INSTEAD OF DELETE 
    ON tww_app.vw_agxx_ueberlauf_foerderaggregat
    FOR EACH ROW
    EXECUTE FUNCTION tww_app.ft_agxx_ueberlauf_foerderaggregat_delete();

DROP TRIGGER IF EXISTS on_bautenausserhalbbaugebiet_upsert ON tww_app.vw_agxx_bautenausserhalbbaugebiet;	
CREATE TRIGGER on_bautenausserhalbbaugebiet_upsert
    INSTEAD OF INSERT OR UPDATE 
    ON tww_app.vw_agxx_bautenausserhalbbaugebiet
    FOR EACH ROW
    EXECUTE FUNCTION tww_app.ft_agxx_bautenausserhalbbaugebiet_upsert();

DROP TRIGGER IF EXISTS on_bautenausserhalbbaugebiet_delete ON tww_app.vw_agxx_bautenausserhalbbaugebiet;		
CREATE TRIGGER on_bautenausserhalbbaugebiet_delete
    INSTEAD OF DELETE 
    ON tww_app.vw_agxx_bautenausserhalbbaugebiet
    FOR EACH ROW
    EXECUTE FUNCTION tww_app.ft_agxx_bautenausserhalbbaugebiet_delete();

DROP TRIGGER IF EXISTS on_sbw_einzugsgebiet_upsert ON tww_app.vw_agxx_sbw_einzugsgebiet;	
CREATE TRIGGER on_sbw_einzugsgebiet_upsert
    INSTEAD OF INSERT OR UPDATE 
    ON tww_app.vw_agxx_sbw_einzugsgebiet
    FOR EACH ROW
    EXECUTE FUNCTION tww_app.ft_agxx_sbw_einzugsgebiet_upsert();

DROP TRIGGER IF EXISTS on_sbw_einzugsgebiet_delete ON tww_app.vw_agxx_sbw_einzugsgebiet;		
CREATE TRIGGER on_sbw_einzugsgebiet_delete
    INSTEAD OF DELETE 
    ON tww_app.vw_agxx_sbw_einzugsgebiet
    FOR EACH ROW
    EXECUTE FUNCTION tww_app.ft_agxx_sbw_einzugsgebiet_delete();

DROP TRIGGER IF EXISTS on_versickerungsbereichag_insert ON tww_app.vw_agxx_versickerungsbereichag;	
CREATE TRIGGER on_versickerungsbereichag_insert
    INSTEAD OF INSERT
    ON tww_app.vw_agxx_versickerungsbereichag
    FOR EACH ROW
    EXECUTE FUNCTION tww_app.ft_agxx_versickerungsbereichag_insert();

DROP TRIGGER IF EXISTS on_versickerungsbereichag_update ON tww_app.vw_agxx_versickerungsbereichag;	
CREATE TRIGGER on_versickerungsbereichag_update
    INSTEAD OF UPDATE 
    ON tww_app.vw_agxx_versickerungsbereichag
    FOR EACH ROW
    EXECUTE FUNCTION tww_app.ft_agxx_versickerungsbereichag_update();

DROP TRIGGER IF EXISTS on_versickerungsbereichag_delete ON tww_app.vw_agxx_versickerungsbereichag;		
CREATE TRIGGER on_versickerungsbereichag_delete
    INSTEAD OF DELETE 
    ON tww_app.vw_agxx_versickerungsbereichag
    FOR EACH ROW
    EXECUTE FUNCTION tww_app.ft_agxx_versickerungsbereichag_delete();

DROP TRIGGER IF EXISTS update_last_modified_agxx_wastewater_networkelement ON tww_od.wastewater_networkelement;		
CREATE TRIGGER update_last_modified_agxx_wastewater_networkelement
    BEFORE INSERT OR UPDATE 
    ON tww_od.wastewater_networkelement
    FOR EACH ROW
    EXECUTE FUNCTION tww_app.modification_last_modified_agxx();

DROP TRIGGER IF EXISTS update_last_modified_agxx_overflow ON tww_od.overflow;		
CREATE TRIGGER update_last_modified_agxx_overflow
    BEFORE INSERT OR UPDATE 
    ON tww_od.overflow
    FOR EACH ROW
    EXECUTE FUNCTION tww_app.modification_last_modified_agxx();
