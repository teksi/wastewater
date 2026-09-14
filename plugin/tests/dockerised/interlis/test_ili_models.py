from teksi_wastewater.interlis.model_selection import (
    groups_for_models,
    interlis_models,
)


def test_groups_for_dss_model() -> None:
    assert groups_for_models(
        "DSS_2020_1_LV95",
    ) == {
        "dss",
    }


def test_groups_for_ag64_model() -> None:
    assert groups_for_models(
        "Abwasserkataster_AG_V2_LV95",
    ) == {
        "ag64",
    }


def test_groups_for_ag96_model() -> None:
    assert groups_for_models(
        "Genereller_Entwaesserungsplan_AG",
    ) == {
        "ag96",
    }


def test_groups_for_multiple_models() -> None:
    assert groups_for_models(
        {
            "DSS_2020_1_LV95",
            "Abwasserkataster_AG_V2_LV95",
        }
    ) == {
        "dss",
        "ag64",
    }


def test_groups_for_unknown_model() -> None:
    assert groups_for_models(
        "does_not_exist",
    ) == set()


def test_interlis_model_names_property() -> None:
    dss = interlis_models["dss"]

    assert "DSS_2020_1_LV95" in dss.names
    assert "SDEE_2020_1_LV95" in dss.names


def test_interlis_model_topics_property() -> None:
    dss = interlis_models["dss"]

    assert "Siedlungsentwaesserung" in dss.topics
    assert (
        "evacuation_des_eaux_des_agglomerations"
        in dss.topics
    )


def test_interlis_model_language_lookup() -> None:
    dss = interlis_models["dss"]

    assert (
        dss.lang_name("de")
        == "DSS_2020_1_LV95"
    )

    assert (
        dss.lang_name("fr")
        == "SDEE_2020_1_LV95"
    )