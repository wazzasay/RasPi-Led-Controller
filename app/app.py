from flask import Flask, render_template, redirect, url_for, jsonify, request
import os
import subprocess
import json  # Make sure to import json

app = Flask(__name__, static_folder='static')

# Load the SVG title from the title.svg file
with open('static/title.svg', 'r') as f:
    svg_title = f.read()

# Dynamically determine the path to the config.json file
config_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), '../config.json')

def check_service_status():
    """Check if the service is running."""
    try:
        status_output = subprocess.check_output(['systemctl', 'is-active', 'ws2812artnet.service'], universal_newlines=True)
        if "active" in status_output:
            return "Running"
        else:
            return "Stopped"
    except Exception as e:
        print(f"Error checking service status: {e}")
        return "Error"

@app.route('/config', methods=['GET', 'POST'])
def config():
    saved_successfully = False  # Initialize the flag to False at the start of the function

    if request.method == 'POST':
        # Handle saving the updated configuration
        try:
            with open(config_path, 'r') as f:
                data = json.load(f)

            for idx, strand in enumerate(data['strands']):
                universe = int(request.form.get(f'universe_{idx}'))
                gpio_pin = request.form.get(f'gpio_pin_{idx}')
                num_leds = int(request.form.get(f'num_leds_{idx}'))

                strand['universe'] = universe
                strand['gpio'] = gpio_pin
                strand['pixels'] = num_leds

            with open(config_path, 'w') as f:
                json.dump(data, f, indent=4)

            saved_successfully = True  # Set the flag to True if save operation is successful

        except Exception as e:
            print(f'Error updating configuration: {e}')

    # Handle displaying the current configuration
    with open(config_path, 'r') as f:
        data = json.load(f)

    #Debug print
    print(f"Saved Successfully Flag: {saved_successfully}")
    return render_template('config.html', strands=data['strands'], saved=saved_successfully)

@app.route('/')
def index():
    status = check_service_status()
    return render_template('index.html', status=status, svg_title=svg_title)

@app.route('/restart_service', methods=['POST'])
def restart_service():
    try:
        subprocess.check_call(['sudo', 'systemctl', 'restart', 'ws2812artnet.service'])
        return jsonify({'status': 'success', 'message': 'Service restarted successfully'}), 200
    except subprocess.CalledProcessError:
        return jsonify({'status': 'error', 'message': 'Failed to restart the service'}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)