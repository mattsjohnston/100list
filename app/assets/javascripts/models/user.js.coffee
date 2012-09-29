class App.Models.User extends Backbone.Model

  idAttribute: '_id'

  paramRoot: 'user'

  initialize: -> @set 'completed_todos', @completedTodos()

  completedTodos: ->
    @collection.filter (todo)-> todo.get 'done'