#!/usr/bin/ruby
# LICENSE
#
# [The "BSD licence"]
# Copyright (c) 2009-2013 Kyle Yetter
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
#  1. Redistributions of source code must retain the above copyright
#     notice, this list of conditions and the following disclaimer.
#  2. Redistributions in binary form must reproduce the above copyright
#     notice, this list of conditions and the following disclaimer in the
#     documentation and/or other materials provided with the distribution.
#  3. The name of the author may not be used to endorse or promote products
#     derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
# OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
# IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
# NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
# THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

require 'antlr3'

module ANTLR3
  # rdoc ANTLR3::AST
  #
  # Name space containing all of the entities pertaining to tree construction and
  # tree parsing.
  #

  module AST
    autoload :Wizard, 'antlr3/tree/wizard'
    autoload :Visitor, 'antlr3/tree/visitor'

    ####################################################################################################
    ############################################ Tree Parser ###########################################
    ####################################################################################################

    # rdoc ANTLR3::AST::TreeParser
    #
    # = TreeParser
    #
    # TreeParser is the default base class of ANTLR-generated tree parsers. The class
    # tailors the functionality provided by Recognizer to the task of tree-pattern
    # recognition.
    #
    # == About Tree Parsers
    #
    # ANTLR generates three basic types of recognizers:
    # * lexers
    # * parsers
    # * tree parsers
    #
    # Furthermore, it is capable of generating several different flavors of parser,
    # including parsers that take token input and use it to build Abstract Syntax
    # Trees (ASTs), tree structures that reflect the high-level syntactic and semantic
    # structures defined by the language.
    #
    # You can take the information encapsulated by the AST and process it directly in
    # a program. However, ANTLR also provides a means to create a recognizer which is
    # capable of walking through the AST, verifying its structure and performing
    # custom actions along the way -- tree parsers.
    #
    # Tree parsers are created from tree grammars. ANTLR-generated tree parsers
    # closely mirror the general structure of regular parsers and lexers.
    #
    # For more in-depth coverage of the topic, check out the ANTLR documentation
    # (http://www.antlr.org).
    #
    # == The Tree Parser API
    #
    # Like Parser, the class does not stray too far from the Recognizer API.
    # Mainly, it customizes a few methods specifically to deal with tree nodes
    # (instead of basic tokens), and adds some helper methods for working with trees.
    #
    # Like all ANTLR recognizers, tree parsers contained a shared state structure and
    # an input stream, which should be a TreeNodeStream. ANTLR intends to keep its
    # tree features flexible and customizable, and thus it does not make any
    # assumptions about the class of the actual nodes it processes. One consequence of
    # this flexibility is that tree parsers also require an extra tree adaptor object,
    # the purpose of which is to provide a homogeneous interface for handling tree
    # construction and analysis of your tree nodes.
    #
    # See Tree and TreeAdaptor for more information.
    #

    class TreeParser < Recognizer
      def self.main(argv = ARGV, options = {})
        if argv.is_a?(::Hash) then options = argv
                                   argv = ARGV end
        main = ANTLR3::Main::WalkerMain.new(self, options)
        block_given? ? yield(main) : main.execute(argv)
      end

      def initialize(input, options = {})
        super(options)
        @input = input
      end

      alias tree_node_stream input
      alias tree_node_stream= input=

      def source_name
        @input.source_name
      end

      def missing_symbol(_error, expected_token_type, _follow)
        name = token_name(expected_token_type).to_s
        text = '<missing ' << name << '>'
        tk = create_token do |t|
          t.text = text
          t.type = expected_token_type
        end
        CommonTree.new(tk)
      end

      def match_any(_ignore = nil)
        @state.error_recovery = false

        look = @input.look
        adaptor = @input.tree_adaptor
        if adaptor.child_count(look) == 0
          @input.consume
          return
        end

        level = 0
        while type = @input.peek and type != EOF
          # token_type == EOF or ( token_type == UP && level == 0 )
          @input.consume
          case type
          when DOWN then level += 1
          when UP
            level -= 1
            level.zero? and break
          end
        end
      end

      def mismatch(input, type, _follow = nil)
        raise MismatchedTreeNode.new(type, input)
      end

      def error_header(e)
        <<-END.strip!
    #{grammar_file_name}: node from #{ # {' '}
      e.approximate_line_info? ? 'after ' : ''
    } line #{e.line}:#{e.column}
        END
      end

      def error_message(e)
        adaptor = e.input.adaptor
        e.token = adaptor.token(e.node)
        e.token ||= create_token do |tok|
          tok.type = adaptor.type_of(e.node)
          tok.text = adaptor.text_of(e.node)
        end
        super(e)
      end

      def trace_in(rule_name, rule_index)
        super(rule_name, rule_index, @input.look)
      end

      def trace_out(rule_name, rule_index)
        super(rule_name, rule_index, @input.look)
      end
    end

    ####################################################################################################
    ############################################ Tree Nodes ############################################
    ####################################################################################################

    # rdoc ANTLR3::AST::Tree
    #
    # = ANTLR Abstract Syntax Trees
    #
    # As ANTLR is concerned, an Abstract Syntax Tree (AST) node is an object that
    # wraps a token, a list of child trees, and some information about the collective
    # source text embodied within the tree and its children.
    #
    # The Tree module, like the Token and Stream modules, emulates an abstract base
    # class for AST classes; it specifies the attributes that are expected of basic
    # tree nodes as well as the methods trees need to implement.
    #
    # == Terminology
    #
    # While much of this terminology is probably familiar to most developers, the
    # following brief glossary is intended to clarify terminology used in code
    # throughout the AST library:
    #
    # [payload] either a token value contained within a node or +nil+
    # [flat list (nil tree)] a tree node without a token payload, but with more
    #                        than one children -- functions like an array of
    #                        tree nodes
    # [root] a top-level tree node, i.e. a node that does not have a parent
    # [leaf] a node that does not have any children
    # [siblings] all other nodes sharing the same parent as some node
    # [ancestors] the list of successive parents from a tree node to the root node
    # [error node] a special node used to represent an erroneous series of tokens
    #              from an input stream
    #

    module Tree
      # attr_accessor :parent
      attr_accessor :start_index
      attr_accessor :stop_index, :child_index
      attr_reader :type, :text, :line, :column
      # attr_reader :children
      attr_reader :token

      def root?
        parent.nil?
      end
      alias detached? root?

      def root
        cursor = self
        until cursor.root?
          yield(parent_node = cursor.parent)
          cursor = parent_node
        end
        cursor
      end

      def leaf?
        children.nil? or children.empty?
      end

      def has_child?(node)
        children and children.include?(node)
      end

      def depth
        root? ? 0 : parent.depth + 1
      end

      def siblings
        root? and return []
        parent.children.reject { |c| c.equal?(self) }
      end

      def each_ancestor
        block_given? or return(enum_for(:each_ancestor))
        cursor = self
        until cursor.root?
          yield(parent_node = cursor.parent)
          cursor = parent_node
        end
        self
      end

      def ancestors
        each_ancestor.to_a
      end

      def walk
        block_given? or return(enum_for(:walk))
        stack = []
        cursor = self
        while true
          begin
            yield(cursor)
            stack.push(cursor.children.dup) unless cursor.empty?
          rescue StopIteration
            # skips adding children to prune the node
          ensure
            break if stack.empty?

            cursor = stack.last.shift
            stack.pop if stack.last.empty?
          end
        end
        self
      end
    end

    # rdoc ANTLR3::AST::BaseTree
    #
    # A base implementation of an Abstract Syntax Tree Node. It mainly defines the
    # methods and attributes required to implement the parent-node-children
    # relationship that characterize a tree; it does not provide any logic concerning
    # a node's token <i>payload</i>.
    #

    class BaseTree < ::Array
      attr_accessor :parent

      extend ClassMacros
      include Tree

      def initialize(_node = nil)
        super()
        @parent = nil
        @child_index = 0
      end

      def children = self

      alias child at
      alias child_count length

      def first_with_type(tree_type)
        find { |child| child.type == tree_type }
      end

      def add_child(child_tree)
        child_tree.nil? and return
        if child_tree.flat_list?
          equal?(child_tree.children) and
            raise ArgumentError, 'attempt to add child list to itself'
          child_tree.each_with_index do |child, index|
            child.parent = self
            child.child_index = length + index
          end
          concat(child_tree)
        else
          child_tree.child_index = length
          child_tree.parent = self
          self << child_tree
        end
        self
      end

      def detach
        @parent = nil
        @child_index = -1
        self
      end

      alias add_children concat
      alias each_child each

      def set_child(index, tree)
        return if tree.nil?

        tree.flat_list? and raise ArgumentError, "Can't set single child to a list"
        tree.parent = self
        tree.child_index = index
        self[index] = tree
      end

      def delete_child(index)
        killed = delete_at(index) and freshen(index)
        killed
      end

      def replace_children(start, stop, new_tree)
        start >= length or stop >= length and
          raise IndexError, <<-END.gsub!(/^\s+\| /, '')
      | indices span beyond the number of children:
      |  children.length = #{length}
      |  start = #{start_index.inspect}
      |  stop  = #{stop_index.inspect}
          END
        new_children = new_tree.flat_list? ? new_tree : [new_tree]
        self[start..stop] = new_children
        freshen(start_index)
        self
      end

      def flat_list?
        false
      end

      def freshen(offset = 0)
        for i in offset...length
          node = self[i]
          node.child_index = i
          node.parent = self
        end
      end

      def sanity_check(parent = nil, i = -1)
        parent == @parent or
          raise TreeInconsistency.failed_parent_check!(parent, @parent)
        i == @child_index or
          raise TreeInconsistency.failed_index_check!(i, @child_index)
        each_with_index do |child, index|
          child.sanity_check(self, index)
        end
      end

      def inspect
        empty? and return to_s
        buffer = ''
        buffer << '(' << to_s << ' ' unless flat_list?
        buffer << map { |c| c.inspect }.join(' ')
        buffer << ')' unless flat_list?
        buffer
      end

      def walk
        block_given? or return(enum_for(:walk))
        stack = []
        cursor = self
        while true
          begin
            yield(cursor)
            stack.push(Array[*cursor]) unless cursor.empty?
          rescue StopIteration
            # skips adding children to prune the node
          ensure
            break if stack.empty?

            cursor = stack.last.shift
            stack.pop if stack.last.empty?
          end
        end
        self
      end

      def prune
        raise StopIteration
      end

      abstract :to_s
      # protected :sanity_check, :freshen

      def root? = @parent.nil?
      alias leaf? empty?
    end

    # rdoc ANTLR3::AST::CommonTree
    #
    # The default Tree class implementation used by ANTLR tree-related code.
    #
    # A CommonTree object is a tree node that wraps a token <i>payload</i> (or a +nil+
    # value) and contains zero or more child tree nodes. Additionally, it tracks
    # information about the range of data collectively spanned by the tree node:
    #
    # * the token stream start and stop indexes of tokens contained throughout
    #   the tree
    # * that start and stop positions of the character input stream from which
    #   the tokens were defined
    #
    # Tracking this information simplifies tasks like extracting a block of code or
    # rewriting the input stream. However, depending on the purpose of the
    # application, building trees with all of this extra information may be
    # unnecessary. In such a case, a more bare-bones tree class could be written
    # (optionally using the BaseTree class or the Token module). Define a customized
    # TreeAdaptor class to handle tree construction and manipulation for the
    # customized node class, and recognizers will be able to build, rewrite, and parse
    # the customized lighter-weight trees.
    #

    class CommonTree < BaseTree
      def initialize(payload = nil)
        super()
        @start_index = -1
        @stop_index = -1
        @child_index = -1
        case payload
        when CommonTree # copy-constructor style init
          @token       = payload.token
          @start_index = payload.start_index
          @stop_index  = payload.stop_index
        when nil, Token then @token = payload
        else raise ArgumentError,
                   format('Invalid argument type: %s (%p)', payload.class, payload)
        end
      end

      def initialize_copy(orig)
        super
        clear
        @parent = nil
      end

      def copy_node
        self.class.new(@token)
      end

      def flat_list?
        @token.nil?
      end

      def type
        @token ? @token.type : 0
      end

      def text
        @token.text
      rescue StandardError
        nil
      end

      def line
        if @token.nil? or @token.line == 0
          return (empty? ? 0 : first.line)
        end

        @token.line
      end

      def column
        if @token.nil? or @token.column == -1
          return(empty? ? 0 : first.column)
        end

        @token.column
      end

      def start_index
        @start_index == -1 and @token and return @token.index
        @start_index
      end

      def stop_index
        @stop_index == -1 and @token and return @token.index
        @stop_index
      end

      alias token_start_index= start_index=
      alias token_stop_index= stop_index=
      alias token_start_index start_index
      alias token_stop_index stop_index

      def name
        @token.name
      rescue StandardError
        'INVALID'
      end

      def token_range
        unknown_boundaries? and infer_boundaries
        @start_index..@stop_index
      end

      def source_range
        unknown_boundaries? and infer_boundaries
        tokens = map do |node|
          tk = node.token and tk.index >= 0 ? tk : nil
        end
        tokens.compact!
        first, last = tokens.minmax_by { |t| t.index }
        first.start..last.stop
      end

      def infer_boundaries
        if empty? and @start_index < 0 || @stop_index < 0
          @start_index = @stop_index = begin
            @token.index
          rescue StandardError
            -1
          end
          return
        end
        for child in self do child.infer_boundaries end
        return if @start_index >= 0 and @stop_index >= 0

        @start_index = first.start_index
        @stop_index  = last.stop_index
        nil
      end

      def unknown_boundaries?
        @start_index < 0 or @stop_index < 0
      end

      def to_s
        flat_list? ? 'nil' : @token.text.to_s
      end

      def pretty_print(printer)
        text = @token ? @token.text : 'nil'
        text =~ /\s+/ and
          text = text.dump

        if empty?
          printer.text(text)
        else
          endpoints = @token ? ["(#{text}", ')'] : ['', '']
          printer.group(1, *endpoints) do
            for child in self
              printer.breakable
              printer.pp(child)
            end
          end
        end
      end
    end

    # rdoc ANTLR3::AST::CommonErrorNode
    #
    # Represents a series of erroneous tokens from a token stream input
    #

    class CommonErrorNode < CommonTree
      include ANTLR3::Error
      include ANTLR3::Constants

      attr_accessor :input, :start, :stop, :error

      def initialize(input, start, stop, error)
        super(nil)
        stop = start if stop.nil? or
                        (stop.token_index < start.token_index and stop.type != EOF)
        @input = input
        @start = start
        @stop = stop
        @error = error
      end

      def flat_list?
        false
      end

      def type
        INVALID_TOKEN_TYPE
      end

      def text
        case @start
        when Token
          i = @start.token_index
          j = @stop.type == EOF ? @input.size : @stop.token_index
          @input.to_s(i, j)            # <- the bad text
        when Tree
          @input.to_s(@start, @stop)   # <- the bad text
        else
          '<unknown>'
        end
      end

      def to_s
        case @error
        when MissingToken
          "<missing type: #{@error.missing_type}>"
        when UnwantedToken
          "<extraneous: #{@error.token.inspect}, resync = #{text}>"
        when MismatchedToken
          "<mismatched token: #{@error.token.inspect}, resync = #{text}>"
        when NoViableAlternative
          "<unexpected: #{@error.token.inspect}, resync = #{text}>"
        else "<error: #{text}>"
        end
      end
    end

    Constants::INVALID_NODE = CommonTree.new(ANTLR3::INVALID_TOKEN)

    ####################################################################################################
    ########################################### Tree Adaptors ##########################################
    ####################################################################################################

    # rdoc ANTLR3::AST::TreeAdaptor
    #
    # Since a tree can be represented by a multitude of formats, ANTLR's tree-related
    # code mandates the use of Tree Adaptor objects to build and manipulate any actual
    # trees. Using an adaptor object permits a single recognizer to work with any
    # number of different tree structures without adding rigid interface requirements
    # on customized tree structures. For example, if you want to represent trees using
    # simple arrays of arrays, you just need to design an appropriate tree adaptor and
    # provide it to the parser.
    #
    # Tree adaptors are tasked with:
    #
    # * copying and creating tree nodes and tokens
    # * defining parent-child relationships between nodes
    # * cleaning up / normalizing a full tree structure after construction
    # * reading and writing the attributes ANTLR expects of tree nodes
    # * providing node access and iteration
    #

    module TreeAdaptor
      include TokenFactory
      include Constants
      include Error

      def add_child(tree, child)
        tree.add_child(child) if tree and child
      end

      def child_count(tree)
        tree.child_count
      end

      def child_index(tree)
        tree.child_index
      rescue StandardError
        0
      end

      def child_of(tree, index)
        tree.nil? ? nil : tree.child(index)
      end

      def copy_node(tree_node)
        tree_node and tree_node.dup
      end

      def copy_tree(tree, parent = nil)
        tree or return nil
        new_tree = copy_node(tree)
        set_child_index(new_tree, child_index(tree))
        set_parent(new_tree, parent)
        each_child(tree) do |child|
          new_sub_tree = copy_tree(child, new_tree)
          add_child(new_tree, new_sub_tree)
        end
        new_tree
      end

      def delete_child(tree, index)
        tree.delete_child(index)
      end

      def each_child(tree)
        block_given? or return enum_for(:each_child, tree)
        for i in 0...child_count(tree)
          yield(child_of(tree, i))
        end
        tree
      end

      def each_ancestor(tree, include_tree = true)
        block_given? or return enum_for(:each_ancestor, tree, include_tree)
        if include_tree
          begin yield(tree) end while tree = parent_of(tree)
        else
          while tree = parent_of(tree) do yield(tree) end
        end
      end

      def flat_list?(tree)
        tree.flat_list?
      end

      def empty?(tree)
        child_count(tree).zero?
      end

      def parent(tree)
        tree.parent
      end

      def replace_children(parent, start, stop, replacement)
        parent and parent.replace_children(start, stop, replacement)
      end

      def rule_post_processing(root)
        if root and root.flat_list?
          case root.child_count
          when 0 then root = nil
          when 1
            root = root.child(0).detach
          end
        end
        root
      end

      def set_child_index(tree, index)
        tree.child_index = index
      end

      def set_parent(tree, parent)
        tree.parent = parent
      end

      def set_token_boundaries(tree, start_token = nil, stop_token = nil)
        return unless tree

        start = stop = 0
        start_token and start = start_token.index
        stop_token  and stop  = stop_token.index
        tree.start_index = start
        tree.stop_index = stop
        tree
      end

      def text_of(tree)
        tree.text
      rescue StandardError
        nil
      end

      def token(tree)
        tree.is_a?(CommonTree) ? tree.token : nil
      end

      def token_start_index(tree)
        tree ? tree.token_start_index : -1
      end

      def token_stop_index(tree)
        tree ? tree.token_stop_index : -1
      end

      def type_name(tree)
        tree.name
      rescue StandardError
        'INVALID'
      end

      def type_of(tree)
        tree.type
      rescue StandardError
        INVALID_TOKEN_TYPE
      end

      def unique_id(node)
        node.hash
      end
    end

    # rdoc ANTLR3::AST::CommonTreeAdaptor
    #
    # The default tree adaptor used by ANTLR-generated tree code. It, of course,
    # builds and manipulates CommonTree nodes.
    #

    class CommonTreeAdaptor
      extend ClassMacros
      include TreeAdaptor
      include ANTLR3::Constants

      def initialize(token_class = ANTLR3::CommonToken)
        @token_class = token_class
      end

      def create_flat_list
        create_with_payload(nil)
      end
      alias create_flat_list! create_flat_list

      def become_root(new_root, old_root)
        new_root = create(new_root) if new_root.is_a?(Token)
        old_root or return(new_root)

        new_root = create_with_payload(new_root) unless new_root.is_a?(CommonTree)
        if new_root.flat_list?
          count = new_root.child_count
          if count == 1
            new_root = new_root.child(0)
          elsif count > 1
            raise TreeInconsistency.multiple_roots!
          end
        end

        new_root.add_child(old_root)
        new_root
      end

      def create_from_token(token_type, from_token, text = nil)
        from_token = from_token.dup
        from_token.type = token_type
        from_token.text = text.to_s if text
        create_with_payload(from_token)
      end

      def create_from_type(token_type, text)
        from_token = create_token(token_type, DEFAULT_CHANNEL, text)
        create_with_payload(from_token)
      end

      def create_error_node(input, start, stop, exc)
        CommonErrorNode.new(input, start, stop, exc)
      end

      def create_with_payload(payload)
        CommonTree.new(payload)
      end

      def create(*args)
        n = args.length
        if n == 1 and args.first.is_a?(Token) then create_with_payload(args[0])
        elsif n == 2 and args.first.is_a?(Integer) and args[1].is_a?(String)
          create_from_type(*args)
        elsif n >= 2 and args.first.is_a?(Integer)
          create_from_token(*args)
        else
          sig = args.map { |f| f.class }.join(', ')
          raise TypeError, "No create method with this signature found: (#{sig})"
        end
      end

      creation_methods = %w[
        create_from_token create_from_type
        create_error_node create_with_payload
        create
      ]

      for method_name in creation_methods
        bang_method = method_name + '!'
        alias_method(bang_method, method_name)
        deprecate(bang_method, "use method ##{method_name} instead")
      end

      def rule_post_processing(root)
        if root and root.flat_list?
          if root.empty? then root = nil
          elsif root.child_count == 1 then root = root.first.detach
          end
        end
        root
      end

      def empty?(tree)
        tree.empty?
      end

      def each_child(tree, &block)
        block_given? or return enum_for(:each_child, tree)
        tree.each(&block)
      end
    end

    ####################################################################################################
    ########################################### Tree Streams ###########################################
    ####################################################################################################

    # rdoc ANTLR3::AST::TreeNodeStream
    #
    # TreeNodeStreams flatten two-dimensional tree structures into one-dimensional
    # sequences. They preserve the two-dimensional structure of the tree by inserting
    # special +UP+ and +DOWN+ nodes.
    #
    # Consider a hypothetical tree:
    #
    #   [A]
    #    +--[B]
    #    |   +--[C]
    #    |   `--[D]
    #    `--[E]
    #        `--[F]
    #
    # A tree node stream would serialize the tree into the following sequence:
    #
    #   A DOWN B DOWN C D UP E DOWN F UP UP EOF
    #
    # Other than serializing a tree into a sequence of nodes, a tree node stream
    # operates similarly to other streams. They are commonly used by tree parsers as
    # the main form of input. #peek, like token streams, returns the type of the token
    # of the next node. #look returns the next full tree node.
    #

    module TreeNodeStream
      extend ClassMacros
      include Stream
      include Constants

      abstract :at
      abstract :look
      abstract :tree_source
      abstract :token_stream
      abstract :tree_adaptor
      abstract :unique_navigation_nodes=
      abstract :to_s
      abstract :replace_children
    end

    # rdoc ANTLR3::AST::CommonTreeNodeStream
    #
    # An implementation of TreeNodeStream tailed for streams based on CommonTree
    # objects. CommonTreeNodeStreams are the default input streams for tree parsers.
    #

    class CommonTreeNodeStream
      include TreeNodeStream

      attr_accessor :token_stream
      attr_reader :adaptor, :position, :last_marker

      def initialize(*args)
        options = args.last.is_a?(::Hash) ? args.pop : {}
        case n = args.length
        when 1
          @root = args.first
          @token_stream = @adaptor = @nodes = @down = @up = @eof = nil
        when 2
          @adaptor, @root = args
          @token_stream = @nodes = @down = @up = @eof = nil
        when 3
          parent, start, stop = *args
          @adaptor = parent.adaptor
          @root = parent.root
          @nodes = parent.nodes[start...stop]
          @down = parent.down
          @up = parent.up
          @eof = parent.eof
          @token_stream = parent.token_stream
        when 0
          raise ArgumentError, 'wrong number of arguments (0 for 1)'
        else raise ArgumentError, "wrong number of arguments (#{n} for 3)"
        end
        @adaptor ||= options.fetch(:adaptor) { CommonTreeAdaptor.new }
        @token_stream ||= options[:token_stream]
        @down  ||= options.fetch(:down) { @adaptor.create_from_type(DOWN, 'DOWN') }
        @up    ||= options.fetch(:up)   { @adaptor.create_from_type(UP, 'UP') }
        @eof   ||= options.fetch(:eof)  { @adaptor.create_from_type(EOF, 'EOF') }
        @nodes ||= []

        @unique_navigation_nodes = options.fetch(:unique_navigation_nodes, false)
        @position = -1
        @last_marker = nil
        @calls = []
      end

      def fill_buffer(tree = @root)
        @nodes << tree unless nil_tree = @adaptor.flat_list?(tree)
        unless @adaptor.empty?(tree)
          add_navigation_node(DOWN) unless nil_tree
          @adaptor.each_child(tree) { |c| fill_buffer(c) }
          add_navigation_node(UP) unless nil_tree
        end
        @position = 0 if tree == @root
        self
      end

      def node_index(node)
        @position == -1 and fill_buffer
        @nodes.index(node)
      end

      def add_navigation_node(type)
        navigation_node =
          case type
          when DOWN
            has_unique_navigation_nodes? ? @adaptor.create_from_type(DOWN, 'DOWN') : @down
          else
            has_unique_navigation_nodes? ? @adaptor.create_from_type(UP, 'UP') : @up
          end
        @nodes << navigation_node
      end

      def at(index)
        @position == -1 and fill_buffer
        @nodes.at(index)
      end

      def look(k = 1)
        @position == -1 and fill_buffer
        k == 0 and return nil
        k < 0 and return look_behind(-k)

        absolute = @position + k - 1
        @nodes.fetch(absolute, @eof)
      end

      def current_symbol
        look
      end

      def look_behind(k = 1)
        k == 0 and return nil
        absolute = @position - k
        (absolute < 0 ? nil : @nodes.fetch(absolute, @eof))
      end

      def tree_source
        @root
      end

      def source_name
        token_stream.source_name
      end

      def tree_adaptor
        @adaptor
      end

      def has_unique_navigation_nodes?
        @unique_navigation_nodes
      end
      attr_writer :unique_navigation_nodes

      def consume
        @position == -1 and fill_buffer
        node = @nodes.fetch(@position, @eof)
        @position += 1
        node
      end

      def peek(i = 1)
        @adaptor.type_of look(i)
      end

      alias >> peek
      def <<(k)
        self >> -k
      end

      def mark
        @position == -1 and fill_buffer
        @last_marker = @position
        @last_marker
      end

      def release(marker = nil)
        # do nothing?
      end

      alias index position

      def rewind(marker = @last_marker, _release = true)
        seek(marker)
      end

      def seek(index)
        @position == -1 and fill_buffer
        @position = index
      end

      def push(index)
        @calls << @position
        seek(index)
      end

      def pop
        pos = @calls.pop and seek(pos)
        pos
      end

      def reset
        @position = 0
        @last_marker = 0
        @calls = []
      end

      def replace_children(parent, start, stop, replacement)
        parent and @adaptor.replace_children(parent, start, stop, replacement)
      end

      def size
        @position == -1 and fill_buffer
        @nodes.length
      end

      def inspect
        @position == -1 and fill_buffer
        @nodes.map { |nd| @adaptor.type_name(nd) }.join(' ')
      end

      def extract_text(start = nil, stop = nil)
        start.nil? || stop.nil? and return nil
        @position == -1 and fill_buffer

        if @token_stream
          from = @adaptor.token_start_index(start)
          to =
            case @adaptor.type_of(stop)
            when UP then @adaptor.token_stop_index(start)
            when EOF then to = @nodes.length - 2
            else @adaptor.token_stop_index(stop)
            end
          return @token_stream.extract_text(from, to)
        end

        buffer = ''
        for node in @nodes
          if node == start ... node == stop # <-- hey look, it's the flip flop operator
            buffer << @adaptor.text_of(node) # || ' ' << @adaptor.type_of( node ).to_s )
          end
        end
        buffer
      end

      def each
        @position == -1 and fill_buffer
        block_given? or return enum_for(:each)
        for node in @nodes do yield(node) end
        self
      end

      include Enumerable

      def to_a
        @nodes.dup
      end

      def extract_text(start = nil, stop = nil)
        @position == -1 and fill_buffer
        start ||= @nodes.first
        stop  ||= @nodes.last

        if @token_stream
          case @adaptor.type_of(stop)
          when UP
            stop_index = @adaptor.token_stop_index(start)
          when EOF
            return extract_text(start, @nodes[- 2])
          else
            stop_index = @adaptor.token_stop_index(stop)
          end

          start_index = @adaptor.token_start_index(start)
          @token_stream.extract_text(start_index, stop_index)
        else
          start_index = @nodes.index(start) || @nodes.length
          stop_index  = @nodes.index(stop)  || @nodes.length

          @nodes[start_index..stop_index].map do |n|
            @adaptor.text_of(n) or ' ' + @adaptor.type_of(n).to_s
          end.join('')

        end
      end

      alias to_s extract_text

      # private
      #
      #  def linear_node_index( node )
      #    @position == -1 and fill_buffer
      #    @nodes.each_with_index do |n, i|
      #      node == n and return(i)
      #    end
      #    return -1
      #  end
    end

    # rdoc ANTLR3::AST::RewriteRuleElementStream
    #
    # Special type of stream that is used internally by tree-building and tree-
    # rewriting parsers.
    #

    class RewriteRuleElementStream # < Array
      extend ClassMacros
      include Error

      def initialize(adaptor, element_description, elements = nil)
        @cursor = 0
        @single_element = nil
        @elements = nil
        @dirty = false
        @element_description = element_description
        @adaptor = adaptor
        if elements.instance_of?(Array)
          @elements = elements
        else
          add(elements)
        end
      end

      def reset
        @cursor = 0
        @dirty = true
      end

      def add(el)
        return(nil) unless el

        if !el
          nil
        elsif @elements
          @elements << el
        elsif @single_element.nil?
          @single_element = el
        else
          @elements = [@single_element, el]
          @single_element = nil
          @elements
        end
      end

      def next_tree
        return dup(__next__) if @dirty or @cursor >= length && length == 1

        __next__
      end

      abstract :dup

      def to_tree(el)
        el
      end

      def has_next?
        (@single_element && @cursor < 1 or
               @elements && @cursor < @elements.length)
      end

      def size
        @single_element and return 1
        @elements and return @elements.length
        0
      end

      alias length size

      private

      def __next__
        l = length
        case
        when l.zero?
          raise Error::RewriteEmptyStream, @element_description
        when @cursor >= l
          l == 1 and return to_tree(@single_element)
          raise RewriteCardinalityError, @element_description
        when @single_element
          @cursor += 1
          to_tree(@single_element)
        else
          out = to_tree(@elements.at(@cursor))
          @cursor += 1
          out
        end
      end
    end

    # rdoc ANTLR3::AST::RewriteRuleTokenStream
    #
    # Special type of stream that is used internally by tree-building and tree-
    # rewriting parsers.
    #
    class RewriteRuleTokenStream < RewriteRuleElementStream
      def next_node
        @adaptor.create_with_payload(__next__)
      end

      alias next __next__
      public :next

      def dup(_el)
        raise TypeError, "dup can't be called for a token stream"
      end
    end

    # rdoc ANTLR3::AST::RewriteRuleSubtreeStream
    #
    # Special type of stream that is used internally by tree-building and tree-
    # rewriting parsers.
    #

    class RewriteRuleSubtreeStream < RewriteRuleElementStream
      def next_node
        return @adaptor.copy_node(__next__) if @dirty or @cursor >= length && length == 1

        __next__
      end

      def dup(el)
        @adaptor.copy_tree(el)
      end
    end

    # rdoc ANTLR3::AST::RewriteRuleNodeStream
    #
    # Special type of stream that is used internally by tree-building and tree-
    # rewriting parsers.
    #

    class RewriteRuleNodeStream < RewriteRuleElementStream
      alias next_node __next__
      public :next_node
      def to_tree(el)
        @adaptor.copy_node(el)
      end

      def dup(_el)
        raise TypeError, "dup can't be called for a node stream"
      end
    end
  end

  include AST
end
