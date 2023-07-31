#!/bin/python3

from SizeImageStorage import Size_image_storage

from xdg_base_dirs import (
    xdg_cache_home,
    xdg_config_dirs,
    xdg_config_home,
    xdg_data_dirs,
    xdg_data_home,
    xdg_runtime_dir,
    xdg_state_home,
)

if __name__ == "__main__":
    print(xdg_state_home())

class Picture_sorter(Size_image_storage):

    def __init__(self):
        self.__path_images_save = str
        self.__path_images_load = str

    def save_images_path(self):
        pass

    def load_image_path(self):
        pass

    def save(self):
        pass

    def load(self):
        pass




