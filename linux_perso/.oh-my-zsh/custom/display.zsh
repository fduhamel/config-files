# Switches between multiple monitor layouts.

# Sinks can be found with: pactl list |grep "Sortie audio" -2
# Switches video and audio to a dual screen with TV cloned from monitor, and disable monitor sleep display.
function hdmi
{
    xrandr --output DVI-I-3 --off
    xrandr --output DVI-I-2 --mode 1920x1080 --pos 0x0 --primary\
           --output HDMI-0 --mode 1920x1080 --pos 0x0

    dconf write /org/cinnamon/settings-daemon/plugins/power/sleep-display-ac 0

    pactl set-default-sink alsa_output.pci-0000_01_00.1.hdmi-stereo-extra1
    INPUTS=($(pactl list sink-inputs | grep Input | awk '{print $3}' | sed -r 's/^.{1}//'))
    pactl set-card-profile 0 output:hdmi-stereo-extra1
    pactl set-default-sink alsa_output.pci-0000_01_00.1.hdmi-stereo-extra1
    for i in ${INPUTS[*]}; do pactl move-sink-input $i alsa_output.pci-0000_01_00.1.hdmi-stereo-extra1; done
}

# Switches video and audio to a dual monitor screen, and restore monitor sleep display.
function normal
{
    xrandr --output HDMI-0 --off
    xrandr --output DVI-I-2 --mode 1920x1080 --pos 1920x0 --primary\
           --output DVI-I-3 --mode 1920x1080 --pos 0x0

    dconf write /org/cinnamon/settings-daemon/plugins/power/sleep-display-ac 600

    pactl set-default-sink alsa_output.pci-0000_00_1b.0.analog-stereo
    INPUTS=($(pactl list sink-inputs | grep Input | awk '{print $3}' | sed -r 's/^.{1}//'))
    pactl set-card-profile 0 output:analog-stereo
    pactl set-default-sink alsa_output.pci-0000_00_1b.0.analog-stereo
    for i in ${INPUTS[*]}; do pactl move-sink-input $i alsa_output.pci-0000_00_1b.0.analog-stereo; done
}