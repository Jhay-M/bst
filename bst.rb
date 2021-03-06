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

  def insert(val, node = root)
    return node = create_node(val) if node.nil?

    if val < node.data
      node.left = insert(val, node.left)
    elsif val > node.data
      node.right = insert(val, node.right)
    end
    node
  end

  def delete(val, node = root)
    return node if node.nil?

    if val < node.data
      node.left = delete(val, node.left)
    elsif val > node.data
      node.right = delete(val, node.right)
    else
      return node.right if node.left.nil?
      return node.left if node.right.nil?

      node.data = min_value(node.right)
      node.right = delete(node.data, node.right)
    end
    node
  end

  def min_value(node)
    minv = node.data
    until node.left.nil?
      minv = node.left.data
      node = node.left
    end
    minv
  end

  def find(val, node = root)
    return 'Not Found' if node.nil?
    return node if val == node.data

    if val < node.data
      find(val, node.left)
    elsif val > node.data
      find(val, node.right)
    end
  end

  def level_order(node = root)
    queue = []
    queue << node
    result = traverse(queue)
    result.map!(&:data)
  end

  def traverse(arr, arr2 = [])
    return arr2 if arr.empty?

    arr2 << arr[0]
    arr << arr[0].left unless arr[0].left.nil?
    arr << arr[0].right unless arr[0].right.nil?
    arr.shift
    traverse(arr, arr2)
  end

  def preorder(node = root, arr = [])
    return if node.nil?

    arr << node.data
    preorder(node.left, arr)
    preorder(node.right, arr)
    arr
  end

  def inorder(node = root, arr = [])
    return if node.nil?

    inorder(node.left, arr)
    arr << node.data
    inorder(node.right, arr)
    arr
  end

  def postorder(node = root, arr = [])
    return if node.nil?

    postorder(node.left, arr)
    postorder(node.right, arr)
    arr << node.data
    arr
  end

  def depth(val, node = root)
    sum = 1
    until val == node.data
      node = node.left if val < node.data
      node = node.right if val > node.data
      sum += 1
    end
    sum
  end

  def height(val)
    node = find(val)
    sum = 0
    until node.nil?
      node = node.right
      sum += 1
    end
    sum
  end

  def balanced?(node = root)
    return nil if node.nil?
    return false if height(node.right.data) - height(node.left.data) > 1

    true
  end

  def rebalance(node = root)
    new_arr = level_order(node)
    @arr = new_arr
    @root = build_tree(arr)
  end

  def pretty_print(node = root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

gen_arr = Array.new(15) { rand(1..100) }
jhay = Tree.new(gen_arr)
p jhay.balanced?
p "Level Order Sequence: #{jhay.level_order}"
p "Pre-Order Sequence: #{jhay.preorder}"
p "In-Order Sequence: #{jhay.inorder}"
p "Post-Order Sequence: #{jhay.postorder}"
jhay.insert(105)
jhay.insert(340)
jhay.insert(273)
p jhay.balanced?
jhay.rebalance
p jhay.balanced?
p "Level Order Sequence: #{jhay.level_order}"
p "Pre-Order Sequence: #{jhay.preorder}"
p "In-Order Sequence: #{jhay.inorder}"
p "Post-Order Sequence: #{jhay.postorder}"
jhay.pretty_print
