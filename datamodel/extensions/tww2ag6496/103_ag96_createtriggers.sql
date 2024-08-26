
DROP TRIGGER IF EXISTS on_gepknoten_insert ON {ext_schema}.gepknoten;
CREATE TRIGGER on_gepknoten_insert
    INSTEAD OF INSERT
    ON {ext_schema}.gepknoten
    FOR EACH ROW
    EXECUTE FUNCTION {ext_schema}.ft_gepknoten_insert();

DROP TRIGGER IF EXISTS on_gepknoten_upsate ON {ext_schema}.gepknoten;
CREATE TRIGGER on_gepknoten_upsate
    INSTEAD OF UPDATE 
    ON {ext_schema}.gepknoten
    FOR EACH ROW
    EXECUTE FUNCTION {ext_schema}.ft_gepknoten_update();

DROP TRIGGER IF EXISTS on_gepknoten_delete ON {ext_schema}.gepknoten;	
CREATE TRIGGER on_gepknoten_delete
    INSTEAD OF DELETE 
    ON {ext_schema}.gepknoten
    FOR EACH ROW
    EXECUTE FUNCTION {ext_schema}.ft_gepknoten_delete();

DROP TRIGGER IF EXISTS on_gephaltung_insert ON {ext_schema}.gephaltung;	
CREATE TRIGGER on_gephaltung_insert
    INSTEAD OF INSERT
    ON {ext_schema}.gephaltung
    FOR EACH ROW
    EXECUTE FUNCTION {ext_schema}.ft_gephaltung_insert();
	
DROP TRIGGER IF EXISTS on_gephaltung_update ON {ext_schema}.gephaltung;	
CREATE TRIGGER on_gephaltung_update
    INSTEAD OF UPDATE 
    ON {ext_schema}.gephaltung
    FOR EACH ROW
    EXECUTE FUNCTION {ext_schema}.ft_gephaltung_update();
	
DROP TRIGGER IF EXISTS on_gephaltung_delete ON {ext_schema}.gephaltung;		
CREATE TRIGGER on_gephaltung_delete
    INSTEAD OF DELETE 
    ON {ext_schema}.gephaltung
    FOR EACH ROW
    EXECUTE FUNCTION {ext_schema}.ft_gephaltung_delete();

DROP TRIGGER IF EXISTS on_gepmassnahme_upsert ON {ext_schema}.gepmassnahme;	
CREATE TRIGGER on_gepmassnahme_upsert
    INSTEAD OF INSERT OR UPDATE 
    ON {ext_schema}.gepmassnahme
    FOR EACH ROW
    EXECUTE FUNCTION {ext_schema}.ft_gepmassnahme_upsert();

DROP TRIGGER IF EXISTS on_gepmassnahme_delete ON {ext_schema}.gepmassnahme;		
CREATE TRIGGER on_gepmassnahme_delete
    INSTEAD OF DELETE 
    ON {ext_schema}.gepmassnahme
    FOR EACH ROW
    EXECUTE FUNCTION {ext_schema}.ft_gepmassnahme_delete();

DROP TRIGGER IF EXISTS on_einzugsgebiet_upsert ON {ext_schema}.einzugsgebiet;	
CREATE TRIGGER on_einzugsgebiet_upsert
    INSTEAD OF INSERT OR UPDATE 
    ON {ext_schema}.einzugsgebiet
    FOR EACH ROW
    EXECUTE FUNCTION {ext_schema}.ft_einzugsgebiet_upsert();

DROP TRIGGER IF EXISTS on_einzugsgebiet_delete ON {ext_schema}.einzugsgebiet;		
CREATE TRIGGER on_einzugsgebiet_delete
    INSTEAD OF DELETE 
    ON {ext_schema}.einzugsgebiet
    FOR EACH ROW
    EXECUTE FUNCTION {ext_schema}.ft_einzugsgebiet_delete();

DROP TRIGGER IF EXISTS on_ueberlauf_foerderaggregat_insert ON {ext_schema}.ueberlauf_foerderaggregat;		
CREATE TRIGGER on_ueberlauf_foerderaggregat_insert
    INSTEAD OF INSERT
    ON {ext_schema}.ueberlauf_foerderaggregat
    FOR EACH ROW
    EXECUTE FUNCTION {ext_schema}.ft_ueberlauf_foerderaggregat_insert();

DROP TRIGGER IF EXISTS on_ueberlauf_foerderaggregat_update ON {ext_schema}.ueberlauf_foerderaggregat;		
CREATE TRIGGER on_ueberlauf_foerderaggregat_update
    INSTEAD OF UPDATE 
    ON {ext_schema}.ueberlauf_foerderaggregat
    FOR EACH ROW
    EXECUTE FUNCTION {ext_schema}.ft_ueberlauf_foerderaggregat_update();

