class ApplicationController < ActionController::API
  before_action :set_default_response_format

  def index
    render json: {
      message: "Develop by Jianhua, Build & Deploy by RENDER",
    }, status: 200
  end

  # POST /next_step
  # params: { position: "string", destination: "string" }
  # return: { next_step: "string" }
  def next_step
    chess_col = %w(a b c d e f g h)
    chess_row = %w(1 2 3 4 5 6 7 8)

    dx = [2, 2, -2, -2, 1, 1, -1, -1]
    dy = [-1, 1, 1, -1, 2, -2, 2, -2]

    visited = []
    count = 0
    queue = [] << params[:position]
    node_steps = {}

    while !queue.empty?
      node = queue.pop

      dist = node_steps[node]&.steps || 0

      if node == params[:destination]
        count = dist
        break
      end

      unless visited.include?(node)
        visited << node

        (0..7).each do |i|
          new_x = chess_col.index(node[0]) + dx[i]
          new_y = chess_row.index(node[1]) + dy[i]

          if (new_x > 0 && new_x < 8) && (new_y > 0 && new_y < 8)
            new_position = chess_col[new_x] + chess_row[new_y]
            queue.unshift(new_position)
            node_steps[new_position] = Node.new(position: new_position, steps: dist + 1, parent: node_steps[node])
          end
        end
      end
    end

    next_step = node_steps[params[:destination]]

    until next_step.parent.nil?
      next_step = next_step.parent
    end

    render json: {
      next_step: next_step.position,
    }, status: 200
  end

  private

  def set_default_response_format
    request.format = :json
  end
end
