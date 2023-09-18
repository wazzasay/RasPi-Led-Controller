import json
import os
import board
import neopixel

# Load configuration
dirname = os.path.dirname(__file__)
data = json.load(open(os.path.join(dirname, 'config.json')))
strands = data["strands"]

# Map the GPIO string to actual board pins
gpio_map = {
    "GPIO10": board.D10,
    "GPIO12": board.D12,
    "GPIO13": board.D13,
    "GPIO18": board.D18,
    "GPIO21": board.D21
}

# Initialize the NeoPixel objects for the entire set of LEDs
total_pixels = sum([strand["pixels"] for strand in strands])
pixels = neopixel.NeoPixel(gpio_map["GPIO21"], total_pixels, auto_write=False)

# Set the first LED to red
pixels[0] = (255, 0, 0)

# Set the last LED to green
pixels[-1] = (0, 255, 0)

# Set the middle LEDs to blue
for i in range(1, total_pixels - 1):
    pixels[i] = (0, 0, 255)

# Update the LEDs
pixels.show()