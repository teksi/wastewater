--
-- TODO : Is this comment still relevant :
-- Audited data. Lots of information is available, it's just a matter of how much
-- you really want to record. See:
--
--   http://www.postgresql.org/docs/9.1/static/functions-info.html
--
-- Remember, every column you add takes up more audit table space and slows audit
-- inserts.
--
-- Every index you add has a big impact too, so avoid adding indexes to the
-- audit table unless you REALLY need them. The hstore GIST indexes are
-- particularly expensive.
--
-- It is sometimes worth copying the audit table, or a coarse subset of it that
-- you're interested in, into a temporary table where you CREATE any useful
-- indexes and do your analysis.
--


DROP TABLE IF EXISTS tww_sys.logged_actions;

CREATE TABLE tww_sys.logged_actions (
    event_id bigserial PRIMARY KEY,
    schema_name text NOT NULL,
    table_name text NOT NULL,
    relid oid NOT NULL,
    session_user_name text,
    action_tstamp_tx TIMESTAMP WITH TIME ZONE NOT NULL,
    action_tstamp_stm TIMESTAMP WITH TIME ZONE NOT NULL,
    action_tstamp_clk TIMESTAMP WITH TIME ZONE NOT NULL,
    transaction_id bigint,
    application_name text,
    client_addr inet,
    client_port integer,
    client_query text NOT NULL,
    action TEXT NOT NULL CHECK (action IN ('I','D','U','T')),
    row_data hstore,
    changed_fields hstore,
    statement_only BOOLEAN NOT NULL
);

REVOKE ALL ON tww_sys.logged_actions FROM public;

COMMENT ON TABLE tww_sys.logged_actions IS 'History of auditable actions on audited tables, from tww_sys.if_modified_func()';
COMMENT ON COLUMN tww_sys.logged_actions.event_id IS 'Unique identifier for each auditable event';
COMMENT ON COLUMN tww_sys.logged_actions.schema_name IS 'Database schema audited table for this event is in';
COMMENT ON COLUMN tww_sys.logged_actions.table_name IS 'Non-schema-qualified table name of table event occured in';
COMMENT ON COLUMN tww_sys.logged_actions.relid IS 'Table OID. Changes with drop/create. Get with ''tablename''::regclass';
COMMENT ON COLUMN tww_sys.logged_actions.session_user_name IS 'Login / session user whose statement caused the audited event';
COMMENT ON COLUMN tww_sys.logged_actions.action_tstamp_tx IS 'Transaction start timestamp for tx in which audited event occurred';
COMMENT ON COLUMN tww_sys.logged_actions.action_tstamp_stm IS 'Statement start timestamp for tx in which audited event occurred';
COMMENT ON COLUMN tww_sys.logged_actions.action_tstamp_clk IS 'Wall clock time at which audited event''s trigger call occurred';
COMMENT ON COLUMN tww_sys.logged_actions.transaction_id IS 'Identifier of transaction that made the change. May wrap, but unique paired with action_tstamp_tx.';
COMMENT ON COLUMN tww_sys.logged_actions.client_addr IS 'IP address of client that issued query. Null for unix domain socket.';
COMMENT ON COLUMN tww_sys.logged_actions.client_port IS 'Remote peer IP port address of client that issued query. Undefined for unix socket.';
COMMENT ON COLUMN tww_sys.logged_actions.client_query IS 'Top-level query that caused this auditable event. May be more than one statement.';
COMMENT ON COLUMN tww_sys.logged_actions.application_name IS 'Application name set when this audit event occurred. Can be changed in-session by client.';
COMMENT ON COLUMN tww_sys.logged_actions.action IS 'Action type; I = insert, D = delete, U = update, T = truncate';
COMMENT ON COLUMN tww_sys.logged_actions.row_data IS 'Record value. Null for statement-level trigger. For INSERT this is the new tuple. For DELETE and UPDATE it is the old tuple.';
COMMENT ON COLUMN tww_sys.logged_actions.changed_fields IS 'New values of fields changed by UPDATE. Null except for row-level UPDATE events.';
COMMENT ON COLUMN tww_sys.logged_actions.statement_only IS '''t'' if audit event is from an FOR EACH STATEMENT trigger, ''f'' for FOR EACH ROW';

CREATE INDEX logged_actions_relid_idx ON tww_sys.logged_actions(relid);
CREATE INDEX logged_actions_action_tstamp_tx_stm_idx ON tww_sys.logged_actions(action_tstamp_stm);
CREATE INDEX logged_actions_action_idx ON tww_sys.logged_actions(action);

CREATE TABLE tww_sys.logged_relations (
    relation_name text not null,
    uid_column text not null,
    PRIMARY KEY (relation_name, uid_column)
);

COMMENT ON TABLE tww_sys.logged_relations IS 'Table used to store unique identifier columns for table or views, so that events can be replayed';
COMMENT ON COLUMN tww_sys.logged_relations.relation_name IS 'Relation (table or view) name (with schema if needed)';
COMMENT ON COLUMN tww_sys.logged_relations.uid_column IS 'Name of a column that is used to uniquely identify a row in the relation';
