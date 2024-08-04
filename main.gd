extends Control

var audioopuschunkedeffect : AudioEffectOpusChunked

func _ready():
	var microphoneidx = AudioServer.get_bus_index("MicrophoneBus")
	audioopuschunkedeffect = AudioServer.get_bus_effect(microphoneidx, 0)
	for vs in $VisemeSystem.visemes:
		$VisSelect.add_item(vs)
		
func _process(delta):
	$MicWorking.button_pressed = $AudioStreamMicrophone.playing
	var n = 0
	while audioopuschunkedeffect.chunk_available():
		var chunkv1 = audioopuschunkedeffect.chunk_max()
		var chunkv2 = audioopuschunkedeffect.chunk_rms()
		$ChunkMax.value = chunkv2*100
		if $AudioStreamMicrophone.playing and audioopuschunkedeffect.chunk_to_lipsync() != -1:
			var vv = audioopuschunkedeffect.read_visemes();
			$VisemeSystem.set_visemes(vv)
		else:
			if $VisSelect.selected != -1 and $VisSelect.selected != 0:
				var vv = $VisemeSystem.current_slider_values()
				vv[$VisSelect.selected] = chunkv2
				$VisemeSystem.set_visemes(vv)
		audioopuschunkedeffect.drop_chunk()
		n += 1
	if n > 5:
		print("Suspiciously many chunks cleared ", n)
	
func _on_mic_working_toggled(toggled_on):
	print("_on_mic_working_toggled ", $AudioStreamMicrophone.playing, " to ", toggled_on)
	if toggled_on:
		if not $AudioStreamMicrophone.playing:
			$AudioStreamMicrophone.play()
	else:
		if $AudioStreamMicrophone.playing:
			$AudioStreamMicrophone.stop()
