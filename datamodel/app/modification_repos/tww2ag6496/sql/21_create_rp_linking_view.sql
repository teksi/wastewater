CREATE OR REPLACE VIEW tww_app.vw_agxx_reach_point AS
SELECT
    rp.uuid,
    rp.fk_reach_point,
    rp.ag64_fk_wastewater_node,

    un.year_of_construction,
    un.structure_condition,
    un.status,
    un.co_level,
    un.detail_geometry3d_geometry,
    un.financing,
    un.ch_function_hierarchic,
    un.status_survey_year,
    un.co_positional_accuracy,
    un.renovation_necessity,
    un.accessibility,
    un.fk_operator,
    un.fk_owner,
    un.ag96_fk_measure,
    un.wwtp_number,
    un.situation3d_geometry,
    un.backflow_level_current,
    un.bottom_level

FROM tww_od.agxx_reach_point rp
LEFT JOIN tww_od.agxx_unconnected_node_bwrel un
       ON un.obj_id = rp.ag64_fk_wastewater_node;

CREATE OR REPLACE FUNCTION tww_app.ft_vw_agxx_reach_point_insert()
RETURNS trigger AS
$$
BEGIN
    -- Create unconnected node if necessary
    IF NEW.ag64_fk_wastewater_node IS NOT NULL THEN

        INSERT INTO tww_od.agxx_unconnected_node_bwrel
        (
            obj_id,
            year_of_construction,
            structure_condition,
            status,
            co_level,
            detail_geometry3d_geometry,
            financing,
            ch_function_hierarchic,
            status_survey_year,
            co_positional_accuracy,
            renovation_necessity,
            accessibility,
            fk_operator,
            fk_owner,
            ag96_fk_measure,
            wwtp_number,
            situation3d_geometry,
            backflow_level_current,
            bottom_level
        )
        VALUES
        (
            NEW.ag64_fk_wastewater_node,
            NEW.year_of_construction,
            NEW.structure_condition,
            NEW.status,
            NEW.co_level,
            NEW.detail_geometry3d_geometry,
            NEW.financing,
            NEW.ch_function_hierarchic,
            NEW.status_survey_year,
            NEW.co_positional_accuracy,
            NEW.renovation_necessity,
            NEW.accessibility,
            NEW.fk_operator,
            NEW.fk_owner,
            NEW.ag96_fk_measure,
            NEW.wwtp_number,
            NEW.situation3d_geometry,
            NEW.backflow_level_current,
            NEW.bottom_level
        )
        ON CONFLICT (obj_id) DO NOTHING;

        INSERT INTO tww_od.agxx_reach_point
        (
            fk_reach_point,
            ag64_fk_wastewater_node
        )
        VALUES
        (
            NEW.fk_reach_point,
            NEW.ag64_fk_wastewater_node
        );

    END IF;

    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION tww_od.ft_v_agxx_reach_point_update()
RETURNS trigger AS
$$
BEGIN

    IF NEW.ag64_fk_wastewater_node IS NOT NULL THEN

        UPDATE tww_od.agxx_reach_point
        SET
            fk_reach_point = NEW.fk_reach_point,
            ag64_fk_wastewater_node = NEW.ag64_fk_wastewater_node
        WHERE ag64_fk_wastewater_node = OLD.ag64_fk_wastewater_node;

        UPDATE tww_od.agxx_unconnected_node_bwrel
        SET
            year_of_construction = NEW.year_of_construction,
            structure_condition = NEW.structure_condition,
            status = NEW.status,
            co_level = NEW.co_level,
            detail_geometry3d_geometry = NEW.detail_geometry3d_geometry,
            financing = NEW.financing,
            ch_function_hierarchic = NEW.ch_function_hierarchic,
            status_survey_year = NEW.status_survey_year,
            co_positional_accuracy = NEW.co_positional_accuracy,
            renovation_necessity = NEW.renovation_necessity,
            accessibility = NEW.accessibility,
            fk_operator = NEW.fk_operator,
            fk_owner = NEW.fk_owner,
            ag96_fk_measure = NEW.ag96_fk_measure,
            wwtp_number = NEW.wwtp_number,
            situation3d_geometry = NEW.situation3d_geometry,
            backflow_level_current = NEW.backflow_level_current,
            bottom_level = NEW.bottom_level
        WHERE obj_id = NEW.ag64_fk_wastewater_node;

    END IF;

    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION tww_app.ft_vw_agxx_reach_point_delete()
RETURNS trigger AS
$$
BEGIN
    DELETE FROM tww_od.agxx_reach_point
    WHERE ag64_fk_wastewater_node = OLD.ag64_fk_wastewater_node;

    DELETE FROM tww_od.agxx_unconnected_node_bwrel un
    WHERE un.obj_id = OLD.ag64_fk_wastewater_node
      AND NOT EXISTS (
            SELECT 1
            FROM tww_od.agxx_reach_point rp
            WHERE rp.ag64_fk_wastewater_node = un.obj_id
      );

    RETURN OLD;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER tr_vw_agxx_reach_point_insert
INSTEAD OF INSERT ON tww_app.vw_agxx_reach_point
FOR EACH ROW
EXECUTE FUNCTION tww_app.ft_vw_agxx_reach_point_insert();

CREATE TRIGGER tr_vw_agxx_reach_point_update
INSTEAD OF UPDATE ON tww_app.vw_agxx_reach_point
FOR EACH ROW
EXECUTE FUNCTION tww_app.ft_vw_agxx_reach_point_update();

CREATE TRIGGER tr_vw_agxx_reach_point_delete
INSTEAD OF DELETE ON tww_app.vw_agxx_reach_point
FOR EACH ROW
EXECUTE FUNCTION tww_app.ft_vw_agxx_reach_point_delete();