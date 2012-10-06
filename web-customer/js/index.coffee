Usergrid.ApiClient.init('steerapi', 'sandbox');

# Global variables
FoodPong = {}
FoodPong.promise = null
FoodPong.timeleft = 0

###
Function to handle the create new user form submission.

First we make sure there are no errors on the form (in case they
submitted prior and have corrected some data).
Next, we get all the new data out of the form, validate it, then
call the create app user function to send it to the API

@method createNewUser
@return none
###

login = (username, password ,cb)->
  Usergrid.ApiClient.logInAppUser username, password, ((response, user) ->
    #login succeeded, so get a reference to the newly create user
    appUser = Usergrid.ApiClient.getLoggedInUser()
    #take more action here
    cb?(false,appUser)
  ), ->
    #error login
    cb?(true)

logout = ->
  Usergrid.ApiClient.logoutAppUser()

createNewUser = (username, email, password,cb)->
  if Usergrid.validation.validateUsername(username, ->
  #error username 
  ) and Usergrid.validation.validateEmail(email, ->    
  #error validataion
  ) and Usergrid.validation.validatePassword(password, ->
  #error validataion
  )
    # make sure we have a clean user, and then add the data
    appUser = new Usergrid.Entity("users")
    appUser.set
      username: username
      email: email
      password: password

    appUser.save (->      
      #new user is created, so set their values in the login form and call login
      login(username,password,cb)
    ), ->
      #error create
  else

    #first(data-role='page',data-add-back-btn="true",ng-controller="FirstCtrl")
      include first
    #confirm(data-role='page',data-add-back-btn="true",ng-controller="ConfirmCtrl")
      include confirm
    #graphs(data-role='page',data-add-back-btn="true",ng-controller="GraphsCtrl")
      include graphs
    #manageorders(data-role='page',data-add-back-btn="true",ng-controller="ManageOrdersCtrl")
      include manageorders
    #managesubscriptions(data-role='page',data-add-back-btn="true",ng-controller="ManageSubscriptionsCtrl")
      include managesubscriptions
    #settings(data-role='page',data-add-back-btn="true",ng-controller="SettingsCtrl")
      include settings
    #orders(data-role='page',data-add-back-btn="true",ng-controller="OrdersCtrl")
      include orders
    #restaurants(data-role='page',data-add-back-btn="true",ng-controller="RestaurantsCtrl")
      include restaurants

listRestaurants = (cb)->
  restaurants = new Usergrid.Collection('restaurants')
  restaurants.get ->
    cb(restaurants)

timeConverter = (UNIX_timestamp) ->
  a = new Date(UNIX_timestamp)
  months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
  year = a.getFullYear()
  month = months[a.getMonth()]
  date = a.getDate()
  hour = a.getHours()
  min = a.getMinutes()
  sec = a.getSeconds()
  min = ("0" + min).slice(-2);
  sec = ("0" + sec).slice(-2);
  time = "#{min}:#{sec}"
  time

dateTimeConverter = (UNIX_timestamp) ->
  a = new Date(UNIX_timestamp)
  months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
  year = a.getFullYear()
  month = months[a.getMonth()]
  date = a.getDate()
  hour = a.getHours()
  min = a.getMinutes()
  sec = a.getSeconds()

  hour = ("0" + hour).slice(-2);
  min = ("0" + min).slice(-2);
  sec = ("0" + sec).slice(-2);

  time =  "#{month} #{date}, #{year} #{hour}:#{min}:#{sec}"
  time

randomUUID = ->
  s = []
  itoh = "0123456789ABCDEF"
  
  # Make array of random hex digits. The UUID only has 32 digits in it, but we
  # allocate an extra items to make room for the '-'s we'll be inserting.
  i = 0

  while i < 36
    s[i] = Math.floor(Math.random() * 0x10)
    i++
  
  # Conform to RFC-4122, section 4.4
  s[14] = 4 # Set 4 high bits of time_high field to version
  s[19] = (s[19] & 0x3) | 0x8 # Specify 2 high bits of clock sequence
  
  # Convert to hex chars
  i = 0

  while i < 36
    s[i] = itoh[s[i]]
    i++
  
  # Insert '-'s
  s[8] = s[13] = s[18] = s[23] = "-"
  s.join ""
  
