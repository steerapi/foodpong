load "vertx.js"
eb = vertx.eventBus
pa = "vertx.mongopersistor"

# Static dev data
mongo = require "./mongo.js"
vertx.deployModule "vertx.mongo-persistor-v1.0", mongo.config, 1, ->
  eb.send pa,
    action: "delete"
    collection: "users"
    matcher:
      username: "dev"

  eb.send pa,
    action: "save"
    collection: "users"
    document:
      worn: []
      pictures: []
      agegroup: ""
      address:
        zip: ""
        city: ""
        state: ""
        country: ""

      firstname: ""
      lastname: ""
      email: "dev@easydressup.com"
      username: "dev"
      password: "ef260e9aa3c673af240d17a2660480361a8e081d1ffeca2a5ed0e3219fc18567" #dev
      categories: []
      closet: {}

  eb.send pa,
    action : 'delete'
    collection : 'stylists'
    matcher : 
      username: "dev"

  # eb.send pa,
  #   action: "find"
  #   collection: "stylists"
  #   matcher: {}
  # , (reply) ->
  #   if reply.status is "ok"
  #     if not reply.result or reply.result.length is 0

  eb.send pa,
    action: "save"
    collection: "stylists"
    document:
      firstname: ""
      lastname: ""
      email: "dev@easydressup.com"
      username: "dev"
      password: "ef260e9aa3c673af240d17a2660480361a8e081d1ffeca2a5ed0e3219fc18567" #dev
      outfit: {}

  # outfit:
  #   collection:
  #     style:
  #       category:
  #         "image":
  #         "pgm":
  #         "clft":
  #         "slft":

  eb.send pa,
    action : 'delete'
    collection : 'users.outfitscores'
    matcher : 
      username: "dev"

  # eb.send pa,
  #   action: "save"
  #   collection: "users.outfitscores"
  #   document:
      # score: {}
      # user: vertx.env.EASYDRESSUP_ENV or "dev"
      # stylist: vertx.env.EASYDRESSUP_ENV or "dev"
      # collection: "summer-2012"
      # style: "Party"

  # eb.send pa,
  #   action: "find"
  #   collection: "users.outfitscores"
  #   matcher: {}
  # , (reply) ->
  #   if reply.status is "ok"
  #     if not reply.result or reply.result.length is 0
  #       eb.send pa,
  #         action: "save"
  #         collection: "users.outfitscores"
  #         document:
  #           score: {}
            #   "at":
            #     "bt":0.4
            #   "ab":
            #     "bb":0.5
            # user: vertx.env.EASYDRESSUP_ENV or "dev"
            # stylist: "stylist"
            # collection: "summer-2012"
            # style: "party"

  eb.send pa,
    action : 'delete'
    collection : 'configs'
    matcher : 
      username: vertx.env.EASYDRESSUP_VER or "1"

  eb.send pa,
    action: "save"
    collection: "configs"
    document:
      _id: vertx.env.EASYDRESSUP_VER or "1"
      categories: ["Shirts","Tops","Skirts","Pants","Shorts","Dresses","Jackets","Sweaters","Shoes","Scarfs","Bags","Others"]
      collections: ["Fall-2012"]
      styles: ["Casual", "Flirty", "Sporty", "Party", "Formal"]
      fileTypes: ["csift","image"]

