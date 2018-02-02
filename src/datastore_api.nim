import db_sqlite, protocol


proc setup_ds*(datastore: Datastore): void =
  datastore.ds.exec(sql"""
  CREATE TABLE IF NOT EXISTS CLIENT(
    id string PRIMARY KEY,
    netAddr string,
    password string
  )""")

proc close_ds*(datastore: Datastore): void =
  datastore.ds.close()

proc open_ds*(name: string): Datastore =
  new result
  result.ds = open(name, "", "", "")

proc exec*(db: DbConn, query: string, args: varargs[string]): proc =
  db_sqlite.exec(db, sql query, args)

proc getRow*(db: DbConn, query: string, args: varargs[string]): Row =
  db_sqlite.getRow(db, sql query, args)
