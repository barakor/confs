#!/usr/bin/env python

from subprocess import run

prompt = "Monitor Select:"
rofi_options = "-theme ~/.config/rofi/select_profiles.rasi"


options_dict =  {
  " Monitor": "bash ~/.screenlayout/monitor_only.sh",
  "蠟 Salon": "bash ~/.screenlayout/salon_only.sh; pactl set-default-sink alsa_output.pci-0000_02_00.1.hdmi-stereo",
  " Clones": "bash ~/.screenlayout/clones.sh"
}

options_dict[" Cancel"]=""

menu_nrows = len(options_dict)
menu_string = "\n".join([k for k in options_dict])

launcher=f"rofi -dmenu -i -l {menu_nrows} -p '{prompt}' {rofi_options}"

run_str = f"echo '{menu_string}' | {launcher}"
selection = run(run_str, shell = True, capture_output=True).stdout.decode()

selection_device = options_dict[selection.strip("\n")]
if selection_device:
    cmd = f"{selection_device}"
    run(cmd, shell = True)
