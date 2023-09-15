# frozen_string_literal: true

require_relative '../../models/tree_node'

module Api
  # public class to manage nodes
  class TreeNodesController < ApplicationController
    skip_before_action :verify_authenticity_token, only: %i[index create]
    def index
      render json: TreeNode.tree.to_json, status: :ok
    end

    def create
      if create_params[:parent].nil?
        interactive_node = TreeNode.new(generate_id, create_params[:label])
        TreeNode.link_to_tree(interactive_node)
        (render json: { message: "This node (id: #{ interactive_node.id }) added as root!!" }, status: :created) && return
      end

      interactive_node = TreeNode.new(generate_id, create_params[:label], create_params[:parent])
      TreeNode.link_to_tree(interactive_node, create_params[:root_index])
      render json: { message: "This node (id: #{ interactive_node.id }) is added to the end of a list of children of Parent (id: #{ create_params[:parent] })!!" }, status: :created
    end

    private

    def create_params
      @create_params ||= params.permit(:parent, :label, :root_index)
    end

    def generate_id
      SecureRandom.uuid
    end
  end
end
