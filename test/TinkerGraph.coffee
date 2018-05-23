
{ assert } = require 'chai'
{ createGraph } = require '../lib'

describe 'Graph', () ->

  describe '.addvertex()', () ->
    it 'should add a vertex with no property', () ->
      g = createGraph()
      v = g.addVertex()
      assert.equal g.vertices.size, 1
      assert.equal v.id, 0

    describe 'method signatures', () ->
      it 'should add a vertex with key/value passed as multiple arguments', () ->
        g = createGraph()
        v = g.addVertex 'name', 'alice', 'foo', 'bar'
        assert.equal g.vertices.size, 1
        assert.equal v.id, 0
        assert.equal v.property('name').value, 'alice'
        assert.equal v.property('foo').value, 'bar'

      it 'should add a vertex with properties passed as a single object argument', () ->
        g = createGraph()
        v = g.addVertex name: 'bob', baz: 'duh'
        assert.equal g.vertices.size, 1
        assert.equal v.id, 0
        assert.equal v.property('name').value, 'bob'
        assert.equal v.property('baz').value, 'duh'

    describe 'multiple vertices creation', () ->
      it 'should add many vertices to the graph', () ->
        g = createGraph()
        v1 = g.addVertex name: 'bob'
        v2 = g.addVertex name: 'alice'
        assert.equal g.vertices.size, 2


      it 'should increment vertices ids properly', () ->
        g = createGraph()
        v1 = g.addVertex name: 'bob'
        v2 = g.addVertex name: 'alice'
        assert.equal v1.id, 0
        assert.equal v2.id, 1

  describe '.addEdge()', () ->
    it 'should add an edge with no property', () ->
      g = createGraph()
      v1 = g.addVertex()
      v2 = g.addVertex()
      e = v1.addEdge 'knows', v2
      assert.equal g.edges.size, 1
      assert.equal e.label, 'knows'
      assert.equal v1.outEdges.size, 1
      assert.equal v1.outEdges.get('knows').size, 1
      assert.equal v1.outEdges.get('knows').values().next().value, e
      assert.equal v2.inEdges.size, 1
      assert.equal v2.inEdges.get('knows').size, 1
      assert.equal v2.inEdges.get('knows').values().next().value, e

    it 'should add an edge with properties', () ->
      g = createGraph()
      v1 = g.addVertex 'name', 'bob'
      v2 = g.addVertex name: 'alice'
      e = v1.addEdge 'likes', v2, since: 'now'
      assert.equal e.property('since').value, 'now'
      assert.equal g.edges.size, 1
      assert.equal e.label, 'likes'
      assert.equal v1.outEdges.size, 1
      assert.equal v1.outEdges.get('likes').size, 1
      assert.equal v1.outEdges.get('likes').values().next().value, e
      assert.equal v2.inEdges.size, 1
      assert.equal v2.inEdges.get('likes').size, 1
      assert.equal v2.inEdges.get('likes').values().next().value, e


  describe 'Indices', () ->
    it 'should manage indices', () ->
      g = createGraph()
      vertexKeys = g.getIndexedKeys 'vertex'
      edgeKeys = g.getIndexedKeys 'edge'
      assert.equal vertexKeys.size, 0
      assert.equal edgeKeys.size, 0
      g.createIndex 'name1', 'vertex'
      g.createIndex 'name2', 'vertex'
      g.createIndex 'name1', 'vertex'
      g.createIndex 'oid1', 'edge'
      g.createIndex 'oid2', 'edge'

      assert.sameMembers Array.from(vertexKeys), ['name1', 'name2']
      assert.sameMembers Array.from(edgeKeys), ['oid1', 'oid2']

      g.dropIndex 'name2', 'vertex'
      assert.equal vertexKeys.size, 1

      g.dropIndex 'name1', 'vertex'
      assert.equal vertexKeys.size, 0

      g.dropIndex 'oid2', 'edge'
      assert.equal edgeKeys.size, 1
      assert.equal edgeKeys.values().next().value, 'oid1'

      g.dropIndex 'oid1', 'edge'
      assert.equal edgeKeys.size, 0

    checkIndexKey = (elmt) ->
      g = createGraph()
      regex = /^Index key must be a string value/
      assert.throws (() -> g.createIndex null, elmt), regex
      assert.throws (() -> g.createIndex undefined, elmt), regex
      assert.throws (() -> g.createIndex 0, elmt), regex
      assert.throws (() -> g.createIndex 1, elmt), regex
      assert.throws (() -> g.createIndex [], elmt), regex
      assert.throws (() -> g.createIndex {}, elmt), regex
    it 'should not create vertex index with a non-string key', () -> checkIndexKey 'vertex'
    it 'should not create Edge index with a non-string key', () -> checkIndexKey 'edge'

    it 'should not create vertex index with an empty key', () ->
      g = createGraph()
      regex = /Index key cannot be an empty string/
      assert.throws (() -> g.createIndex '', 'vertex'), regex

    it 'should not create edge index with an empty key', () ->
      g = createGraph();
      regex = /Index key cannot be an empty string/
      assert.throws (() -> g.createIndex '', 'edge'), regex
