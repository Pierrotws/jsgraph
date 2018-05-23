
# Edge

    { inherits } = require 'util'

    Element = require './Element'
    Helper = require './Helper'
    Property = require './Property'


    class Edge extends Element
      constructor: (id, outVertex, label, inVertex) ->
        super id, label, outVertex.graph()
        @outVertex = outVertex
        @inVertex = inVertex

      property: (key, value) -> if arguments.length is 1 then super.property key else @setProperty key, value

      setProperty: (key, value) ->
        Helper.validateProperty key, value
        oldProperty = super.property key
        newProperty = new Property @, key, value
        @properties.set key, [newProperty]
        # @graph.edgeIndex.autoUpdate key, value, if oldProperty.isPresent() then null else @
        return newProperty

    module.exports = Edge
