#!/usr/bin/env python

from subprocess import run

prompt = "Set Audio Sink:"
rofi_options = "-theme ~/.config/rofi/select_profiles.rasi"
friendly_names = {
    "GSX 1000 Main Audio analog-output-surround71":" GSX 1000 Main",
    "GSX 1000 Main Audio analog-chat-output": " GSX 1000 Chat",
    "StudioLive AR8c Analog Surround 4.0": "蓼 StudioLive AR8c",
    "WH-1000XM5": "󰥰 WH-1000XM5",
}

sinks = run("pactl list sinks", shell = True, capture_output=True)

sinks_str = sinks.stdout.decode()
lines = sinks_str.split("\n")

def contains(s, l):
    for x in l:
        if x in s:
            return True
    return False

options = [i.strip("\t") for i in lines if contains(i, ["Name:", "Description:"])]
options = [options[i:i+2] for i in range(0,len(options)-1, 2)]

options_dict = {}
for o in options:
    name = o[0].split("Name: ")[1]
    desc = o[1].split("Description: ")[1]
    if desc in friendly_names:
        options_dict[friendly_names[desc]] = name
    elif "HDMI" in desc:
        options_dict["﴿ HDMI"+desc.split("HDMI")[1].strip(")")] = name
    else:
        options_dict[desc] = name
options_dict[" Cancel"]=""

menu_nrows = len(options_dict)
menu_string = "\n".join([k for k in options_dict])

launcher=f"rofi -dmenu -i -l {menu_nrows} -p '{prompt}' {rofi_options}"

run_str = f"echo '{menu_string}' | {launcher}"
selection = run(run_str, shell = True, capture_output=True).stdout.decode()

selection_device = options_dict[selection.strip("\n")]
if selection_device:
    cmd = f"pactl set-default-sink {selection_device}"
    run(cmd, shell = True)
