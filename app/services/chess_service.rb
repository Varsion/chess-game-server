class ChessService < ApplicationService
  attr_reader :steps_count, :next_step, :steps

  COL = %w(a b c d e f g h)
  ROW = %w(1 2 3 4 5 6 7 8)

  # movable situations
  DX = [2, 2, -2, -2, 1, 1, -1, -1]
  DY = [-1, 1, -1, 1, -2, 2, -2, 2]

  # BFS to get Knight shortest path
  def initialize(position, destination)
    visited = []
    @steps_count = 0
    queue = [] << position
    node_steps = {}
    @steps = []

    while !queue.empty?
      node = queue.pop

      dist = node_steps[node]&.steps || 0

      if node == destination
        @steps_count = dist
        break
      end

      unless visited.include?(node)
        visited << node

        (0..7).each do |i|
          new_x = COL.index(node[0]) + DX[i]
          new_y = ROW.index(node[1]) + DY[i]

          if (new_x >= 0 && new_x < 8) && (new_y >= 0 && new_y < 8)
            new_position = COL[new_x] + ROW[new_y]
            queue.unshift(new_position)
            node_steps[new_position] = Node.new(position: new_position, steps: dist + 1, parent: node_steps[node])
          end
        end
      end
    end

    # backward from destination
    next_step = node_steps[destination]
    @steps << destination
    until next_step.parent.nil?
      next_step = next_step.parent
      @steps.unshift(next_step.position)
    end

    @next_step = next_step.position
  end
end
