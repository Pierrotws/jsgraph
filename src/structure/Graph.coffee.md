
# Graph

    _ = require 'lodash'

    Helper = require './Helper'
    Index = require './Index'
    Vertex = require './Vertex'
    Edge = require './Edge'

    class Graph
      constructor: () ->
        @currentId = 0
        @vertices = new Map()
        @edges = new Map()
        # @variables = new GraphVariables()
        @vertexIndex = new Index @
        @edgeIndex = new Index @

      v: (id) ->
        vertex = @vertices.get id
        throw Error 'Graph.Exceptions.elementNotFound(Vertex, id)' unless vertex
        return vertex

      addVertex: (obj, ...args) ->
        obj ?= []
        kv = if args.length then _.chunk [obj, ...args], 2 else _.toPairs obj
        # Helper.legalPropertyKeyValueArray kv
        # id = Helper.getIdValue kv
        # label = Helper.getLabelValue(kv) or Vertex.DEFAULT_LABEL
        label = Vertex.DEFAULT_LABEL

        if id and @vertices.get id
          throw new Error "Exceptions.vertexWithIdAlreadyExists(#{id})"
        else id = Helper.getNextId @

        vertex = new Vertex id, label, @
        @vertices.set id, vertex
        Helper.attachProperties vertex, kv
        return vertex

      V: () -> new GraphTraversal @, Vertex

      E: () -> throw new Error 'Not yet implemented'

      of: () -> new TinkerTraversal @

      getIndexedKeys: (elementClass) ->
        elementClass ?= ''
        switch elementClass.toLowerCase()
          when 'vertex' then @vertexIndex.getIndexedKeys()
          when 'edge' then @edgeIndex.getIndexedKeys()
          else throw new Error "Class is not indexable: #{elementClass}"

      createIndex: (key, elementClass) ->
        throw Error "Index key must be a string value" unless typeof key is 'string' or key instanceof String
        switch elementClass.toLowerCase()
          when 'vertex' then @vertexIndex.createKeyIndex key
          when 'edge' then @edgeIndex.createKeyIndex key
          else throw new Error "Class is not indexable: #{elementClass}"

      dropIndex: (key, elementClass) ->
        throw Error "Invalid key" unless key
        switch elementClass.toLowerCase()
          when 'vertex' then @vertexIndex?.dropKeyIndex key
          when 'edge' then @edgeIndex?.dropKeyIndex key
          else throw new Error "Class is not indexable: #{elementClass}"

    Graph.open = () -> new Graph()

    module.exports = Graph
