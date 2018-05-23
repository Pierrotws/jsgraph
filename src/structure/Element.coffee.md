
# Element

    { inherits } = require 'util'

    Helper = require './Helper'

    class Element
      constructor: (id, label, graph) ->
        @id = id
        @label = label
        @properties = new Map()
        # private element
        __graph = graph
        # public getter
        @graph = () -> __graph

      hashCode: () -> @id.hashCode()

      getId: () -> @id

      property: (key) -> if @properties.has key then @properties.get(key)[0] else {}

    module.exports = Element
