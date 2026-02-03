#!/bin/bash

# Configuration Setup Script
# This script helps set up configuration files from examples

echo "========================================"
echo "Configuration Setup Script"
echo "========================================"

# Mosquitto password file setup
if [ ! -f "config/mosquitto/passwd" ]; then
    echo "Creating mosquitto passwd file..."
    if [ -f "config/mosquitto/passwd.example" ]; then
        cp config/mosquitto/passwd.example config/mosquitto/passwd
        echo "Created: config/mosquitto/passwd"
        echo ""
        echo "IMPORTANT: You need to edit config/mosquitto/passwd"
        echo "   Add real user credentials using:"
        echo "   mosquitto_passwd -b config/mosquitto/passwd username password"
        echo ""
        echo "   Or manually add entries in format:"
        echo "   username:encrypted_password_hash"
        echo ""
    else
        echo "Error: config/mosquitto/passwd.example not found!"
        echo "   Creating empty passwd file instead..."
        touch config/mosquitto/passwd
        echo "# Mosquitto password file" > config/mosquitto/passwd
        echo "# Add users with: mosquitto_passwd -b passwd username password" >> config/mosquitto/passwd
    fi
else
    echo "✓ Mosquitto passwd file already exists"
fi

# Home Assistant secrets file setup
if [ ! -f "config/home-assistant/secrets.yaml" ]; then
    echo "Creating Home Assistant secrets.yaml..."
    if [ -f "config/home-assistant/secrets.yaml.example" ]; then
        cp config/home-assistant/secrets.yaml.example config/home-assistant/secrets.yaml
        echo "Created: config/home-assistant/secrets.yaml"
        echo ""
        echo "IMPORTANT: You MUST edit config/home-assistant/secrets.yaml"
        echo "   Replace all placeholder values with your actual:"
        echo "   - API keys"
        echo "   - Passwords"
        echo "   - Location coordinates"
        echo "   - Other sensitive data"
        echo ""
        echo "   Example changes needed:"
        echo "   mqtt_password: \"CHANGE_ME\""
        echo "   api_key: \"YOUR_REAL_API_KEY_HERE\""
        echo "   latitude: 40.7128  # Your actual latitude"
        echo ""
    else
        echo "Error: secrets.yaml.example not found!"
        echo "   Creating minimal secrets.yaml instead..."
        cat > config/home-assistant/secrets.yaml << EOF
# Home Assistant Secrets
# Add your actual secrets here

# MQTT credentials
mqtt_username: "CHANGE_ME"
mqtt_password: "CHANGE_ME"

# API Keys
api_key: "CHANGE_ME"

# Location
latitude: 0.0
longitude: 0.0
time_zone: "UTC"

# Add more secrets as needed
EOF
        echo "Created minimal secrets.yaml - you MUST edit it!"
    fi
else
    echo "✓ Home Assistant secrets.yaml already exists"
fi

# Set secure permissions
echo ""
echo "Setting secure file permissions..."
if [ -f "config/mosquitto/passwd" ]; then
    chmod 600 config/mosquitto/passwd 2>/dev/null && echo "✓ Set secure permissions for mosquitto/passwd"
fi
if [ -f "config/home-assistant/secrets.yaml" ]; then
    chmod 600 config/home-assistant/secrets.yaml 2>/dev/null && echo "✓ Set secure permissions for secrets.yaml"
fi

echo ""
echo "========================================"
echo "Setup Complete!"
echo "========================================"
echo ""
echo "Next steps:"
echo "1. Edit the configuration files created above"
echo "2. NEVER commit these files to version control!"
echo "3. Verify services work with your new credentials"
echo ""
echo "Files to edit:"
[ -f "config/mosquitto/passwd" ] && echo "   • config/mosquitto/passwd"
[ -f "config/home-assistant/secrets.yaml" ] && echo "   • config/home-assistant/secrets.yaml"
echo ""
