import os

def create_service_file(script_path, service_name="myscript"):
    service_content = f"""[Unit]
Description={service_name} service
After=network.target

[Service]
ExecStart={script_path}
WorkingDirectory={os.path.dirname(script_path)}
StandardOutput=inherit
StandardError=inherit
Restart=always
User=pi

[Install]
WantedBy=multi-user.target
"""
    with open(f"{service_name}.service", "w") as file:
        file.write(service_content)


def setup_service(service_name="myscript"):
    os.system(f"sudo mv {service_name}.service /etc/systemd/system/")
    os.system(f"sudo chmod 644 /etc/systemd/system/{service_name}.service")
    os.system("sudo systemctl daemon-reload")
    os.system(f"sudo systemctl enable {service_name}.service")


if __name__ == "__main__":
    script_path = input("Enter the full path to your script: ")
    service_name = input("Enter the name for your service (default: myscript): ") or "myscript"
    
    create_service_file(script_path, service_name)
    setup_service(service_name)
    
    print(f"{service_name}.service set up and enabled!")
