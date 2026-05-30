extends Node2D

enum LogType
{
	STATE_CHANGE,
	LOGGING,
	VALUE_CHECK,
	WARNING,
	ERROR
}

func _ready() -> void:
	pass

func log(message: String, log_type: LogType) -> void:
	var header = ""
	var color = ""
	match log_type:
		LogType.STATE_CHANGE:
			header = "STATE_CHANGE"
			color = "[color=green]"
		LogType.LOGGING:
			header = "LOGGING"
		LogType.VALUE_CHECK:
			header = "VALUE_CHECK"
			color = "[color=lightblue]"
		LogType.WARNING:
			header = "WARNING"
			color = "[color=orange]"
		LogType.ERROR:
			header = "ERROR"
			color = "[color=red]"
			
	print_rich(color, header, ": " , message)
