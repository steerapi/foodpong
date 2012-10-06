Usergrid.ApiClient.init('steerapi', 'sandbox');

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

# Global Variable Scope
IndexCtrl = ($scope)->
  $scope.currentRestaurant = "xxx"

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
GraphsCtrl = ($scope)->
ManageOrdersCtrl = ($scope)->
ManageSubscriptionsCtrl = ($scope)->

SettingsCtrl = ($scope)->
  $scope.email = ""
  $scope.update = ->
    user = Usergrid.ApiClient.getLoggedInUser()
    user.set("email", email)
    user.save()

OrdersCtrl = ($scope)->
  $scope.checks = {}
  $scope.total = 0
  $scope.calculateTotal = ()->
    total = 0
    for k,v of $scope.checks
      if v
        total+=$scope.$parent.currentRestaurant.menu[k]
    $scope.total = total

RestaurantsCtrl = ($scope)->
  $scope.restaurants = []
  listRestaurants (restaurants)->
    list = restaurants.getEntityList()
    list.sort (e1,e2)->
      a = e1.get("discountpercent")
      b = e2.get("discountpercent")
      return b-a
    list.forEach (item)->
      $scope.restaurants.push item.get()
    # console.log $scope.restaurants
    $scope.$apply()
  $scope.startOrder = (restaurant)->
    $scope.$parent.currentRestaurant = restaurant
    console.log restaurant
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

    