# Definitions for tww datamodel with delta >= 1.7.0
# supposed usage: add TEKSI2AG64_96 into the plugin folder of TEKSI wastewater. 

from functools import lru_cache
from sqlalchemy.orm import Session
from sqlalchemy.sql import text

from .. import config,utils 
import os

# create_tww_app.py is at wastewater/datamodel/app/create_tww_app.py
from datamodel.app import create_tww_app

def tww_initialize(pgservice=config.TWW_DEFAULT_PGSERVICE, oid_definition=(), oid_dataowner: str ='ch20p3q4000094', db_identifier: str=None):
    """
    initializes the TWW database for usage of the AG64/96 models.

    Args:
        pgservice: pg service string
        oid_definition: tuple (prefix, organization) to update oid prefix
        
    """

    init_session = Session(utils.sqlalchemy.create_engine(), autocommit=False, autoflush=False)

    # First we check if the extension schema already exists
    schema_exists = init_session.execute(
        "SELECT schema_name FROM information_schema.schemata WHERE schema_name = %;".format(config.TWW_SCHEMA)
    )
    # We also disable symbology triggers as they badly affect performance. This must be done in a separate session as it
    # would deadlock other sessions.
    init_session.execute("SELECT tww_sys.disable_symbology_triggers();")
    init_session.commit()
    init_session.flush()
    
    # We also disable symbology triggers as they badly affect performance. This must be done in a separate session as it
    # would deadlock other sessions.
    if oid_definition:
        init_session.execute("UPDATE tww_sys.oid_prefixes SET active = False WHERE active;")
        init_session.execute("INSERT INTO tww_sys.oid_prefixes (prefix, organization,active)VALUES (%,%,True);",oid_definition)
        init_session.commit()
        init_session.flush()
    
    if schema_exists is None:
        directory = 'ag64_96_init'
        files = os.listdir(os.path.join(directory,os.pardir)) 
        files.sort()
        for file in files:
            filename = os.fsdecode(file)
            if filename.endswith(".sql"):
                sql = text(open(os.path.join(directory, filename)).read().format(ext_schema=config.TWW_SCHEMA,
                                                                                 ilischema=config.AG96_SCHEMA,
                                                                                 db_identifier=db_identifier))
                init_session.execute(sql)
                init_session.commit()
                init_session.close()
    del schema_exists
    

    # ------------------------------------------ re-create all views --------------------------------------------------------------------
    create_tww_app(2056,pgservice)


    # re-create symbology triggers 
    post_session = Session(utils.sqlalchemy.create_engine(), autocommit=False, autoflush=False)
    post_session.execute("SELECT tww_sys.enable_symbology_triggers();")
    post_session.commit()
    post_session.close()