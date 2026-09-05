extends RefCounted

# 对应 HAR 中 jKstra 的 Graph, DijkstraIterator 和 PriorityQueue.
# 邻接表使用顶点编号, 避免 GDScript 引用计数对象形成循环引用.
static func original_static_get(key):
	if key == "Graph": return Graph
	if key == "algos": return {"Dijkstra": Dijkstra}
	return null

class Graph extends RefCounted:
	var vertices: Array = []
	var edges: Array = []
	var outgoing: Array = []

	func addVertex(data):
		var vertex := {"data": data, "index": vertices.size()}
		vertices.append(vertex)
		outgoing.append([])
		return vertex

	func addEdge(from, to, data):
		var edge := {"from": from, "to": to, "data": data}
		edges.append(edge)
		outgoing[from.index].append(edge)
		return edge

	func forEachVertex(action):
		for vertex in vertices: action.call(vertex)

class PriorityQueue extends RefCounted:
	var heap: Array = []

	func insert(item, key):
		heap.append({"item": item, "key": key})
		bubble_up(heap.size() - 1)

	func bubble_up(index: int):
		var element = heap[index]
		while index > 0:
			var parent_index := int(floor((index + 1) / 2.0)) - 1
			var parent = heap[parent_index]
			if element.key - parent.key > 0: break
			heap[parent_index] = element
			heap[index] = parent
			index = parent_index

	func sink_down(index: int):
		var length := heap.size()
		var element = heap[index]
		while true:
			var right := (index + 1) * 2
			var left := right - 1
			var swap := -1
			if left < length:
				if heap[left].key - element.key < 0: swap = left
				if right < length:
					if (swap == -1 or heap[right].key - heap[left].key < 0) and heap[right].key - element.key < 0: swap = right
			if swap == -1: break
			heap[index] = heap[swap]
			heap[swap] = element
			index = swap

	func pop():
		if heap.is_empty(): return null
		var element = heap[0]
		var end = heap.pop_back()
		if not heap.is_empty():
			heap[0] = end
			sink_down(0)
		return element

	func update_key(item, key):
		for index in range(heap.size()):
			if heap[index].item == item:
				var old = heap[index].key
				heap[index].key = key
				if key < old: bubble_up(index)
				else: sink_down(index)
				return

class Dijkstra extends RefCounted:
	var graph

	func _init(value):
		graph = value

	func shortestPath(source, target, options):
		var flags: Array = []
		flags.resize(graph.vertices.size())
		for i in range(flags.size()): flags[i] = {"state": 0, "gCost": 0.0, "fCost": 0.0, "inc": null}
		var queue := PriorityQueue.new()
		queue.insert(source.index, 0.0)
		flags[source.index].state = 1
		while not queue.heap.is_empty():
			var u = queue.pop().item
			var cost = flags[u].gCost
			flags[u].state = 2
			for edge in graph.outgoing[u]:
				var v = edge.to.index
				if flags[v].state == 2: continue
				var next_cost = cost + options.edgeCost.call(edge)
				if flags[v].state != 1:
					queue.insert(v, next_cost)
				elif next_cost < flags[v].fCost:
					queue.update_key(v, next_cost)
				else:
					continue
				flags[v] = {"state": 1, "gCost": next_cost, "fCost": next_cost, "inc": edge}
			if flags[target.index].state == 2:
				var result := []
				var end = target.index
				while flags[end].inc != null:
					var edge = flags[end].inc
					result.append(edge)
					end = edge.from.index
				result.reverse()
				return result
		return null
