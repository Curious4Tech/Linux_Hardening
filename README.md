# Security Hardening Script

This Bash script automates the process of hardening your Linux system's security. It performs essential updates, configures firewall settings, sets password policies, and applies additional security measures to enhance the overall security posture of your system.

## Features

- **System Update**: Automatically updates and upgrades the system packages to their latest versions.
  
- **Firewall Configuration**: Installs and configures UFW (Uncomplicated Firewall) with basic rules to allow only necessary traffic.

- **SSH Hardening**: Disables root login via SSH to prevent unauthorized access.

- **Password Policies**: Sets strong password policies to enforce complexity and expiration requirements.

- **Service Management**: Disables unused services to reduce potential attack vectors.

- **File Permissions**: Secures sensitive file permissions to protect critical system files.

- **Additional Hardening Measures**:
  - Disables USB storage to prevent unauthorized data transfer.
  - Disables core dumps to protect sensitive information.
  - Optionally disables IPv6 if not needed.

## Usage

1. **Clone the repository**:

   ```bash
   git clone https://github.com/yourusername/security-hardening-script.git
   cd security-hardening-script
   ```

2. **Make the script executable**:

   ```bash
   chmod +x harden_security.sh
   ```

3. **Run the script with superuser privileges**:

   ```bash
   sudo ./harden_security.sh
   ```

4. **Check the log file for details**:

   After execution, review the log file located at `/var/log/security_hardening.log` for a summary of actions taken by the script.

## Requirements

- A Debian-based Linux distribution (e.g., Ubuntu).
- Superuser privileges to execute commands that modify system settings.

## Important Notes

- This script is intended for educational purposes and should be tested in a safe environment before deploying on production systems.
- Always back up important data before making significant changes to your system configuration.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.