angular.module('myApp', ['myApp.filters', 'myApp.services', 'myApp.directives']).
  config ['$routeProvider', ($routeProvider) ->
    $routeProvider.when '/welcome', {
      templateUrl: 'partials/welcome'
      controller: IndexCtrl
    }
    
    $routeProvider.when '/logo', {
      templateUrl: 'partials/logo'
      controller: LogoCtrl  
    }  
    
    $routeProvider.when '/lock', {
      templateUrl: 'partials/lock'
      controller: LockCtrl
    }

    $routeProvider.when '/robot', {
      templateUrl: 'partials/robot'
      controller: RobotCtrl
    }

    $routeProvider.when '/cipher', {
      templateUrl: 'partials/cipher'
      controller: CipherCtrl
    }

    $routeProvider.when '/apply', {
      templateUrl: 'partials/apply'
      controller: ApplyCtrl
    }

    $routeProvider.when '/admin', {
      templateUrl: 'partials/admin'
      controller: AdminCtrl
    }

    $routeProvider.when '/cloud1', {
      templateUrl: 'partials/cloud1'
      controller: cloud1Ctrl
    }

    $routeProvider.otherwise {
      redirectTo: '/welcome'
    }
  ]