import datastore_api, client, tables, protocol,
       encryption

var clients = tables.initTable[string, ClientEntity]()
var datastore: Datastore

type
  Result = tuple
    status: string
    netAddr: string
    
proc get_netAddr_from_datastore(id: string): Result =
  let res = client.read(datastore, id)
  if res.status == "ok":
    clients.add(id, res.client)
    echo("Datastore access")
    result = (res.status, res.client.netAddr)
  else:
    result.status = "error"
    
proc get_netAddr(id: string): Result =
  if tables.hasKey(clients, id):
    echo("Cache access")
    result = ("ok", clients[id].netAddr)
  else:
    result = get_netAddr_from_datastore(id)

proc get_password(id: string): (string, string) =
  let res = client.read(datastore, id)
  if res.status == "ok":
    result = ("ok", res.client.password)
  else:
    result = ("error", "Client not in database!")

proc update_netAddr(id: string, netAddr: string): Result =
  var cr = client.read(datastore, id)
  if cr.status == "ok":
    if cr.client.netAddr != netAddr:
      cr.client.netAddr = netAddr
      echo("Update client")
      client.update(datastore, cr.client)
      clients.add(id, cr.client)
      result = ("ok", "do update")
    else:
      result = ("ok", "not update")
  else:
    result = ("error", "do update")

proc compare_password*(id: string, password: string): bool =
  var (res, pw) = get_password(id)
  if res == "ok":
    result = encryption.compare(password, pw)
  else:
    echo("No database entity")
    result = false
    
### if entity not available create new one and update
proc set_netAddr*(id: string, password: string, netAddr: string): Result =
  var (status, msg) = update_netAddr(id, netAddr)
  if status == "error":
    let hash = encryption.get_hash(password)
    let cl = ClientEntity(id: id, netAddr: netAddr, password: hash)
    echo("Create new client")
    client.create(datastore, cl)
    clients.add(id, cl)
  result = ("ok", msg)

proc init*(name: string) =
  datastore = datastore_api.open_ds(name)
  datastore_api.setup_ds(datastore)


