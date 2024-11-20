# various-scripts
Collection of various scripts

ConvertToJPEG
  uses IrfanView cmd line to convert HEIC or pdf's (or any other file compatible)

CreateBCKcopy and CreateBCKzip
  they copy the selected file(s) in a _bck subfolder and append timestamp.
  in the zip case, keeps outside the zip file only the last backupped version

timestamp and timestamp filename
  these .bat get triggered by a key combination (desktop shortcut with a key combination), to copy in the clipboard the current timestamp with my choosen format

rename scan
  the .bat triggered by contextual menu, launches a python script on a remote NAS, passing the folder details as argument.
  the python script looks for date/time patterns and extra text, trying to rename the file with my choosen timestamp format and maintaining the rest of the filename/extension

Reset WiFi and ToggleAC
  as my laptop's integrated wifi card sometimes is buggy or has issues with the wifi autoconfig, as it often cause lag spikes.
