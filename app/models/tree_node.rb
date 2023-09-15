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
end
