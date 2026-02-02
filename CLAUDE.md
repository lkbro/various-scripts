# CLAUDE.md - AI Assistant Guide for various-scripts

## Repository Overview

This repository contains a collection of Windows utility scripts for personal productivity automation. The scripts handle file operations, backups, clipboard management, network utilities, and file renaming tasks.

## Codebase Structure

```
various-scripts/
├── batch/                    # Windows batch scripts and registry files
│   ├── ConvertToJPEG.bat     # Image conversion using IrfanView
│   ├── ConvertToJPEG.reg     # Context menu registration for HEIC/PDF
│   ├── CreateBCKcopy.bat     # Timestamped backup copy utility
│   ├── CreateBCKcopy.reg     # Context menu registration
│   ├── CreateBCKzip.bat      # Backup with 7-Zip compression
│   ├── CreateBCKzip.reg      # Context menu registration
│   ├── Timestamp.bat         # Clipboard timestamp (DD-Mon-YYYY HH:MM)
│   ├── Timestamp filename.bat # Clipboard timestamp (YYYYMMDD HHMM)
│   ├── ToggleAC.bat          # Toggle WiFi autoconfig
│   └── resetWiFi.ps1         # PowerShell WiFi adapter reset
├── rename scan/              # Scan file renaming utilities
│   ├── rename_scans.bat      # Triggers Python script on remote NAS
│   ├── rename_scans.reg      # Context menu registration
│   └── scanrename.py         # Python script for standardizing filenames
├── LICENSE                   # GPL-3.0 license
└── README.md                 # Project documentation
```

## Script Categories

### 1. Image Conversion (`batch/ConvertToJPEG.*`)
- Uses IrfanView command-line (`i_view64.exe`) to convert HEIC/PDF to JPEG
- Registered via Windows context menu for `.heic` and `.pdf` files
- **Dependency**: IrfanView installed at `C:\Program Files\IrfanView\`

### 2. Backup Utilities (`batch/CreateBCK*`)
- **CreateBCKcopy**: Creates timestamped copies in `_bck` subfolder
- **CreateBCKzip**: Creates timestamped backups compressed with 7-Zip, retaining only the latest uncompressed version
- **Timestamp format**: `YYYYMMDD_HHMMSS`
- **Dependency**: 7-Zip installed at `C:\Program Files\7-Zip\`

### 3. Timestamp Clipboard Utilities (`batch/Timestamp*.bat`)
- **Timestamp.bat**: Copies `DD-Mon-YYYY HH:MM` format to clipboard
- **Timestamp filename.bat**: Copies `YYYYMMDD HHMM` format to clipboard
- Designed to be triggered via keyboard shortcuts through desktop shortcuts

### 4. Network Utilities
- **ToggleAC.bat**: Toggles WiFi autoconfig on/off using `netsh`
- **resetWiFi.ps1**: PowerShell script to disable/enable WiFi adapter (requires admin)

### 5. Scan Renaming (`rename scan/`)
- Batch file triggers Python script on remote NAS via SSH (using `plink`)
- Python script standardizes scan filenames to `scan YYYYMMDD HHMMSS description.ext`
- Handles multiple date/time formats from scanners
- **Dependencies**: plink, SSH access to NAS with Python 3

## Key Conventions

### Timestamp Formats
| Context | Format | Example |
|---------|--------|---------|
| Backup files | `YYYYMMDD_HHMMSS` | `20240115_143022` |
| Scan files | `YYYYMMDD HHMMSS` | `20240115 143022` |
| Clipboard (filename-safe) | `YYYYMMDD HHMM` | `20240115 1430` |
| Clipboard (readable) | `DD-Mon-YYYY HH:MM` | `15-Jan-2024 14:30` |

### Backup Directory Convention
- Backups are stored in a `_bck` subfolder relative to the original file location

### Filename Sanitization Rules (scanrename.py)
- Allowed characters: alphanumeric, parentheses `()`, brackets `[]`, hyphens `-`, underscores `_`, spaces
- Multiple spaces collapsed to single space
- System files (starting with `.` or `@`) are skipped

## Development Guidelines

### When Modifying Scripts

1. **Preserve existing timestamp formats** - The user has specific preferences for timestamp formats across different contexts

2. **External dependencies** - Scripts rely on specific installation paths:
   - IrfanView: `C:\Program Files\IrfanView\i_view64.exe`
   - 7-Zip: `C:\Program Files\7-Zip\7z.exe`
   - plink: Available in PATH

3. **Registry files** - Use UTF-16LE encoding (standard Windows registry export format)

4. **Path conventions** - Scripts expect to be located at `C:\projects\batch\`

5. **NAS integration** - The rename scan feature uses:
   - SSH via plink with key-based or password file authentication
   - Path translation from Windows (`X:\`) to Unix (`/volume1/`)

### Testing Considerations

- Test batch scripts with filenames containing spaces
- Registry entries require admin privileges to import
- PowerShell scripts may require execution policy adjustment
- NAS scripts require network connectivity and proper credentials

## Common Tasks for AI Assistants

### Adding a New Context Menu Entry
1. Create the `.bat` file with the desired functionality
2. Create corresponding `.reg` file pointing to the batch file
3. Use consistent registry key naming patterns

### Modifying Timestamp Formats
- Check all related scripts to maintain consistency
- The Python script (`scanrename.py`) handles multiple input formats but standardizes output

### Adding Support for New File Types
- Image conversion: Add new registry entries in `ConvertToJPEG.reg`
- Backup utilities: Already work with any file type via `*\shell` registry key

## Security Notes

- The `rename_scans.bat` references a password file for NAS authentication
- Credentials should not be committed to the repository
- Admin privileges required for WiFi scripts and registry modifications
