
# Vertex

    Element = require './Element'
    Helper = require './Helper'
    VertexProperty = require './VertexProperty'

    class Vertex extends Element
      constructor: (id, label, graph) ->
        super id, label, graph
        @outEdges = new Map()
        @inEdges = new Map()

      property: (key, value, kv) -> if arguments.length is 1 then @getProperty key else @setProperty key, value, kv

      getProperty: (key) ->
        if @properties.has key
          list = @properties.get key
          throw new Error 'Vertex.Exceptions.multiplePropertiesExistForProvidedKey(key)' if list.length > 1
          return list[0]
        else return VertexProperty.empty()

      setProperty: (key, value) ->
        kv = if arguments.length > 2 and arguments[2]? then arguments[2] else []
        Helper.validateProperty key, value

        vertexProperty = new VertexProperty @, key, value

        list = @properties.get(key) or []
        list.push vertexProperty

        @properties.set key, list
        @graph().vertexIndex.autoUpdate key, value, null, @

        Helper.attachProperties vertexProperty, kv
        return vertexProperty

      addEdge: (label, vertex, kv) -> Helper.addEdge @, vertex, label, kv

      remove: () ->
        edges = []
        @getIterators().edges(Direction.BOTH, Number.MAX_SAFE_INTEGER).forEach edges.push
        edges.forEach Edge.remove
        @properties.clear()
        @graph.vertexIndex.removeElement @
        @graph.vertices.delete @id

      getIterators: () -> @iterators

      edges: (direction, branchFactor, labels, element) -> Helper.getEdges element, direction, branchFactor, labels

      vertices: (direction, branchFactor, labels, element) ->
        Helper.getVertices element, direction, branchFactor, labels

    Vertex.DEFAULT_LABEL = 'label'

    module.exports = Vertex
