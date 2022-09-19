import os
import os.path
import json
from pathlib import Path
from typing import List
import shutil
import base64
from checksumdir import dirhash


root_folder = os.getenv('GITHUB_WORKSPACE', Path(__file__).parents[3])
print(f"root_folder: {root_folder}")
services_output_file = os.getenv('SERVICES_OUPTUT_PATH', os.path.join(root_folder, 'service_build_list.json'))
print(f"services_output_file: {services_output_file}")
helm_services_folder = os.getenv('HELM_SERVICES_FOLDER', os.path.join(root_folder, 'devops/services'))
print(f"helm_services_folder: {helm_services_folder}")
changed_folders = []
changed_files = os.getenv('CHANGED_FILES')
print(f"changed_files: {changed_files}")
service_build_list = []
dependecies_dict = dict()

def is_service(service_list, service_name) -> bool:
    return service_name in service_list


def get_changed_folders():
    if not changed_files:
        print('no changed files')
    else:
        for changed_file in changed_files.split(','):
            folder_name = changed_file.split('/')[0]
            print(f"folder_name: {folder_name}")
            if (folder_name not in changed_folders):
                changed_folders.append(folder_name)
    print(f"changed_folders: {changed_folders}")
    return changed_folders

def get_service_list():
    changed_folders = get_changed_folders()
    print(f"changed_folders: {changed_folders}")
    all_services = os.listdir(helm_services_folder)
    print(f"changed_folders: {all_services}")
    for changed_folder in changed_folders:
        if is_service(all_services, changed_folder):
            service_build_list.append(changed_folder)
            print(f"service_build_list: {service_build_list}")
    print(f"service_list1: {service_build_list}")
    return service_build_list

service_list = get_service_list()
print(f"service_list2: {service_list}")
with open(services_output_file, 'w', encoding='utf-8') as outfile:
    package_build_list_fixed = json.dumps(service_build_list)
    json.dump(package_build_list_fixed, outfile, ensure_ascii=False, indent=4)