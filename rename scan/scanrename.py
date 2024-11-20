import os
import sys
import re
from datetime import datetime

def sanitize_filename(filename):
    # Keep only alphanumeric characters, parentheses, brackets, hyphens, and underscores
    # Also, reduce multiple spaces to a single space
    filename = re.sub(r'[^a-zA-Z0-9()\[\]\-_ ]', '', filename)
    filename = re.sub(r'\s+', ' ', filename)  # Replace multiple spaces with a single space
    return filename.strip()

def rename_files_in_directory(directory):
    for filename in os.listdir(directory):
        # Skip files that start with . or @
        if filename.startswith('.') or filename.startswith('@'):
            print(f"Skipped system file: {filename}")
            continue
        
        # Split the filename into the base name and extension
        base_name, extension = os.path.splitext(filename)
        
        new_filename = None  # Initialize new_filename variable
        
        if filename.startswith('Scan'):
            # Process filenames that start with 'Scan'
            parts = base_name.split(' ')
            
            try:
                if len(parts) >= 5:
                    # Case with both date and time
                    date_str = f"{parts[1]} {parts[2]} {parts[3]} {parts[4]}"
                    date_str = date_str.replace('·', ':')  # Replace the time separator with ':'
                    try:
                        date_obj = datetime.strptime(date_str, '%d %b %y %H:%M:%S')
                        new_date_str = date_obj.strftime('%Y%m%d %H%M%S')
                    except ValueError:
                        # If time parsing fails, try parsing only the date
                        date_str = f"{parts[1]} {parts[2]} {parts[3]}"
                        date_obj = datetime.strptime(date_str, '%d %b %y')
                        new_date_str = date_obj.strftime('%Y%m%d')
                        remaining_filename = ' '.join(parts[4:])
                    else:
                        remaining_filename = ' '.join(parts[5:])
                elif len(parts) >= 4:
                    # Case with only date, no time
                    date_str = f"{parts[1]} {parts[2]} {parts[3]}"
                    date_obj = datetime.strptime(date_str, '%d %b %y')
                    new_date_str = date_obj.strftime('%Y%m%d')
                    remaining_filename = ' '.join(parts[4:])
                else:
                    # If the filename doesn't match the expected patterns, skip processing
                    print(f"Filename format not recognized: {filename}")
                    continue
                
                # Sanitize the remaining filename
                remaining_filename = sanitize_filename(remaining_filename)
                
                # Reconstruct the new filename
                new_filename = f"scan {new_date_str} {remaining_filename}".strip() + extension
                
            except ValueError as e:
                print(f"Failed to process {filename}: {e}")
        
        elif "_" in base_name and len(base_name.split('_')) == 4:
            # Process filenames in the format '2023_07_14 12_48 Office Lens.jpg'
            date_part, time_part, *rest = base_name.split(' ', 2)
            try:
                # Replace the time separator with ':'
                time_part = time_part.replace('_', ':')
                date_obj = datetime.strptime(f"{date_part} {time_part}", '%Y_%m_%d %H:%M')
                new_date_str = date_obj.strftime('%Y%m%d %H%M%S')
                remaining_filename = rest[0] if rest else ''
                
                # Remove "Office Lens" if it exists in the remaining filename
                if "Office Lens" in remaining_filename:
                    remaining_filename = remaining_filename.replace("Office Lens", "").strip()
                
                # Sanitize the remaining filename
                remaining_filename = sanitize_filename(remaining_filename)
                
                new_filename = f"scan {new_date_str} {remaining_filename}".strip() + extension
            except ValueError as e:
                print(f"Failed to process {filename}: {e}")
        
        # If the filename format is not recognized, sanitize the entire filename
        if new_filename is None:
            sanitized_base_name = sanitize_filename(base_name)
            new_filename = sanitized_base_name + extension
        
        # Only rename if the new filename is different from the current filename
        if new_filename != filename:
            old_filepath = os.path.join(directory, filename)
            new_filepath = os.path.join(directory, new_filename)
            
            # Rename the file
            os.rename(old_filepath, new_filepath)
            print(f"Renamed: {filename} -> {new_filename}")
        else:
            print(f"No renaming needed: {filename}")

# Main execution
if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 scanrename.py <directory_path>")
    else:
        directory_path = sys.argv[1]
        rename_files_in_directory(directory_path)
