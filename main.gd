extends Control

var audioopuschunkedeffect : AudioEffectOpusChunked

func _ready():
	var microphoneidx = AudioServer.get_bus_index("MicrophoneBus")
	audioopuschunkedeffect = AudioServer.get_bus_effect(microphoneidx, 0)
	for vs in $VisemeSystem.visemes:
		$VisSelect.add_item(vs)
		
const chunkresampled = true
func _process(delta):
	$MicWorking.button_pressed = $AudioStreamMicrophone.playing
	var n = 0
	while audioopuschunkedeffect.chunk_available():
		var chunkv1 = audioopuschunkedeffect.chunk_max(false, chunkresampled)
		var chunkv2 = audioopuschunkedeffect.chunk_max(true, chunkresampled)
		$ChunkMax.value = chunkv2*100
		if $AudioStreamMicrophone.playing and audioopuschunkedeffect.chunk_to_lipsync(chunkresampled) != -1:
			var vv = audioopuschunkedeffect.read_visemes();
			if $VisemeBinary.button_pressed:
				var maxi = 0
				for i in range(1, len(vv)-1):
					if vv[i] > vv[maxi]:
						maxi = i
				for i in range(len(vv)-1):
					vv[i] = 1 if i == maxi else 0
			$VisemeSystem.set_visemes(vv)

			# final three values are:
			#visemes[ovrLipSyncViseme_Count] = ovrlipsyncframe.laughterScore;
			#visemes[ovrLipSyncViseme_Count+1] = ovrlipsyncframe.frameDelay;
			#visemes[ovrLipSyncViseme_Count+2] = ovrlipsyncframe.frameNumber;

			$LaughingIcon.modulate.a = vv[-3]
			$LaughingIcon.visible = (vv[-3] > 0.1)

			#print("frame delay ", vv[-2], " n ", vv[-1])


		else:
			if $VisSelect.selected != -1 and $VisSelect.selected != 0:
				var vv = $VisemeSystem.current_slider_values()
				vv[$VisSelect.selected] = chunkv2
				$VisemeSystem.set_visemes(vv)
			$LaughingIcon.visible = false
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
