
# Helper

    _ = require 'lodash'

    # VertexIterator = require './utils/VertexIterator'
    # EdgeIterator = require './utils/EdgeIterator'

    module.exports =
      getNextId: (graph) -> graph.currentId++
      attachProperties: (element, args) -> _.each args, (pair) -> element.property ...pair

      addEdge: (outVertex, inVertex, label, kv) ->
        # Fix cyclic dep requiring in fct only
        Edge = require './Edge'
        id = @getNextId outVertex.graph
        edge = new Edge id, outVertex, label, inVertex
        @attachProperties edge, _.toPairs kv

        outVertex.graph().edges.set edge.id, edge
        @addOutEdge outVertex, label, edge
        @addInEdge inVertex, label, edge
        return edge

      addOutEdge: (vertex, label, edge) ->
        edges = vertex.outEdges.get(label)
        unless edges
          edges = new Set()
          vertex.outEdges.set label, edges
        edges.add edge

      addInEdge: (vertex, label, edge) ->
        edges = vertex.inEdges[label]
        if !edges
          edges = new Set()
          vertex.inEdges.set label, edges
        edges.add edge

      dropView: (graph) -> graph.graphView = null

      queryVertexIndex: (graph, key, value) -> graph.vertexIndex.get key, value

      getEdges: (elmt, direction, branchFactor, labels) ->
        if elmt instanceof 'Vertex'
          @getEdgesFromVertex vertex, direction, branchFactor, labels
        else @getEdgesFromGraph()

      getEdgesFromVertex: (vertex, direction, branchFactor, labels) ->
        edges = new MultiIterator()

        if direction is 'out' or direction is 'both'
          if labels.length > 0
            labels.forEach (label) ->
              outEdges = vertex.outEdges.get(label) or new Set()
              edges.addIterator outEdges.values()
          else
            vertex.outEdges.forEach (labeledSet, edgeLabel) ->
              edges.addIterator labeledSet.values()

        if direction is 'out' or direction is 'both'
          if labels.length > 0
            labels.forEach (label) ->
              inEdges = vertex.inEdges.get(label) or new Set()
              edges.addIterator inEdges.values()
          else
            vertex.inEdges.forEach (labeledSet, edgeLabel) ->
              edges.addIterator labeledSet.values()
        return new EdgeIterator edges, branchFactor

      getEdgesFromGraph: () -> throw new Error 'Not yet implemented'

      getVertices: (structure, direction, branchFactor, labels) ->
        if structure instanceof Vertex
          return getVerticesFromVertex structure, direction, branchFactor, labels
        else if structure instanceof Edge
          return getVerticesFromEdge structure, direction
        else
          return Array.from graph.vertices

      getVerticesFromVertex: (vertex, direction, branchFactor, labels) ->
        if direction is 'both'
          vertices = new MultiIterator branchFactor
          inIt = getEdges vertex, 'in', branchFactor, labels
          outIt = getEdges vertex, 'out', branchFactor, labels
          vertices.addIterator new VertexIterator inIt, 'in'
          vertices.addIterator new VertexIterator outIt, 'out'
          return vertices
        else
          edges = getEdges vertex, direction, branchFactor, labels
          return new VertexIterator edges, direction

      getVerticesFromEdge: (edge, direction) ->
        vertices = []
        vertices.push edge.outVertex if direction is 'out' or direction is 'both'
        vertices.push edge.inVertex if direction is 'in' or direction is 'both'
        return vertices.values() #iterator

      createGraphView: (graph, isolation, computeKeys) ->
        graphView = new GraphView isolation, computeKeys
        graph.graphView = graphView
        return graphView

      validateProperty: (key, value) ->
        throw new Error 'Property value must exist' unless value
        throw new Error 'Property key must exist' unless key
        throw new Error 'Property value cannot be an empty string' if key is ''
