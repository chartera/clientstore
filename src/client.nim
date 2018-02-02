import datastore_api, protocol

proc `$`(client: ClientEntity): string =
  $client.id & "(" & client.netAddr & ")"

proc create*(datastore: Datastore, client: ClientEntity): void =
  datastore_api.exec(datastore.ds, "INSERT INTO Client VALUES (?, ?, ?);",
                    [client.id, client.netAddr, client.password])

proc read*(datastore: Datastore, id: string): ClientResult =
  let row =
    datastore_api.getRow(datastore.ds,
      "SELECT id, netAddr, password FROM Client WHERE id = ?;", [id])
  new result
  if row[0].len != 0:
    result.status = "ok"
    result.client = ClientEntity(
      id: row[0],  netAddr: row[1],
      password: row[2])
  else:
    result.status = "error"

proc update*(datastore: Datastore, client: ClientEntity): void =
  exec(datastore.ds, "UPDATE Client SET netAddr = ? WHERE id = ?;",
    [client.netAddr, client.id])
  

