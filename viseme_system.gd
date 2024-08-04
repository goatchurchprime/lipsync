extends Control


var prevviseme = 0
#var visemes = [ "sil", "PP", "FF", "TH", "DD", "kk", "CH", "SS", "nn", "RR", "aa", "E", "ih", "oh", "ou", "LA" ]
var visemes = [ "sil", "PP", "FF", "TH", "DD", "kk", "CH", "SS", "nn", "RR", "aa", "E", "I", "O", "U", "LA" ]

var vmeshes = [ ]
var blshapes = [ ]

func _ready():
	var vm = $VBox/Viseme
	$VBox.remove_child(vm)
	for vs in visemes:
		var v = vm.duplicate()
		v.name = "Viseme_%s" % vs
		v.get_node("Label").text = vs
		v.get_node("HSlider").connect("value_changed", slider_value_changed)
		$VBox.add_child(v)

	var m = get_node("../TextureRect/SubViewport/Avatar/readyplayerme_avatar/Armature/Skeleton3D/Wolf3D_Head")
	vmeshes.append(m)
	print(m.get_blend_shape_count())
	for vs in visemes:
		blshapes.append(m.find_blend_shape_by_name("viseme_%s" % vs))
	print(blshapes)
	vmeshes.append(get_node("../TextureRect/SubViewport/Avatar/readyplayerme_avatar/Armature/Skeleton3D/Wolf3D_Teeth"))

		
func set_blshapes(vv):
	for m in vmeshes:
		for i in range(len(vv)):
			if blshapes[i] != -1:
				m.set_blend_shape_value(blshapes[i], vv[i])

func current_slider_values():
	var vv = [ ]
	for i in range(len(visemes)):
		vv.push_back($VBox.get_child(i).get_node("HSlider").value * 0.01)
	return vv

func slider_value_changed(value):
	set_blshapes(current_slider_values())

func set_visemes(vv):
	for i in range(len(visemes)):
		$VBox.get_child(i).get_node("HSlider").value = vv[i]*100
	#print("sefind_blend_shape_by_namet_visemes ", vv)
