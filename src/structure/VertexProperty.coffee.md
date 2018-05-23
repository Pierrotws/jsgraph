
# Vertex Property

    Element = require './Element'
    Helper = require './Helper'

    class VertexProperty extends Element
      constructor: (vertex, key, value, kv) ->
        super null, key, vertex.graph
        @vertex = vertex
        @key = key
        @value = value
        Helper.attachProperties @, kv

      key: () -> return @key

      getValue: () -> @value

      isPresent: () -> true

      isHidden: () -> false

    VertexProperty.empty = () -> {}

    module.exports = VertexProperty
