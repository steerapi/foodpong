// Generated by CoffeeScript 1.3.3
var ConfirmCtrl, DiscountCtrl, FirstCtrl, FlashSaleCtrl, FoodPong, GraphsCtrl, IndexCtrl, LoginCtrl, ManageOrdersCtrl, ManageSubscriptionsCtrl, NowLaterCtrl, PerkCtrl, PerkDiscountCtrl, SelectionCtrl, SettingsCtrl, SignupCtrl, ViewDemandCtrl, createNewUser, dateTimeConverter, listRestaurants, login, logout, randomUUID, timeConverter;

Usergrid.ApiClient.init('steerapi', 'sandbox');

FoodPong = {};

FoodPong.promise = null;

FoodPong.timeleft = 0;

/*
Function to handle the create new user form submission.

First we make sure there are no errors on the form (in case they
submitted prior and have corrected some data).
Next, we get all the new data out of the form, validate it, then
call the create app user function to send it to the API

@method createNewUser
@return none
*/


login = function(username, password, cb) {
  return Usergrid.ApiClient.logInAppUser(username, password, (function(response, user) {
    var appUser;
    appUser = Usergrid.ApiClient.getLoggedInUser();
    return typeof cb === "function" ? cb(false, appUser) : void 0;
  }), function() {
    return typeof cb === "function" ? cb(true) : void 0;
  });
};

logout = function() {
  return Usergrid.ApiClient.logoutAppUser();
};

createNewUser = function(username, email, password, cb) {
  var appUser;
  if (Usergrid.validation.validateUsername(username, function() {}) && Usergrid.validation.validateEmail(email, function() {}) && Usergrid.validation.validatePassword(password, function() {})) {
    appUser = new Usergrid.Entity("users");
    appUser.set({
      username: username,
      email: email,
      password: password
    });
    return appUser.save((function() {
      return login(username, password, cb);
    }), function() {});
  } else {
    include(first);
    include(confirm);
    include(graphs);
    include(manageorders);
    include(managesubscriptions);
    include(settings);
    include(orders);
    return include(restaurants);
  }
};

listRestaurants = function(cb) {
  var restaurants;
  restaurants = new Usergrid.Collection('restaurants');
  return restaurants.get(function() {
    return cb(restaurants);
  });
};

timeConverter = function(UNIX_timestamp) {
  var a, date, hour, min, month, months, sec, time, year;
  a = new Date(UNIX_timestamp);
  months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
  year = a.getFullYear();
  month = months[a.getMonth()];
  date = a.getDate();
  hour = a.getHours();
  min = a.getMinutes();
  sec = a.getSeconds();
  min = ("0" + min).slice(-2);
  sec = ("0" + sec).slice(-2);
  time = "" + min + ":" + sec;
  return time;
};

dateTimeConverter = function(UNIX_timestamp) {
  var a, date, hour, min, month, months, sec, time, year;
  a = new Date(UNIX_timestamp);
  months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
  year = a.getFullYear();
  month = months[a.getMonth()];
  date = a.getDate();
  hour = a.getHours();
  min = a.getMinutes();
  sec = a.getSeconds();
  hour = ("0" + hour).slice(-2);
  min = ("0" + min).slice(-2);
  sec = ("0" + sec).slice(-2);
  time = "" + month + " " + date + ", " + year + " " + hour + ":" + min + ":" + sec;
  return time;
};

randomUUID = function() {
  var i, itoh, s;
  s = [];
  itoh = "0123456789ABCDEF";
  i = 0;
  while (i < 36) {
    s[i] = Math.floor(Math.random() * 0x10);
    i++;
  }
  s[14] = 4;
  s[19] = (s[19] & 0x3) | 0x8;
  i = 0;
  while (i < 36) {
    s[i] = itoh[s[i]];
    i++;
  }
  s[8] = s[13] = s[18] = s[23] = "-";
  return s.join("");
};

IndexCtrl = function($scope) {
  $scope.currentRestaurant = null;
  $scope.currentOrder = 0;
  $scope.currentOrderAvailable = false;
  return $scope.timeleftStr = "";
};

FirstCtrl = function($scope) {
  $scope.username = "";
  $scope.isLoggedIn = function() {
    var user;
    user = Usergrid.ApiClient.getLoggedInUser();
    if (user) {
      $scope.username = user.get("username");
      return true;
    } else {
      return false;
    }
  };
  return $scope.logout = function() {
    return logout();
  };
};

ConfirmCtrl = function($scope) {
  return $scope.subscribe = function() {
    return $scope.$parent.currentOrder;
  };
};

GraphsCtrl = function($scope) {};

ManageOrdersCtrl = function($scope) {};

ManageSubscriptionsCtrl = function($scope) {};

SettingsCtrl = function($scope) {
  $scope.email = "";
  return $scope.update = function() {
    var user;
    user = Usergrid.ApiClient.getLoggedInUser();
    user.set("email", email);
    return user.save();
  };
};

ViewDemandCtrl = function($scope) {};

FlashSaleCtrl = function($scope) {};

NowLaterCtrl = function($scope) {};

SelectionCtrl = function($scope) {};

PerkCtrl = function($scope) {};

DiscountCtrl = function($scope) {};

PerkDiscountCtrl = function($scope) {};

LoginCtrl = function($scope) {
  $scope.username = "";
  $scope.password = "";
  return $scope.login = function() {
    return login($scope.username, $scope.password, function(err, user) {
      if (!err) {
        history.back();
        return localStorage.setItem("username", user.get("username"));
      }
    });
  };
};

SignupCtrl = function($scope) {
  $scope.username = "";
  $scope.email = "";
  $scope.password = "";
  return $scope.signup = function() {
    return createNewUser($scope.username, $scope.email, $scope.password, function(err, user) {
      if (!err) {
        history.back();
        return localStorage.setItem("username", user.get("username"));
      }
    });
  };
};
