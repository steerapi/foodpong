// Generated by CoffeeScript 1.3.3
var eb, mongo, pa;

load("vertx.js");

eb = vertx.eventBus;

pa = "vertx.mongopersistor";

mongo = require("./mongo.js");

vertx.deployModule("vertx.mongo-persistor-v1.0", mongo.config, 1, function() {
  eb.send(pa, {
    action: "delete",
    collection: "users",
    matcher: {
      username: "dev"
    }
  });
  eb.send(pa, {
    action: "save",
    collection: "users",
    document: {
      worn: [],
      pictures: [],
      agegroup: "",
      address: {
        zip: "",
        city: "",
        state: "",
        country: ""
      },
      firstname: "",
      lastname: "",
      email: "dev@easydressup.com",
      username: "dev",
      password: "ef260e9aa3c673af240d17a2660480361a8e081d1ffeca2a5ed0e3219fc18567",
      categories: [],
      closet: {}
    }
  });
  eb.send(pa, {
    action: 'delete',
    collection: 'stylists',
    matcher: {
      username: "dev"
    }
  });
  eb.send(pa, {
    action: "save",
    collection: "stylists",
    document: {
      firstname: "",
      lastname: "",
      email: "dev@easydressup.com",
      username: "dev",
      password: "ef260e9aa3c673af240d17a2660480361a8e081d1ffeca2a5ed0e3219fc18567",
      outfit: {}
    }
  });
  eb.send(pa, {
    action: 'delete',
    collection: 'users.outfitscores',
    matcher: {
      username: "dev"
    }
  });
  eb.send(pa, {
    action: 'delete',
    collection: 'configs',
    matcher: {
      username: vertx.env.EASYDRESSUP_VER || "1"
    }
  });
  return eb.send(pa, {
    action: "save",
    collection: "configs",
    document: {
      _id: vertx.env.EASYDRESSUP_VER || "1",
      categories: ["Shirts", "Tops", "Skirts", "Pants", "Shorts", "Dresses", "Jackets", "Sweaters", "Shoes", "Scarfs", "Bags", "Others"],
      collections: ["Fall-2012"],
      styles: ["Casual", "Flirty", "Sporty", "Party", "Formal"],
      fileTypes: ["csift", "image"]
    }
  });
});
