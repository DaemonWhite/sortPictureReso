#!/bin/python3
import os
import platform

from PIL import Image

class Picture_sorter():

    DEFAULT_PICTURE_OUT = "./"
    __IMAGE_EXTENTION = [".jpg", ".jpeg", ".png", ".gif"]
    def __init__(self,
        picture_in = "",
        picutre_out = ""):

        self.__picture_in = self.DEFAULT_PICTURE_OUT
        self.__picture_out = self.DEFAULT_PICTURE_OUT

        self.__files_images = list()

        self.__is_copy = True

        self.set_picture_in_path(picture_in)
        self.set_picture_out_path(picutre_out)

    def get_picture_in_path(self):
        return self.__picture_in

    def get_picture_out_path(self):
        return self.__picture_out

    def get_search_images(self):
        return self.__files_images.copy()

    def reset_search_images(self):
        self.__files_images = list()

    def set_picture_in_path(self, path: str):
        if path == "":
            self.default_in_picture()

    def set_picture_out_path(self, path: str):
        if path == "":
            self.default_out_picture()

    def default_in_picture(self):
        path_picture = self.xdg_picture_path()

        self.__picture_in = path_picture

    def default_out_picture(self):
        path_picture = self.xdg_picture_path() + "/out" # Si aucun système n'est detecter

        self.__picture_out = path_picture

    def xdg_picture_path(self) -> str:
        path_picture = self.DEFAULT_PICTURE_OUT
        system = platform.system()

        if system == "Windows":
            path_picture = self.xdg_picture_path_windows()
        elif system == "Linux":
            path_picture = self.xdg_picture_path_linux()

        return path_picture

    def xdg_picture_path_linux(self):
        DIRECTORY_NAME = "PICTURES"
        xdg_config_home = os.getenv('XDG_CONFIG_HOME', os.path.expanduser('~/.config'))
        xdg_user_dirs_file = os.path.join(xdg_config_home, 'user-dirs.dirs')

        if not os.path.exists(xdg_user_dirs_file):
            raise FileNotFoundError("XDG user directories configuration file not found.")

        with open(xdg_user_dirs_file, 'r') as f:
            for line in f:
                if line.startswith(f'XDG_{DIRECTORY_NAME}'):
                    path = os.path.expanduser(line.split('=', 1)[1].strip().strip('"'))
                    path_find = path.find('$HOME/')
                    if path_find > -1:
                        return os.getenv('HOME') + line.split('$HOME', 1)[1].strip().strip('"')
                    else:
                        return path.strip('"')




    def xdg_picture_path_windows(self):
        pass

    def search_images(self):
        files = os.listdir(self.__picture_in)
        for file in files:
            if os.path.splitext(file)[1].lower() in self.__IMAGE_EXTENTION:
                self.__files_images.append(file)

    def resolve(self):
        pass

    def apply_resolve(self):
        pass

if __name__ == "__main__":
    ps = Picture_sorter()
    print("Path in : ", ps.get_picture_in_path())
    print("Path out : ", ps.get_picture_out_path())
    ps.search_images()
    print(ps.get_search_images())
