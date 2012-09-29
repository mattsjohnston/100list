class App.Collections.Users extends Backbone.Collection

  url: '/users'

  # Reference to this collection's model.
  model: App.Models.User