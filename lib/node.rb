class Node
  attr_accessor :position, :parent, :steps

  def initialize(position:, steps: 0, parent: nil)
    @position = position
    @parent = parent
    @steps = steps
  end
end
