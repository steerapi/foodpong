// Generated by CoffeeScript 1.3.3
var ConfirmDiscountCtrl, ConfirmPerkCtrl, DiscountCtrl, FirstCtrl, FlashSaleCtrl, FoodPong, IndexCtrl, LoginCtrl, ManageOrdersCtrl, ManageSubscriptionsCtrl, NowLaterCtrl, PerkCtrl, PerkDiscountCtrl, SelectItemCtrl, SelectionCtrl, SettingsCtrl, SignupCtrl, ViewDemandCtrl, createNewUser, dateTimeConverter, listRestaurants, login, logout, r, rManage, randomUUID, timeConverter;

Usergrid.ApiClient.init('steerapi', 'sandbox');

FoodPong = {};

FoodPong.promise = null;

FoodPong.timeleft = 0;

r = Raphael("holder");

rManage = Raphael("manageHolder");

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

ConfirmPerkCtrl = function($scope) {};

ConfirmDiscountCtrl = function($scope) {};

ManageOrdersCtrl = function($scope) {
  $scope.plotManage = function() {
    var chart, data1, fclick, fmousemove, index, lock, newx, prevy, x;
    data1 = [[15, 20, 33, 32, 15, 1, 22, 14]];
    index = 0;
    prevy = 0;
    lock = false;
    fclick = function(e) {
      var x;
      x = e.srcElement.getBBox().x;
      prevy = e.y;
      index = parseInt(x / 36);
      return lock = !lock;
    };
    x = function(e) {
      var chart2;
      data1[0][index] += e.y - prevy;
      chart2 = r.barchart(10, 10, 300, 220, data1);
      $.each(chart.bars[0], function(k, v) {
        var newpath;
        newpath = chart2.bars[0][k].attr("path");
        v.animate({
          path: newpath
        }, 1000);
        return v.value = data1[0][k];
      });
      return chart2.remove();
    };
    newx = _.throttle(x, 100);
    fmousemove = function(e) {
      if (lock) {
        return newx(e);
      }
    };
    rManage.clear();
    chart = rManage.barchart(10, 10, 300, 220, data1);
    chart.mousemove(fmousemove);
    return chart.click(fclick);
  };
  return $scope.plotManage();
};

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

ViewDemandCtrl = function($scope) {
  $scope.plotDemand = function() {
    var c, data1, i, p, _i, _j, _results;
    data1 = [[]];
    for (i = _i = 0; _i <= 29; i = ++_i) {
      p = Math.random() * 50;
      data1[0].push(p);
    }
    r.clear();
    return c = r.linechart(10, 10, 300, 220, (function() {
      _results = [];
      for (_j = 0; _j <= 29; _j++){ _results.push(_j); }
      return _results;
    }).apply(this), data1);
  };
  return $scope.plotDemand();
};

FlashSaleCtrl = function($scope) {};

NowLaterCtrl = function($scope) {};

SelectItemCtrl = function($scope) {};

SelectionCtrl = function($scope) {
  $("#buying_slider_min").change(function() {
    var max, min;
    min = parseInt($(this).val());
    max = parseInt($("#buying_slider_max").val());
    if (min > max) {
      $("#buying_slider_max").val(min);
      $("#buying_slider_max").slider("refresh");
      return $(this).slider("refresh");
    }
  });
  return $("#buying_slider_max").change(function() {
    var max, min;
    min = parseInt($("#buying_slider_min").val());
    max = parseInt($(this).val());
    if (min > max) {
      $("#buying_slider_min").val(max);
      $(this).slider("refresh");
      return $("#buying_slider_min").slider("refresh");
    }
  });
};

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
