import json
import os
from pathlib import Path

root_folder=os.getenv('GITHUB_WORKSPACE',Path(__file__).parents[3])
print(f"root_folder: {root_folder}")
output_folder=os.getenv('OUTPUT_FOLDER',os.path.join(root_folder,'secrets'))
print(f"output_folder: {output_folder}")
secrets_file=os.getenv('SECRETS_FILE_PATH',os.path.join(""))
print(f"secrets_template: {secrets_file}")
secrets_template=os.getenv('SECRETS_TEMPLATE_FILE_PATH',os.path.join(""))
print(f"secrets_template: {secrets_template}")