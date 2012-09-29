# Cache of all topics and the associated callbacks
cache = {}

# Publish a topic
# example: pub 'show_product', { analyze: true, model: product }
# If an analyze key is present on the options object, a request is sent to the server to save the event. 
# Furthermore, if the options object has an ID, it is appended # to the event. 
# This is for performance, so that if x number of views are binding to one event(ie. product_like) but only care
# about their prodect, x number of functions aren't called.

pub = (topic, options) ->
  _.each cache[topic], (callback) -> callback(options)

  if options?.analyze?
    true
    # TODO
    
  if options?.id
    _.each cache["#{topic}_#{options.id}"], (callback) -> callback(options)

# Subscribe to a topic
# example: sub 'show_product', (options) -> console.log "Selected product #{options.model.get 'title'}"
sub = (topic, callback) ->
  (cache[topic] ||= []).push callback

window.pub = pub
window.sub = sub
