#= require jquery
#= require json2
#= require hamlcoffee
#= require underscore
#= require backbone
#= require_tree ./lib
#= require_self
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./collections
#= require_tree ./views

window.App =
  Models: {}
  Collections: {}
  Views: {}

$ ->

  # Add CSRF token to jQuery ajax
  $.ajaxSetup headers: 'X-CSRF-Token': $('meta[name="csrf-token"]').attr 'content'

  # Our overall **AppView** is the top-level piece of UI.
  class AppView extends Backbone.View

    # Instead of generating a new element, bind to the existing skeleton of
    # the App already present in the HTML.
    el: $ '#todos'

    events:
      "keypress #new-todo"        : "createOnEnter"
      "click .user-switch-right"  : "switchNextUser"
      "click .user-switch-left"  : "switchPreviousUser"

    initialize: ->
      _.bindAll @, 'addOne', 'addAll', 'render'

      @users = new window.App.Collections.Users

      @users.bind 'add',   @addOne
      @users.bind 'reset', @addAll
      @users.bind 'reset', @render

      @users.fetch()

    render: ->
      @currentUser = @users.at(0) unless @currentUser?
      @switchToCurrentUser()
      @input = @$ '#new-todo'

      this

    # Generate the attributes for a new Todo item.
    newAttributes: (user) ->
      content:  @input.val()
      order:    0
      done:     false
      user_id:  user.id

    # If you hit return in the main input field, create new **Todo** model
    createOnEnter: (e)->
      if e.keyCode == 13
        @currentUser.todos.create @newAttributes(@currentUser)
        @input.val ''

    switchNextUser: (e) ->
      @currentUser = @users.at (@users.indexOf(@currentUser) + 1) % @users.length
      @switchToCurrentUser()

    switchPreviousUser: (e) ->
      @currentUser = @users.at ((if @users.indexOf(@currentUser) > 0 then @users.indexOf(@currentUser) else @users.length) - 1) % @users.length
      @switchToCurrentUser()

    switchToCurrentUser: =>
      pub 'select_user', id: @currentUser.id

    # switchToUser: (user) ->

    #   @$('#lists-container .user-list-container').removeClass 'current'
    #   user.get('view').$el.addClass 'current'
        

    userPicTemplate: JST["templates/users/user_pic"]

    addOne: (user, i) ->
      view = new window.App.Views.Users.UserView model: user
      @$('#lists-container').append view.render().el
      @$('#user-select .pic-frame').append @userPicTemplate user.toJSON()
      @users.at(i).set('view', view)
      @bindUserPicSwitch user

    bindUserPicSwitch: (user) ->
      sub "select_user", => @$('#user-select .user-pic').removeClass 'current'
      sub "select_user_#{user.id}", => @$("#user-select #user-pic-#{user.id}").addClass 'current'

    # Add all items in the **Users** collection at once.
    addAll: ->
      @users.each @addOne

  # Finally, we kick things off by creating the **App**.
  App = new AppView
