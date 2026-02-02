# SSH Key Authentication Setup for NAS Access

This guide walks you through setting up SSH key authentication for secure, passwordless access to your NAS.

## Prerequisites

- Windows 10/11 with OpenSSH client installed (included by default)
- PuTTY/plink installed (for the batch script)
- SSH access enabled on your NAS
- Admin access to your NAS

## Step 1: Generate SSH Key Pair on Windows

Open PowerShell or Command Prompt and run:

```powershell
# Create .ssh directory if it doesn't exist
mkdir -Force $env:USERPROFILE\.ssh

# Generate a new SSH key pair (press Enter for default location, then set a passphrase or leave empty)
ssh-keygen -t rsa -b 4096 -f $env:USERPROFILE\.ssh\nas_id_rsa -C "your-email@example.com"
```

This creates two files:
- `%USERPROFILE%\.ssh\nas_id_rsa` - Your **private key** (keep this secret!)
- `%USERPROFILE%\.ssh\nas_id_rsa.pub` - Your **public key** (share this with the NAS)

## Step 2: Convert Key to PuTTY Format (Required for plink)

The batch script uses `plink` which requires PuTTY's PPK format:

1. Open **PuTTYgen** (comes with PuTTY installation)
2. Click **Conversions** > **Import key**
3. Select `%USERPROFILE%\.ssh\nas_id_rsa`
4. Enter your passphrase if you set one
5. Click **Save private key**
6. Save as `%USERPROFILE%\.ssh\nas_id_rsa.ppk`

**Important:** Update the `SSH_KEY` variable in `rename_scans.bat` to point to the `.ppk` file:
```batch
set "SSH_KEY=%USERPROFILE%\.ssh\nas_id_rsa.ppk"
```

## Step 3: Copy Public Key to NAS

### Option A: Using ssh-copy-id (if available)

```powershell
# Replace 'nasusername' and 'nashost' with your actual values
type $env:USERPROFILE\.ssh\nas_id_rsa.pub | ssh nasusername@nashost "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```

### Option B: Manual Copy

1. Open your public key file:
   ```powershell
   notepad $env:USERPROFILE\.ssh\nas_id_rsa.pub
   ```

2. Copy the entire contents (starts with `ssh-rsa`)

3. SSH into your NAS:
   ```powershell
   ssh nasusername@nashost
   ```

4. On the NAS, run:
   ```bash
   mkdir -p ~/.ssh
   chmod 700 ~/.ssh
   echo "PASTE_YOUR_PUBLIC_KEY_HERE" >> ~/.ssh/authorized_keys
   chmod 600 ~/.ssh/authorized_keys
   ```

### Synology NAS Specific Instructions

1. Log in to DSM web interface
2. Go to **Control Panel** > **Terminal & SNMP**
3. Enable SSH service
4. SSH into the NAS and edit the SSH config:
   ```bash
   sudo vi /etc/ssh/sshd_config
   ```
5. Ensure these lines are present and uncommented:
   ```
   PubkeyAuthentication yes
   AuthorizedKeysFile .ssh/authorized_keys
   ```
6. Restart SSH:
   ```bash
   sudo synoservicectl --restart sshd
   ```
7. Add your public key as described in Option B above

## Step 4: Test the Connection

Test with plink:
```cmd
plink -i %USERPROFILE%\.ssh\nas_id_rsa.ppk nasusername@nashost "echo Connection successful!"
```

If you see "Connection successful!", the setup is complete.

## Step 5: Update the Batch Script

Edit `rename_scans.bat` and update the configuration section:

```batch
set "SSH_KEY=%USERPROFILE%\.ssh\nas_id_rsa.ppk"
set "NAS_USER=your_actual_username"
set "NAS_HOST=your_nas_hostname_or_ip"
set "NAS_PORT=22"
set "WIN_DRIVE=X:\"
set "NAS_VOLUME=/volume1/"
set "REMOTE_SCRIPT=/path/to/scanrename.py"
```

## Troubleshooting

### "Server refused our key"
- Verify the public key was copied correctly to `~/.ssh/authorized_keys`
- Check file permissions: `~/.ssh` should be 700, `authorized_keys` should be 600
- Ensure the NAS user's home directory isn't world-writable

### "Connection refused"
- Verify SSH is enabled on the NAS
- Check the port number (default is 22)
- Verify firewall isn't blocking the connection

### "Host key not cached"
Run plink once manually to accept the host key:
```cmd
plink nasusername@nashost "exit"
```
Type `y` when prompted to cache the host key.

## Security Best Practices

1. **Protect your private key**: Never share or commit `nas_id_rsa` or `nas_id_rsa.ppk`
2. **Use a passphrase**: Consider adding a passphrase to your key for extra security
3. **Limit key permissions**: On the NAS, ensure `~/.ssh` and `authorized_keys` have correct permissions
4. **Disable password authentication**: Once key auth works, consider disabling password auth in `sshd_config`

## Cleaning Up Old Files

After confirming SSH key authentication works, you can delete:
- `supersecret.txt` (the old password file)
- Any other plaintext credential files
