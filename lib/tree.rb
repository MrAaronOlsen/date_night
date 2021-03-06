require_relative 'node'
require_relative 'leaf'

class Tree

  attr_reader :head

  def initialize
    @head = Leaf.new
  end

  def insert(key_or_node, value = nil)
    node = node_from(key_or_node, value)
    @head = head.insert(node)
    depth_of(node)
  end

  def delete(value)
    deleted = @head.delete(value)
    remove(deleted)
  end

  def fetch_node(value)
    @head.fetch_node(value)
  end

  def include?(value)
    @head.include?(value)
  end

  def depth_of(node)
    @head.depth_of(node)
  end

  def max
    @head.max(0)
  end

  def min
    @head.min(0)
  end

  def leaves
    @head.leaves(0)
  end

  def health(level = 0)
    total_nodes = count_nodes

    @head.health(level).map do |report|
      report << ((report[1].to_f/total_nodes) * 100).floor
    end
  end

  def count_nodes
    @head.count_children
  end

  def sort
    @head.sort(Array.new)
  end

  def load(file)
    lines = parse(file)
    inserts = 0
    lines.each do |node|
      insert(node[0], node[1])
      inserts+=1
    end
    inserts
  end

  private
  def parse(file)
    File.readlines(file).map do |line|
      i = line.index(",")
      [line[i+2..-1].chomp, line[0...i].to_i]
    end
  end

  def remove(node)
    @head.remove_child(node)
  end

  def node_from(key_or_node, value = nil)
    if key_or_node.is_a? Node
      key_or_node
    else
      Node.new(key_or_node, value)
    end
  end

end
