from .interlis.utils.various import get_pgconf_as_psycopg_dsn, logger

try:
    import psycopg

    PSYCOPG_VERSION = 3
    DEFAULTS_CONN_ARG = {"autocommit": True}
except ImportError:
    import psycopg2 as psycopg

    PSYCOPG_VERSION = 2
    DEFAULTS_CONN_ARG = {}


def tww_check_oid_prefix(pgservice):
    """Check whether the oid_prefix is set up for production"""
    connection = psycopg.connect(get_pgconf_as_psycopg_dsn(), **DEFAULTS_CONN_ARG)
    if PSYCOPG_VERSION == 2:
        connection.set_session(autocommit=True)
    cursor = connection.cursor()

    logger.info("Checking setup of oid prefix")
    cursor.execute("SELECT prefix FROM tww_sys.oid_prefixes WHERE active;")
    prefixes = cursor.fetchall()
    active_pref = prefixes[0].prefix
    msgtxt = []
    if len(prefixes) > 1:
        msgtxt.append(
            "more than one oid_prefix set to active. Generation of Object-ID will not work"
        )
    if active_pref == "ch000000":
        msgtxt.append("OID prefix set to 'ch000000'. Database not safe for production")

    connection.commit()
    connection.close()
    return msgtxt


def tww_check_fk_defaults(pgservice):
    """Check whether the database is set up for production"""
    connection = psycopg.connect(get_pgconf_as_psycopg_dsn(), **DEFAULTS_CONN_ARG)
    if PSYCOPG_VERSION == 2:
        connection.set_session(autocommit=True)
    cursor = connection.cursor()

    logger.info("Checking setup of default_values")
    cursor.execute("SELECT fieldname,value_obj_id from tww_od.default_values;")
    defaults = [item["fieldname"] for item in cursor.fetchall()]
    vals = [item["value_obj_id"] for item in cursor.fetchall()]
    msgtxt = []
    if None in vals:
        msgtxt.append("There is an undefined default value in tww_od.default_values")
    elif not all(x in defaults for x in ["fk_provider", "fk_dataowner"]):
        msgtxt.append("'fk_provider' or 'fk_dataowner' not set in tww_od.default_values")

    connection.commit()
    connection.close()
    return msgtxt
