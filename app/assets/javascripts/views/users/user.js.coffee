App.Views.Users ||= {}

class App.Views.Users.UserView extends Backbone.View

  template: JST["templates/users/list"]

  className: 'user-list-container'

  # Our template for the line of statistics at the bottom of the app.
  statsTemplate: JST["templates/todos/stats"]

  # Delegated events for creating new items, and clearing completed ones.
  events:
    "keyup #new-todo"     : "showTooltip"
    "click .todo-clear a" : "clearCompleted"
    "click .mark-all-done": "toggleAllComplete"

  # At initialization we bind to the relevant events on the `Todos`
  # collection, when items are added or changed. Kick things off by
  # loading any preexisting todos that might be saved.
  initialize: ->
    _.bindAll @, 'addOne', 'addAll', 'render', 'renderStats', 'toggleAllComplete', 'updateIndicator'

    # Create our global collection of **Todos**.
    @model.todos = new window.App.Collections.Todos

    @model.todos.bind 'change', @updateIndicator
    @model.todos.bind 'add',    @addOne
    # @model.todos.bind 'reset',  @render
    @model.todos.bind 'all',  @renderStats
    @model.todos.bind 'reset',  @addAll

    @model.todos.fetch_by_user @model

  # Re-rendering the App just means refreshing the statistics -- the rest
  # of the app doesn't change.
  render: ->
    @$el.html @template @model.toJSON()
    
    @input = @$ '#new-todo'
    @allCheckbox = @$('.mark-all-done')[0]

    @indicator = new window.App.Views.Users.UserIndicatorView parent: this
    $('#progress-bar-container .users').append @indicator.render().el

    sub "select_user", => @$el.removeClass 'current'
    sub "select_user_#{@model.id}", => @$el.addClass 'current'

    this

  renderStats: ->
    done = @model.todos.done().length
    remaining = done
    # debugger

    @$('.todo-stats').html @statsTemplate
      total:      @model.todos.length
      done:       done
      remaining:  remaining

    # @allCheckbox.checked = !remaining

  updateIndicator: ->
    @indicator.updatePosition


  # Add a single todo item to the list by creating a view for it, and
  # appending its element to the `<ul>`.
  addOne: (todo) ->
    view = new window.App.Views.Todos.TodoView model: todo
    @$('.todo-list').append view.render().el

  # Add all items in the **Todos** collection at once.
  addAll: ->
    @$('.todo-list').empty()
    @model.todos.each @addOne

  # Generate the attributes for a new Todo item.
  newAttributes: ->
    content:  @input.val()
    order:    @model.todos.nextOrder()
    done:     false
    user_id:  @model.id

  # If you hit return in the main input field, create new **Todo** model
  createOnEnter: (e)->
    if e.keyCode == 13
      @model.todos.create @newAttributes()
      @input.val ''

  # Clear all done todo items, destroying their models.
  clearCompleted: ->
    _.each @model.todos.done(), (todo)-> todo.clear()
    false

  # Lazily show the tooltip that tells you to press `enter` to save
  # a new todo item, after one second.
  showTooltip: (e)->
    tooltip = @$ '.ui-tooltip-top'
    val = @input.val()
    tooltip.fadeOut()
    clearTimeout @tooltipTimeout if @tooltipTimeout
    return if val == '' || val == @input.attr 'placeholder'
    show = -> tooltip.show().fadeIn()
    @tooltipTimeout = _.delay show, 1000

  toggleAllComplete: ->
    done = @allCheckbox.checked
    @model.todos.each (todo)-> todo.save 'done': done