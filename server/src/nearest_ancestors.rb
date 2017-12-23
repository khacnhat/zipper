
module NearestAncestors # mix-in

  def nearest_ancestors(symbol, my = self)
    loop {
      unless my.respond_to? :parent
        fail "#{my.class.name} does not have a parent"
      end
      my = my.parent
      if my.respond_to? symbol
        return my.send(symbol)
      end
    }
  end

end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Works by assuming the object (which included the module) has a parent
# and repeatedly chains back parent to parent to parent until it gets to
# an object with the required property, or runs out of parents.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
