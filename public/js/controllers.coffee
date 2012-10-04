@LogoCtrl = ($scope, $http, $location) ->
  $scope.logos = [
    'image/1.png'
    'image/2.png'
    'image/3.png'
    'image/4.png'
    'image/5.png'
  ]
  $scope.prods = 'image/logo.png'
  $scope.slots = [
    'emma'
    'wisdom'
    'alert'
    'usher'
  ]
  $scope.rel = (-1 for i in [0..3])

  $scope.validate = () ->
    $http.post '/api/checkAnswer/logo', 
      ans: $scope.rel
    .success (data) ->
      token = data.token
      if token isnt 0 and token isnt -1
        $scope.$parent.tokens['logo'] = data.token
        $location.url '/lock'
      else $scope.token = token
    .error (data) ->
      $scope.token = -1

@LockCtrl = ($scope, $http, $location) ->
  $scope.android = 'image/android.png'
  $scope.iphone = 'image/iphone.png'

  $scope.validate = () ->
    $http.post '/api/checkAnswer/lock',
      token: $scope.$parent.tokens['logo']
      ans: [Number($scope.androidComb), Number($scope.iphoneComb)]
    .success (data) ->
      token = data.token
      if token isnt 0 and token isnt -1
        $scope.$parent.tokens['lock'] = data.token
        $location.url '/robot'
      else $scope.token = token
    .error (data) ->
      $scope.token = -1

@RobotCtrl = ($scope, $http, $location, $route) ->
  $scope.numbers = [1..9]
  $scope.state = (0 for i in [0..9])
  $scope.moves = []

  $scope.refresh = () ->
    $route.reload()
  $scope.validate = () ->
    $http.post '/api/checkAnswer/robot',
      token: $scope.$parent.tokens['lock']
      ans: 
        moves: $scope.moves
        state: $scope.state
    .success (data) ->
      token = data.token
      if token isnt 0 and token isnt -1
        $scope.$parent.tokens['robot'] = data.token
        $location.url '/cipher'
      else $scope.token = token
    .error (data) ->
      $scope.token = -1
    
@CipherCtrl = ($scope, $http, $location) ->
  $scope.chart = [
    ['R', 'R', 'R', 'R', 'R', 'R', 'D', 'D'] #M
    ['R', 'R', 'R', 'R', 'R', 'R', 'R', 'R'] #O
    ['R', 'R', 'R', 'R', 'D', 'D'] #B
    ['R', 'R', 'R', 'R', 'R', 'R', 'R'] #I
    ['R', 'R', 'R', 'R', 'R', 'R', 'R', 'R', 'D'] #L
    ['D', 'R', 'R', 'R', 'U', 'L'] #E
    ['D', 'D', 'R', 'R', 'U', 'L', 'U'] #W
    ['R', 'R', 'R', 'L', 'D', 'L', 'L'] #A
    ['D', 'D', 'R', 'R', 'R'] #V
    ['D', 'R', 'R', 'R', 'U', 'L'] #E
  ]

  $scope.validate = () ->
    $http.post '/api/checkAnswer/cipher',
      token: $scope.$parent.tokens['robot'] 
      ans: $scope.cipher
    .success (data) ->
      token = data.token
      if token isnt 0 and token isnt -1
        $scope.$parent.tokens['cipher'] = data.token
        $location.url '/apply'
      else $scope.token = token
    .error (data) ->
      $scope.token = -1

@ApplyCtrl = ($scope, $http, $location) ->
  $scope.mstrApply = () ->
    $http.post '/api/Apply/'+$scope.applyID,
      token: $scope.$parent.tokens['cipher']
    .success (data) ->
      token = data.token
      if token isnt -1
        #$scope.$parent.tokens['apply'] = data.token
        $scope.$parent.tokens = {}
        $location.url '/cloud1'
      else $scope.token = token
    .error (data) ->
      $scope.token = -1

@Cloud1Ctrl = ($scope, $http) ->
  $scope.ans = ('' for v in [0..3])
  $scope.ans[3] = {}
  $scope.validate = () ->
    $http.post '/api/cloudAnswer/1'
      ans: $scope.ans
      applyID: $scope.applyID
    .success (data) ->
      $scope.msg = data.msg
    .error (data) ->
      $scope.msg = data.msg

@AdminCtrl = ($scope, $http, $location) ->
  quiz = ['cloud quiz one', 'cloud quiz two']
  questions = [
    [1,2,3,4]
    [1,2,3,4]
  ]

  $http 
    method: 'GET'
    url: '/api/persons/'
  .success (data) ->
    $scope.persons = data.persons
    for person, i in $scope.persons
      if person.rounds&(1<<1)
        person.scores = ((if person.points[1]&(1<<(i+1)) then 1 else 0) for v, i in questions[0])
      else 
        person.scores = (0 for v in questions[0])

@IndexCtrl = () ->

@AppCtrl = ($scope) ->
  $scope.tokens = {}

@LogoCtrl.$inject = ['$scope', '$http', '$location']
@LockCtrl.$inject = ['$scope', '$http', '$location']
@RobotCtrl.$inject = ['$scope', '$http', '$location', '$route']
@CipherCtrl.$inject = ['$scope', '$http', '$location']
@ApplyCtrl.$inject = ['$scope', '$http', '$location']
@Cloud1Ctrl.$inject = ['$scope', '$http']
@AdminCtrl.$inject = ['$scope', '$http', '$location']
@AppCtrl.$inject = ['$scope']