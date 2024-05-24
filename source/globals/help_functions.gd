extends Node


func format_integer(number: int) -> String:
	var number_s = str(number)
	var result: PackedStringArray = []
	if number_s.length() < 4:
		return number_s
	else:
		while number_s.length() > 0:
			if number_s.length() < 4:
				result.append(number_s)
				number_s = ""
			else:
				result.append(number_s.substr(number_s.length() - 3, 3))
				number_s = number_s.substr(0, number_s.length() - 3)
	result.reverse()
	var result_s = ""
	for r in result:
		result_s += r + " "
	return result_s.substr(0, result_s.length() - 1)