DROP TRIGGER IF EXISTS on_ueberlauf_foerderaggregat_delete ON {ext_schema}.ueberlauf_foerderaggregat;		
CREATE TRIGGER on_ueberlauf_foerderaggregat_delete
    INSTEAD OF DELETE 
    ON {ext_schema}.ueberlauf_foerderaggregat
    FOR EACH ROW
    EXECUTE FUNCTION {ext_schema}.ft_ueberlauf_foerderaggregat_delete();

DROP TRIGGER IF EXISTS on_bautenausserhalbbaugebiet_upsert ON {ext_schema}.bautenausserhalbbaugebiet;	
CREATE TRIGGER on_bautenausserhalbbaugebiet_upsert
    INSTEAD OF INSERT OR UPDATE 
    ON {ext_schema}.bautenausserhalbbaugebiet
    FOR EACH ROW
    EXECUTE FUNCTION {ext_schema}.ft_bautenausserhalbbaugebiet_upsert();

DROP TRIGGER IF EXISTS on_bautenausserhalbbaugebiet_delete ON {ext_schema}.bautenausserhalbbaugebiet;		
CREATE TRIGGER on_bautenausserhalbbaugebiet_delete
    INSTEAD OF DELETE 
    ON {ext_schema}.bautenausserhalbbaugebiet
    FOR EACH ROW
    EXECUTE FUNCTION {ext_schema}.ft_bautenausserhalbbaugebiet_delete();

DROP TRIGGER IF EXISTS on_sbw_einzugsgebiet_upsert ON {ext_schema}.sbw_einzugsgebiet;	
CREATE TRIGGER on_sbw_einzugsgebiet_upsert
    INSTEAD OF INSERT OR UPDATE 
    ON {ext_schema}.sbw_einzugsgebiet
    FOR EACH ROW
    EXECUTE FUNCTION {ext_schema}.ft_sbw_einzugsgebiet_upsert();

DROP TRIGGER IF EXISTS on_sbw_einzugsgebiet_delete ON {ext_schema}.sbw_einzugsgebiet;		
CREATE TRIGGER on_sbw_einzugsgebiet_delete
    INSTEAD OF DELETE 
    ON {ext_schema}.sbw_einzugsgebiet
    FOR EACH ROW
    EXECUTE FUNCTION {ext_schema}.ft_sbw_einzugsgebiet_delete();

DROP TRIGGER IF EXISTS on_versickerungsbereichag_insert ON {ext_schema}.versickerungsbereichag;	
CREATE TRIGGER on_versickerungsbereichag_insert
    INSTEAD OF INSERT
    ON {ext_schema}.versickerungsbereichag
    FOR EACH ROW
    EXECUTE FUNCTION {ext_schema}.ft_versickerungsbereichag_insert();

DROP TRIGGER IF EXISTS on_versickerungsbereichag_update ON {ext_schema}.versickerungsbereichag;	
CREATE TRIGGER on_versickerungsbereichag_update
    INSTEAD OF UPDATE 
    ON {ext_schema}.versickerungsbereichag
    FOR EACH ROW
    EXECUTE FUNCTION {ext_schema}.ft_versickerungsbereichag_update();

DROP TRIGGER IF EXISTS on_versickerungsbereichag_delete ON {ext_schema}.versickerungsbereichag;		
CREATE TRIGGER on_versickerungsbereichag_delete
    INSTEAD OF DELETE 
    ON {ext_schema}.versickerungsbereichag
    FOR EACH ROW
    EXECUTE FUNCTION {ext_schema}.ft_versickerungsbereichag_delete();

DROP TRIGGER IF EXISTS update_last_modified_agxx_wastewater_networkelement ON tww_od.wastewater_networkelement;		
CREATE TRIGGER update_last_modified_agxx_wastewater_networkelement
    BEFORE INSERT OR UPDATE 
    ON tww_od.wastewater_networkelement
    FOR EACH ROW
    EXECUTE FUNCTION tww_sys.update_last_modified_agxx();

DROP TRIGGER IF EXISTS update_last_modified_agxx_overflow ON tww_od.overflow;		
CREATE TRIGGER update_last_modified_agxx_overflow
    BEFORE INSERT OR UPDATE 
    ON tww_od.overflow
    FOR EACH ROW
    EXECUTE FUNCTION tww_sys.update_last_modified_agxx();