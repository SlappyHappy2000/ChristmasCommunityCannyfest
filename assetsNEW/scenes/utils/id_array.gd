class_name idArray

var arr := [
	[],
	[]
]

#Constructs a default value for use in arr_expand()
var constructor_func

func _init(function):
	constructor_func = function

#Checks if it's an integer or a character
func get_index(id : String):
	if id.is_valid_int():
		return [0, id.to_int()]
	else:
		var temp = to_int_26(id)
		assert(temp != null, "You are an idiot!")
		return [1, temp]

#Converts the character into a valid integer that can be used in the array
func to_int_26(str : String):
	var ascii = str.to_upper().to_ascii_buffer()
	var sum := 0
	for i in range(0, ascii.size()):
		if ascii[i] < 65 or ascii[i] > 90:
			return null
		sum += (ascii[i] - 65) * pow(26, i)
	return sum

func arr_set(id : String, set_to):
	var address = get_index(id)
	arr_expand(address)
	arr[address[0]][address[1]] = set_to

func arr_get(id : String):
	var address = get_index(id)
	arr_expand(address)
	return arr[address[0]][address[1]]

#Expands the array if the address does not exist yet
func arr_expand(address : Array):
	while arr[address[0]].size() <= address[1]:
		arr[address[0]].append(constructor_func.call())

func arr_flatten():
	var arr_flat := []
	for i in arr:
		arr_flat.append_array(i)
	return arr_flat

func arr_flatten_recursive():
	var arr_flat := []
	for i in arr:
		for j in i:
			arr_flat.append_array(j.arr_flatten())
	return arr_flat

func arr_merge(other : idArray):
	for i in range(other.arr.size()):
		arr_expand([i, other.arr[i].size()])
		for j in range(other.arr[i].size()):
			if other.arr[i][j] != null:
				arr[i][j] = other.arr[i][j]

func size():
	return arr[0].size() + arr[1].size()
