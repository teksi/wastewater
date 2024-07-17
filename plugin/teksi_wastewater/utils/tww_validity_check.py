from .database_utils import DatabaseUtils
from .plugin_utils import logger


def tww_check_oid_prefix():
    """Check whether the oid_prefix is set up for production"""
    with DatabaseUtils.PsycopgConnection() as connection:
        cursor = connection.cursor()

        logger.info("Checking setup of oid prefix")
        cursor.execute("SELECT prefix FROM tww_sys.oid_prefixes WHERE active;")
        prefixes = cursor.fetchall()
        msgtxt = []
        if len(prefixes) > 1:
            msgtxt.append(
                "more than one oid_prefix set to active. Generation of Object-ID will not work. Set the OID prefix for your production database to active."
            )

        if len(prefixes) > 0:
            active_pref = prefixes[0][0]
            if active_pref == "ch000000":
                msgtxt.append("OID prefix set to 'ch000000'. Database not safe for production")

        return msgtxt


def tww_check_fk_defaults():
    """Check whether the database is set up for production"""
    with DatabaseUtils.PsycopgConnection() as connection:
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

        return msgtxt
