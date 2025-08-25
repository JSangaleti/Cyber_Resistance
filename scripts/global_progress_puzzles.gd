extends Node

var password_parts: Array[String] = []

func add_password_part(part: String) -> void:
	if part not in password_parts:
		password_parts.append(part)

func get_full_password() -> String:
	return "".join(password_parts)
