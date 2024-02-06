# Definitions for tww datamodel with delta >= 1.7.0
# supposed usage: add TEKSI2AG64_96 into the plugin folder of TEKSI wastewater. 

from functools import lru_cache
from sqlalchemy.orm import Session
from sqlalchemy.sql import text

from .. import config,utils 
import os
# This file is wastewater/plugin/TEKSI2AG64_96/assets/tww_initialize.py
# create_views.py is at wastewater/datamodel/app/view/create_views.py
from ....datamodel.app.view import create_views

def tww_initialize(pgservice=config.TWW_DEFAULT_PGSERVICE):
    """
    initializes the TWW database for usage of the AG64/96 models.

    Args:
        oid_dataowner: object id of the data owner.
    """

    init_session = Session(utils.sqlalchemy.create_engine(), autocommit=False, autoflush=False)

    # First we check if the extension schema already exists
    schema_exists = init_session.execute(
        "SELECT schema_name FROM information_schema.schemata WHERE schema_name = %;".format(config.TWW_SCHEMA)
    )
    if schema_exists is None:
        directory = 'ag64_96_init'
        files = os.listdir(os.path.join(directory,os.pardir)) 
        files.sort()
        for file in files:
            filename = os.fsdecode(file)
            if filename.endswith(".sql"):
                sql = text(open(os.path.join(directory, filename)).read().format(ext_schema=config.TWW_SCHEMA,
                                                                                 ilischema=config.AG96_SCHEMA))
                init_session.execute(sql)
                init_session.commit()
                init_session.flush()
    del schema_exists
    
    # We also drop symbology triggers as they badly affect performance. This must be done in a separate session as it
    # would deadlock other sessions.
    init_session.execute("SELECT tww_sys.disable_symbology_triggers();")
    init_session.commit()
    init_session.close()

    # ------------------------------------------ re-create all views --------------------------------------------------------------------
    create_views(2056,pgservice)


    # re-create symbology triggers 
    post_session = Session(utils.sqlalchemy.create_engine(), autocommit=False, autoflush=False)
    post_session.execute("SELECT tww_sys.enablee_symbology_triggers();")
    post_session.commit()
    post_session.close()