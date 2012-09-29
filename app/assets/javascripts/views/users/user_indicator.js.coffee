App.Views.Users ||= {}

class App.Views.Users.UserIndicatorView extends Backbone.View
  
  template: JST["templates/users/indicator"]

  events:
    "click a.inner"     : "selectUser"

  initialize: (options) ->
    {@parent} = options
    _.bindAll @, 'render'

    @setElement @template @parent.model.toJSON()

    @parent.model.todos.bind 'all', @render

  render: =>
    @updateIndicator()

    sub "select_user", => @$el.removeClass 'current'
    sub "select_user_#{@parent.model.id}", => @$el.addClass 'current'

    this

  selectUser: ->
    pub 'select_user', id: @parent.model.id

  updateIndicator: ->
    @$el.css('left', "#{(@parent.model.todos.done().length / 100) * 91.3 + 2.3}%")