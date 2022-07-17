import subprocess
import sys
from git_utils import make_sure_remote_repo_is_downloaded
from os.path import exists

def format_files(*files: str):
    make_sure_remote_repo_is_downloaded("swift-format", "https://github.com/apple/swift-format.git", "release/5.6")
    make_sure_swift_format_is_compiled()
    print("Formatting swift files...")
    subprocess.check_call(f"./swift-format/.build/release/swift-format -i --configuration formatting_config.json {' '.join(files)}".split(" "), stderr=subprocess.STDOUT)

def make_sure_swift_format_is_compiled():
    if exists("./swift-format/.build/release/swift-format"):
        return
    else:
        compile_swift_format()

def compile_swift_format(*files: str):
    print("Compiling swift-format...")
    try:
        subprocess.check_call("swift build -c release -C swift-format".split(" "), stderr=subprocess.STDOUT)
    except subprocess.CalledProcessError as e:
        print_error("FAIL: Building swift-format failed")
        print_error(f"Executing: {' '.join(e.cmd)}")
        sys.exit(1) 

def print_error(message):
  print(message, file=sys.stderr)
