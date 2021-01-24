extends Node

func _on_finished():
    var player = AudioStreamPlayer.new()
    self.add_child(player)
    player.stream = load("res://Audio/Aisle of the Pandemic.wav")
    player.volume_db = -12 
    player.play()
