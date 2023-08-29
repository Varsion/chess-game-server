class ApplicationController < ActionController::API
  before_action :set_default_response_format

  def index
    render json: {
      message: "Develop by Jianhua, Build & Deploy by RENDER",
    }, status: 200
  end

  # POST /next_step
  # params: { position: "string", destination: "string" }
  # return: { next_step: "string", steps: "array", steps_count: "integer"}
  def next_step
    chess_service = ChessService.new(params[:position], params[:destination])

    render json: {
      steps: chess_service.steps,
      next_step: chess_service.next_step,
      steps_count: chess_service.steps_count,
    }, status: 200
  end

  private

  def set_default_response_format
    request.format = :json
  end
end
