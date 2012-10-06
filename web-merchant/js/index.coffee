Usergrid.ApiClient.init('steerapi', 'sandbox');

# Global variables
FoodPong = {}
FoodPong.promise = null
FoodPong.timeleft = 0

# Init Raphael
r = Raphael("holder")
rManage = Raphael("manageHolder")

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

ConfirmPerkCtrl = ($scope)->

ConfirmDiscountCtrl = ($scope)->

ManageOrdersCtrl = ($scope)->

  $scope.plotManage = -> 
    data1 = [[15, 20, 33, 32, 15, 1, 22, 14]]
    index = 0
    prevy = 0
    lock = false
    fclick = (e) ->
      x = e.srcElement.getBBox().x
      prevy = e.y
      index = parseInt(x/36)
      lock = !lock
    x = (e)->
      # console.log("move",e.x)
      data1[0][index] += e.y-prevy
      chart2 = r.barchart(10, 10, 300, 220, data1)
      $.each chart.bars[0], (k, v) ->
        # console.log v
        # console.log [k, v, v.value[0]]
        newpath = chart2.bars[0][k].attr("path")
        v.animate
          path: newpath
        , 1000
        v.value = data1[0][k]
      chart2.remove()
    newx = _.throttle(x,100)
    fmousemove = (e) ->
      if lock
        newx(e)

    rManage.clear()
    chart=rManage.barchart(10, 10, 300, 220, data1)
    chart.mousemove(fmousemove);
    chart.click(fclick);
  $scope.plotManage()

ManageSubscriptionsCtrl = ($scope)->

SettingsCtrl = ($scope)->
  $scope.email = ""
  $scope.update = ->
    user = Usergrid.ApiClient.getLoggedInUser()
    user.set("email", email)
    user.save()

ViewDemandCtrl = ($scope)->
  $scope.plotDemand = -> 
  
    data1 = [[]]
    for i in [0..29]
      p = Math.random()*50
      data1[0].push p
    r.clear()
    c=r.linechart(10, 10, 300, 220, [0..29], data1)
  $scope.plotDemand()

FlashSaleCtrl = ($scope)->
NowLaterCtrl = ($scope)->
SelectItemCtrl = ($scope)->
SelectionCtrl = ($scope)->
  $("#buying_slider_min").change ->
    min = parseInt($(this).val())
    max = parseInt($("#buying_slider_max").val())
    if min > max
      #$(this).val(max);
      $("#buying_slider_max").val min
      $("#buying_slider_max").slider "refresh"
      $(this).slider "refresh"
  $("#buying_slider_max").change ->
    min = parseInt($("#buying_slider_min").val())
    max = parseInt($(this).val())
    if min > max
      $("#buying_slider_min").val max
      #$(this).val(min);
      $(this).slider "refresh"
      $("#buying_slider_min").slider "refresh"

PerkCtrl = ($scope)->
DiscountCtrl = ($scope)->
PerkDiscountCtrl = ($scope)->

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

    