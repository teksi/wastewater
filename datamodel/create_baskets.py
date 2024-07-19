#!/usr/bin/env python3

from argparse import ArgumentParser

try:
    import psycopg
except ImportError:
    import psycopg2 as psycopg


def create_od_baskets(pg_service: str):
    conn = psycopg.connect(f"service={pg_service}")
    cursor = conn.cursor()
    cursor.execute(
        """
        SELECT table_name
        FROM information_schema.columns
        WHERE table_schema = 'tww_od'
        GROUP BY table_name
        HAVING SUM(CASE WHEN column_name LIKE 't_basket' THEN 1 ELSE 0 END) = 0;
    """
    )
    tables = cursor.fetchall()
    for tbl in tables:
        cursor.execute(
            f"""
    	ALTER TABLE tww_od.{tablename} ADD COLUMN IF NOT EXISTS t_basket INTEGER,
        CONSTRAINT fkey_od_{tablename}_t_basket FOREIGN KEY (t_basket)
        REFERENCES tww_sys.oid_prefixes (id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE SET NULL;
        """
        )
    conn.commit()
    conn.close()


if __name__ == "__main__":
    parser = ArgumentParser()
    parser.add_argument("-p", "--pg_service", help="postgres service")

    args = parser.parse_args()

    create_od_baskets(
        args.srid,
    )
