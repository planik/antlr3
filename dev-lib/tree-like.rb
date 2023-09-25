#!/usr/bin/ruby
autoload :StringIO, 'stringio'

# = TreeLike
#
# A mix-in module to give objects tree-like behavior and structure
#
# == Usage
#
# * when the module is mixed into a class, the class' objects are given
#   attributes +parent+ & +children+
# * establish the tree structure elsewhere in the class by setting +parent+
# * the #parent= method automatically validates and updates the children of
#   the node to which it is assigned
#
# == Example
#   require 'tree-like'
#
#   class Node
#     include TreeLike
#
#     def initialize(text, parent = nil)
#       @text = text
#       self.parent = parent
#     end
#
#     def add_node(text)
#       return Node.new(text, self)
#     end
#
#     def to_s
#       self.map do |n|
#         ('  ' * n.depth) << n.text
#       end.join("\n")
#     end
#   end
#
#   root = Node.new("whateva")
#   root.add_node('some kid')
#   root.add_node('another')
#
#   puts(root)
#   # whateva
#   #   some kid
#   #   another

module TreeLike
  ##### Properties ###########################################################
  attr_reader :parent

  def parent=(node)
    previous = @parent
    @parent = node

    previous.children.delete(self) if previous and previous.children.include?(self)
    if @parent.nil? or @parent.children.include?(self)
      @depth = 0
    else
      @depth = @parent.depth + 1
      @parent.children << self
    end
  end

  def depth
    @depth ||= (@parent.nil? ? 0 : @parent.depth + 1)
  end

  def children
    @children ||= []
  end

  def index_in_parent
    @parent.nil? ? 0 : @parent.children.index(self)
  end

  def siblings
    return unless @parent

    @parent.children.reject { |i| i.equal? self }
  end

  ##### Predicates ###########################################################
  def root?
    @parent.nil?
  end

  def leaf?
    @children.nil? or @children.empty?
  end

  def is_child_of?(node)
    node.children.include? self
  end

  def has_child?(node)
    @children and @children.include?(node)
  end

  def detached?
    @parent.nil?
  end

  def attached?
    !@parent.nil?
  end

  ##### Derived Properties ###################################################
  def root
    root? ? self : ancestors[-1]
  end

  def leaves
    self.select { |i| i.leaf? }
  end

  ##### Restructuring Methods ################################################
  def detach
    self.parent = nil
    self
  end

  def swap_with(node)
    its_parent  = node.parent
    its_depth   = node.depth
    its_index   = node.index_in_parent
    my_parent   = parent
    my_depth    = depth
    my_index    = index_in_parent

    its_parent.children[its_index] = self
    my_parent.children[my_index] = node

    @parent = its_parent
    @depth = its_depth
    node.instance_variable_set(:@parent, my_parent)
    node.instance_variable_set(:@depth,  my_depth)
    node
  end

  def replace_with(node)
    my_parent   = parent
    my_index    = index_in_parent
    my_depth    = depth

    node.parent.children.delete(node) if node.parent
    node.instance_variable_set(:@parent, my_parent)
    node.instance_variable_set(:@depth, my_depth)
    my_parent.children[my_index] = node
    @parent = nil
  end

  def ancestors
    a = []
    cursor = self
    until cursor.root?
      a.push(cursor.parent)
      cursor = cursor.parent
    end
    a
  end

  def unravel
    out = []
    cursor = self
    until cursor.root?
      out.unshift(cursor)
      cursor = cursor.parent
    end
    out.unshift(cursor)
    out
  end

  def descendant_of?(node)
    ancestors.include?(node)
  end

  ##### Iterators ############################################################
  include Enumerable
  def each_child(&block)
    block_given? or return(enum_for(__method__))
    children.each(&block)
  end

  def each_ancestor(&block)
    block_given? or return(enum_for(__method__))
    ancestors.each(&block)
  end

  def delete_if(&block)
    block_given? or return(enum_for(__method__))
    for node in self.select(&block)
      node.detach
    end
    self
  end

  def walk
    stack = []
    cursor = self
    loop do
      yield(cursor)
      stack.push(cursor.children.dup) unless cursor.leaf?
    rescue StopIteration
    ensure
      break if stack.empty?

      cursor = stack.last.shift
      stack.pop if stack.last.empty?
    end
    self
  end
  alias each walk

  def prune!
    raise StopIteration
  end

  ##### Display And Formatting ###############################################
  def inspect_structure
    out = StringIO.new('')
    out.puts(inspect)
    each do |n|
      next if n.root?

      current_depth = (n.depth - 1)
      0.upto(current_depth) { |_i| out << '|  ' }
      tail = (n.parent.children.last == n)
      branch = tail ? '`--' : '|--'
      out << branch << n.inspect << "\n"
    end
    out.string
    # end
  end
end
