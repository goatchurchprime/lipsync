# lipsync
Demo of OVRLipSync

This project runs in Godot4.3 and uses a version of https://github.com/goatchurchprime/two-voip-godot-4 
that is compiled against OVRLipSync, a library released by Oculus only on Windows and Android for 
generating visemes from audio WAV data.

On a platform without OVRLipSync you can tie the audio volume to a chosen viseme in the dropdown 
to animate the face.

There are bugs in the Godot Android AudioStreamMicrophone that intermittently turn the MicWorking off.
Sometimes it makes an infinite loop of sound:  https://github.com/godotengine/godot/issues/95120

![image](https://github.com/user-attachments/assets/783fda81-a89f-4de6-b68f-0c725ff8df43)
