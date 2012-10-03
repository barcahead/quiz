services = angular.module 'myApp.services', []

# services.factory 'socket', ($rootScope) ->
#   socket = io.connect()
#   on: (eventName, callback) ->
#     socket.on eventName, () ->
#       args = arguments
#       $rootScope.$apply () ->
#         callback.apply socket, args
#   emit: (eventName, data, callback) ->
#     socket.emit eventName, data, () ->
#       args = arguments
#       $rootScope.$apply () ->
#         if callback then callback.apply socket, args