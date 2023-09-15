# frozen_string_literal: true

require_relative '../../models/tree_node'
require_relative '../../error/custom_error_handler'

module Api
  # public class to manage nodes
  class TreeNodesController < ApplicationController
    skip_before_action :verify_authenticity_token, only: %i[index create]
    def index
      render json: TreeNode.tree.to_json, status: :ok
    end

    def create
      begin
        create_params
        check_presence
        unless create_params[:parent].nil? || create_params[:parent].instance_of?(String)
          raise CustomErrorHandler::DataTypeError,
                'The parent should be null or string type'
        end

        if create_params[:parent].nil?
          interactive_node = TreeNode.new(generate_id, create_params[:label])
          TreeNode.link_to_tree(interactive_node)
          (render json: { message: "This node (id: #{ interactive_node.id }) added as root!!" }, status: :created) && return
        end
      rescue CustomErrorHandler::DataTypeError, CustomErrorHandler::ParamMissingError => e
        return render_error_message(e)
      rescue ActionController::ParameterMissing
        (render json: { message: 'Parameter missing' }, status: :bad_request) && return
      end
      return unless is_valid_root_index?

      begin
        interactive_node = TreeNode.new(generate_id, create_params[:label], create_params[:parent])
        TreeNode.link_to_tree(interactive_node, create_params[:root_index])
        render json: { message: "This node (id: #{ interactive_node.id }) is added to the end of a list of children of Parent (id: #{ create_params[:parent] })!!" }, status: :created
      rescue CustomErrorHandler::ParentNotFoundError => e
        render_error_message(e)
      end
    end

    private

    def create_params
      @create_params ||= params.permit(:parent, :label, :root_index)
    end

    def generate_id
      SecureRandom.uuid
    end

    def is_valid_root_index?
      begin
        raise CustomErrorHandler::InvalidRootError if create_params[:root_index].present? && !validate_root_index
      rescue CustomErrorHandler::DataTypeError, CustomErrorHandler::InvalidRootError => e
        render_error_message(e) && (return false)
      end
      true
    end

    def validate_root_index
      if create_params[:root_index].instance_of?(String)
        raise CustomErrorHandler::DataTypeError,
              'The root index Type cannot be string'
      end

      create_params[:root_index] < TreeNode.tree.size
    end

    def render_error_message(error)
      render json: { message: error.message }, status: error.status
    end

    def check_presence
      raise CustomErrorHandler::ParamMissingError if !(create_params.key?(:parent) &&
        create_params.key?(:label)) || create_params[:label].nil?
    end
  end
end
