'''
File: ppm2csv.py
Description: Loads PPM (P6) image file, extracts pixel data,
             and exports to a CSV file.
'''
import sys
import numpy as np

# Terminal colors : Output formatting
GREEN = "\033[0;32m"
RED = "\033[0;31m"
CYAN = "\033[0;36m"
NC = "\033[0m"

def convert_ppm_to_csv(input_path, output_path):
    """
    Reads a binary PPM (P6), extracts pixel data and saves it as a CSV.
    """
    try:
        with open(input_path, 'rb') as f:
            # 1. Parse Header
            # PPM headers consist of: MagicNumber, Width, Height, MaxVal
            # Each is followed by whitespace (usually a newline)
            header = []
            while len(header) < 3:
                line = f.readline().decode('ascii').strip()
                if line and not line.startswith('#'):
                    header.extend(line.split())

            magic_number = header[0]
            width = int(header[1])
            height = int(header[2])
            # The next line in the file is the MaxValue (e.g., 255)
            _ = f.readline().decode('ascii').strip()

            if magic_number != 'P6':
                raise ValueError(f"Expected P6 format, got {magic_number}")

            print(f"{CYAN}>>> Parsing {width}x{height} image...{NC}")

            # 2. Read Binary Data
            # Read the remaining bytes into a Numpy array
            # Each pixel is 3 bytes (uint8)
            pixel_data = np.frombuffer(f.read(), dtype=np.uint8)

            # 3. Reshape and Process
            # Reshape into (Number_of_Pixels, 3) for R, G, B columns
            pixels = pixel_data.reshape(-1, 3)

            # 4. Save to CSV
            # Using fast header-based saving
            print(f"{CYAN}>>> Saving data to CSV...{NC}")
            np.savetxt(output_path, pixels, fmt='%d',
                       delimiter=',', header='R,G,B', comments='')

            print(f"{GREEN}>>> Conversion successful: {output_path}{NC}")

    except Exception as e:
        print(f"{RED}Error during conversion: {e}{NC}")
        sys.exit(1)

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print(f"{RED}Usage: python ppm2csv.py <input.ppm> <output.csv>{NC}")
        sys.exit(1)

    convert_ppm_to_csv(sys.argv[1], sys.argv[2])
