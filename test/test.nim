import clientstore

let salt = "fuck"

var count = 1
var status, netAddr: string
clientstore.init("test.db")
echo(clientstore.set_netAddr("356", "x.z.0.1", "abc"))
echo(clientstore.compare_password("356", "abc"))
