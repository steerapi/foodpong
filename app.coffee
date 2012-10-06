load "vertx.js"

vertx.deployModule "vertx.web-server-v1.0",
  web_root:"web-customer"
  port: 8080
  bridge: true
  inbound_permitted: [{}]
  outbound_permitted: [{}]

vertx.deployModule "vertx.web-server-v1.0",
  web_root:"web-merchant"
  port: 8081
  bridge: true
  inbound_permitted: [{}]
  outbound_permitted: [{}]
