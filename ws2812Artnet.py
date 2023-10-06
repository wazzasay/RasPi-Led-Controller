import signal
from stupidArtnet import StupidArtnetServer
import json
import os
import board
import neopixel

dirname = os.path.dirname(__file__)
data = json.load(open('/RasPi-Led-Controller/config.json'))

# For now, set the GPIO pin directly
gpio_pin = board.D21

# Total number of LEDs across all strands
total_leds = sum([strand["pixels"] for strand in data["strands"]])
pixels = neopixel.NeoPixel(gpio_pin, total_leds, auto_write=False)

# Instead of a single flag, maintain a set of universes for which data has been printed
printed_universes = set()

def artnet_callback(packet_data, universe=None):
    global printed_universes

    # Filter out undesired universes
    if universe not in [10, 11, 12]:
        return

    # Print Artnet data for the first packet of each universe
    if universe not in printed_universes:
        print(f"Artnet Data for Universe {universe}: {packet_data}")
        printed_universes.add(universe)

    # Determine which strand the universe corresponds to
    cumulative_leds = 0
    for strand in data["strands"]:
        if strand["universe"] == universe:
            leds_in_universe = min(strand["pixels"], len(packet_data) // 3)
            break
        cumulative_leds += strand["pixels"]

    for i in range(leds_in_universe):
        r, g, b = packet_data[i * 3], packet_data[i * 3 + 1], packet_data[i * 3 + 2]
        if (cumulative_leds + i) < total_leds:  # Ensure we don't exceed the total number of LEDs
            pixels[cumulative_leds + i] = (r, g, b)

    pixels.show()

server = StupidArtnetServer()

# Registering listeners for all universes across strands
for strand in data["strands"]:
    if strand["universe"] in [10, 11, 12]:  # Only register for universes 10, 11, and 12
        server.register_listener(strand["universe"], callback_function=artnet_callback)

# Keep the script running
signal.pause()