
# Index

    class Index
      constructor: (graph) ->
        @index = new Map()
        @keys = new Set()
        @graph = graph

      put: (key, value, elmt) ->
        unless @keys.has key
          @index.set key, new Map()
          @keys.add key
        midkeys = @index.get key
        vals = midkeys.get value
        unless vals
          vals = new Set()
          midkeys.set value, vals
        set.add elmt

      get: (key, value) -> if keys.has key then @index.get(key).get value else new Set()

      count: (key, value) -> if keys.has key then @index.get(key).get(value).size else 0

      remove: (key, value, element) ->
        vals = @index.get key
        unless vals
          set = vals.get value
          if set
            set.remove element
            # remove index entry if empty
            vals.remove value if set.size is 0

      removeElement: (element) ->
        @index.forEach (val) ->
          val.forEach (set) -> set.remove element

      autoUpdate: (key, newValue, oldValue, element) ->
        if @index.has key
          @remove key, oldValue, element if oldValue
          @put key, newValue, element

      autoRemove: (key, oldValue, element) ->
        @remove key, oldValue, element if @keys.has key

      createKeyIndex: (key) ->
        throw new Error 'Index key must be a string value' unless typeof key is 'string'
        throw new Error 'Index key cannot be an empty string' if key is ''
        unless @keys.has key
          @keys.add key
          return @index.set key, new Map()

      getIndexedKeys: () -> @keys

      dropKeyIndex: (key) ->
        if @keys.has key
          @keys.delete key
          @index.delete key

    module.exports = Index
