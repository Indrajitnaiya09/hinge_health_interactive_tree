# frozen_string_literal: true

require 'securerandom'

class TreeNode
  attr_accessor :id, :parent_id, :label, :children

  @@TREE = []

  def initialize(id, label, parent_id = nil)
    @id = id
    @parent_id = parent_id
    @label = label
    @children = []
  end

  def self.tree
    @@TREE
  end

  def self.link_to_tree(interactive_node, root_index = nil)
    # parent id passed but root_index not passed
    # then consider root_index = 0, and perform the rest operation
    #
    # if parent id not found, return error
    parent_id = interactive_node.parent_id
    if parent_id
      return interactive_node.process_insert_request(parent_id, root_index) if root_index

      root_index = 0
      interactive_node.process_insert_request(parent_id, root_index)
    else
      # if parent id not present, consider as root level entry
      insert_in_tree_array(interactive_node)
    end
  end

  def self.insert_in_tree_array(node)
    @@TREE << node.format_for_output
  end

  def insert_record(children_arr, node)
    children_arr.push(node.format_for_output)
    children_arr
  end

  def process_insert_request(parent_id, root_index)
    raise CustomErrorHandler::ParentNotFoundError, "Parent id - '#{parent_id}' not found" if @@TREE[root_index].nil?
    # find_parent
    current_tree = @@TREE[root_index]
    parent = if current_tree.key?(parent_id)
               current_tree[parent_id]
             else
               find_parent_node(children_nodes(current_tree),
                                parent_id)
             end

    raise CustomErrorHandler::ParentNotFoundError, "Parent id - '#{parent_id}' not found" unless parent
    #insert new record inside parent
    link_node_to_parent(parent, self)
  end

  def link_node_to_parent(parent, node)
    insert_record(parent[:children], node)
    node
  end

  def children_nodes(current_tree)
    current_tree.values[0][:children]
  end

  def find_parent_node(data, search_id)
    data.each do |item|
      # Check if the current item has an :id key and its value matches the search_id
      return item[search_id] if item.key?(search_id)

      # Recursively search in the children if they exist
      result = find_parent_node(children_nodes(item), search_id)
      return result if result
    end
    nil # ID not found
  end

  def format_for_output
    { id.to_s => { label: label, children: children } }
  end
end