# Global Variable Scope
IndexCtrl = ($scope)->
  $scope.currentRestaurant = null
  $scope.currentOrder = 0
  $scope.currentOrderAvailable = false
  $scope.timeleftStr = ""

FirstCtrl = ($scope)->
  $scope.username = ""
  $scope.isLoggedIn = ->
    user = Usergrid.ApiClient.getLoggedInUser()
    if user
      $scope.username = user.get "username"
      return true
    else
      return false
  $scope.logout = ->
    logout()

ConfirmCtrl = ($scope)->
  $scope.subscribe = ->
    #TODO
    $scope.$parent.currentOrder

GraphsCtrl = ($scope)->
ManageOrdersCtrl = ($scope)->
ManageSubscriptionsCtrl = ($scope)->

SettingsCtrl = ($scope)->
  $scope.email = ""
  $scope.update = ->
    user = Usergrid.ApiClient.getLoggedInUser()
    user.set("email", email)
    user.save()

OrdersCtrl = ($scope,$timeout)->
  $scope.checks = {}
  $scope.total = 0
  $scope.calculateTotal = ()->
    total = 0
    for k,v of $scope.checks
      if v
        total+=$scope.$parent.currentRestaurant.get("menu")[k].price
    $scope.total = total
  $scope.orderNow = ->
    currentOrder = {}
    #Generating unique order number
    currentOrder.number = randomUUID()
    currentOrder.time = new Date().getTime()
    currentOrder.items = {}
    for k,v of $scope.checks
      if v
        currentOrder.items[k] = $scope.$parent.currentRestaurant.get("menu")[k]

    #Store order in both restaurants and users
    #Quick hack. TODO: Actually should create tables for users and subscribers...
    orders = $scope.$parent.currentRestaurant.get("orders")
    if not orders
      $scope.$parent.currentRestaurant.set("orders", [currentOrder])
    else
      orders.push currentOrder
    $scope.$parent.currentRestaurant.set "orders", orders

    user = Usergrid.ApiClient.getLoggedInUser()
    if user
      orders = user.get("orders")
      if not orders
        user.set("orders", [orders])
      else
        orders.push currentOrder
      user.set "orders", orders
    
    #TODO: Ping restaurants of the order via websocket + vertx + push apigee
    $scope.$parent.currentOrder = currentOrder
  
RestaurantsCtrl = ($scope,$timeout)->
  $scope.restaurants = []
  listRestaurants (restaurants)->
    list = restaurants.getEntityList()
    list.sort (e1,e2)->
      a = e1.get("discountpercent")
      b = e2.get("discountpercent")
      return b-a
    list.forEach (item)->
      $scope.restaurants.push item
    # console.log $scope.restaurants
    $scope.$apply()
  $scope.startOrder = (restaurant)->
    $scope.$parent.currentRestaurant = restaurant
    $scope.$parent.currentOrderDateTime = dateTimeConverter((new Date()).getTime())
    $scope.$parent.currentOrderAvailable = true
    
    FoodPong.timeleft = $scope.$parent.currentRestaurant.get("expiration") - (new Date()).getTime()
    
    $timeout.cancel(promise) if promise
    promise = $timeout pulse=->
      console.log FoodPong.timeleft
      FoodPong.timeleft -= 1000
      if FoodPong.timeleft < 0
        $scope.$parent.currentOrderAvailable = false
        $scope.$parent.timeleftStr = "Time's up!"
        return
      $scope.$parent.timeleftStr = timeConverter(FoodPong.timeleft)
      # console.log $scope.$parent.timeleftStr 
      $timeout pulse, 1000
    , 1000
    
    $scope.$apply()

LoginCtrl = ($scope)->
  $scope.username = ""
  $scope.password = ""
  $scope.login = ->
    login $scope.username,$scope.password, (err, user)->
      if not err
        history.back()
        localStorage.setItem "username", user.get "username"
    
SignupCtrl = ($scope)->
  $scope.username = ""
  $scope.email = ""
  $scope.password = ""
  $scope.signup = ->
    createNewUser $scope.username,$scope.email,$scope.password, (err, user)->
      if not err
        history.back()
        localStorage.setItem "username", user.get "username"

    