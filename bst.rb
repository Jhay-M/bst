class Node
  include Comparable
  attr_accessor :data, :left, :right

  def <=>(other)
    data <=> other.data
  end

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end
end

class Tree
  attr_accessor :arr, :root

  def initialize(arr)
    @arr = arr
    @root = build_tree(arr)
  end

  def build_tree(arr)
    new_arr = sort(arr).uniq
    start = 0
    last = new_arr.size - 1
    make_tree(new_arr, start, last)
  end

  def create_node(var)
    Node.new(var)
  end

  def sort(arr)
    size = arr.length
    half_size = size / 2

    return arr if size < 2

    left = sort(arr[0, half_size])
    right = sort(arr[half_size..size])
    merge(left, right)
  end

  def merge(left, right)
    return right if left.empty?
    return left if right.empty?

    left[0] < right[0] ? [left[0]] + merge(left[1..-1], right) : [right[0]] + merge(left, right[1..-1])
  end

  def make_tree(arr, start, last)
    return nil if start > last

    mid = (start + last) / 2

    tree_root = create_node(arr[mid])
    tree_root.left = make_tree(arr, start, mid - 1)
    tree_root.right = make_tree(arr, mid + 1, last)
    tree_root
  end
end

jhay = Tree.new([9, 3, 5, 7, 2, 1, 8, 4, 6, 1])
p jhay
