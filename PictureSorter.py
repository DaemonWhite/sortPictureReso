#!/bin/python3
import os
import platform
from SizeImageStorage import Size_image_storage

import xdg.BaseDirectory

#dirs = xdg.BaseDirectory.list_dirs("xdg-user-dirs")


class Picture_sorter(Size_image_storage):

    def __init__(self):
        self.__picture_path = self.default_path_picture()
        self.__load_picture_path = str
        self.__path_images_save = str
        self.__path_images_load = str


    def default_path_picture(self) -> str:
        path_picture = "./" # Si aucun système n'est detecter
        system = platform.system()

        if system == "Windows":
            path_picture = self.get_picture_path_windows()
        elif system == "Linux":
            path_picture = self.get_picture_path_linux()

        return path_picture

    def get_picture_path_linux(self):
        pass

    def get_picture_path_windows(self):
        pass

    def get_picture_path(self):
        return self.__picture_path

    def get_load_picture_path(self):
        return self.__load_picture_path

    def set_picture_path(self, path: str):
        self.__picture_path = path

    def set_load_picture_path(self, path: str):
        self.__load_picture_path = default_path_picture

    def resolve(self):
        pass

    def apply_resolve(self):
        pass

if __name__ == "__main__":
    ps = Picture_sorter()
    #print (xdg_user_dirs())

import os

# def get_xdg_user_dir(directory_name):
#     xdg_config_home = os.getenv('XDG_CONFIG_HOME', os.path.expanduser('~/.config'))
#     xdg_user_dirs_file = os.path.join(xdg_config_home, 'user-dirs.dirs')

#     if not os.path.exists(xdg_user_dirs_file):
#         raise FileNotFoundError("XDG user directories configuration file not found.")

#     with open(xdg_user_dirs_file, 'r') as f:
#         for line in f:
#             if line.startswith(f'XDG_{directory_name.upper()}'):
#                 return os.path.expanduser(line.split('=', 1)[1].strip().strip('"'))

#     raise ValueError(f"XDG user directory '{directory_name}' not found in the configuration file.")

# Example usage
# desktop_dir = get_xdg_user_dir('DESKTOP')
# documents_dir = get_xdg_user_dir('DOCUMENTS')

# print(f"Desktop directory: {desktop_dir}")
# print(f"Documents directory: {documents_dir}")

