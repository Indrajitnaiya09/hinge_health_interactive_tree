# frozen_string_literal: true

require_relative '../../models/tree_node'

module Api
  class TreeNodesController < ApplicationController
    skip_before_action :verify_authenticity_token, only: %i[index create]
    def index
      render json: TreeNode.tree.to_json, status: :ok
    end
  end
end
