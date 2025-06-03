import os
import re
import subprocess
import sys

# Function to extract imported packages from a Python file
def extract_imports(file_path):
    imports = set()
    import_regex = re.compile(r'^\s*(?:from|import)\s+(\w+)')

    with open(file_path, 'r', encoding='utf-8') as file:
        for line in file:
            match = import_regex.match(line)
            if match:
                package = match.group(1)
                if package not in sys.builtin_module_names:
                    imports.add(package)

    return imports

# Function to install a package using pip
def install_package(package):
    pip_executable = os.path.join(os.path.dirname(sys.executable), 'pip')
    if not os.path.exists(pip_executable):
        pip_executable = 'pip'  # fallback to system pip
    subprocess.check_call([pip_executable, 'install', package])

# Traverse directory to find Python files and install packages
def process_directory(directory):
    all_imports = set()

    for root, _, files in os.walk(directory):
        for file in files:
            if file.endswith('.py'):
                file_path = os.path.join(root, file)
                print(f"Scanning {file_path}...")
                imports = extract_imports(file_path)
                all_imports.update(imports)

    print(f"\nDetected packages: {all_imports}\n")

    for package in all_imports:
        try:
            print(f"Installing {package}...")
            install_package(package)
        except subprocess.CalledProcessError:
            print(f"Failed to install {package}. Check package name or your internet connection.")

# Run script
if __name__ == '__main__':
    if len(sys.argv) != 2:
        print(f"Usage: python {sys.argv[0]} <source-code-directory>")
    else:
        source_code_dir = sys.argv[1]
        process_directory(source_code_dir)

