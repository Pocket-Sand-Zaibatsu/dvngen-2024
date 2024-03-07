extends Node
class_name BinaryHeap

var _contents: Array[Vector3i] = []

func size() -> int:
	return _contents.size()

func clear():
	_contents.clear()

func insert(item: Vector2i, priority: int) -> void:
	_contents.push_back(Vector3i(item.x, item.y, priority))
	_up_heap(_contents.size() - 1)

func extract():
	if is_empty():
		return null
	var result: Vector3i = _contents.pop_front()
	if not is_empty():
		_contents.push_front(_contents.pop_back())
		_down_heap(0)
	return Vector2i(result.x, result.y)

func is_empty() -> bool:
	return _contents.is_empty()

func _get_parent(index: int) -> int:
	return int(float(index - 1) / 2)

func _left_child(index: int) -> int:
	return (2 * index) + 1

func _right_child(index: int) -> int:
	return (2 * index) + 2

func _swap(a_index: int, b_index: int) -> void:
	var temp: Vector3i = _contents[a_index]
	_contents[a_index] = _contents[b_index]
	_contents[b_index] = temp

func _up_heap(index: int) -> void:
	var parent_index: int = _get_parent(index)
	if _contents[parent_index].z > _contents[index].z:
		_swap(index, parent_index)
		_up_heap(parent_index)

func _down_heap(index: int) -> void:
	var left_index: int = _left_child(index)
	var right_index: int = _right_child(index)
	var smallest: int = index
	if right_index < _contents.size() and _contents[right_index].z < _contents[smallest].z:
		smallest = right_index
	if left_index < _contents.size() and _contents[left_index].z < _contents[smallest].z:
		smallest = left_index
	if smallest != index:
		_swap(index, smallest)
		_down_heap(smallest)
