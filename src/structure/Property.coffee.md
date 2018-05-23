
# Property

    class Property
      constructor: (element, key, value) ->
        @element = element
        @key = key
        @value = value
        @graph = element.graph

      getElement: () -> @element

      getKey: () -> @key

      getValue: () -> @value

      isPresent: () -> @value?

      isHidden: () -> false

    module.exports = Property
