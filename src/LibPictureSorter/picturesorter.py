import os
import platform
import shutil
import xdg.BaseDirectory

from PIL import Image

from .sizeimagestorage import Size_image_storage

# TODO Ajout du nombre d'image à d'éplacer
# Get de recuperation du nombre d'image courante
# Variaible du comptage d'image
# Variable du nombre max d'image

# TODO Recurssif mode
# Ajout d'une varialble
# Ajout d'une méthode

# TODO ajout d'un mode verbeux
class Picture_sorter(Size_image_storage):

    DEFAULT_PICTURE_OUT = "./"
    __IMAGE_EXTENTION = [".jpg", ".jpeg", ".png", ".gif"]

    def __init__(self, picture_in="", picutre_out=""):

        self.__sort_images = {"Other": []}

        self.__picture_in = self.DEFAULT_PICTURE_OUT
        self.__picture_out = self.DEFAULT_PICTURE_OUT

        self.__files_images = list()

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
        else:
            self.__picture_in = str(path)

    def set_picture_out_path(self, path: str):
        if path == "":
            self.default_out_picture()
        else:
            self.__picture_out = path

    def default_in_picture(self):
        path_picture = self.xdg_picture_path()

        self.__picture_in = path_picture

    def default_out_picture(self):
        path_picture = os.path.join(
            self.xdg_picture_path(), "out"
        )  # Si aucun système n'est detecter

        self.__picture_out = path_picture

    def enabled_copie_mode(self, enabled_copie=True):
        if enabled_copie:
            self.__move_image = shutil.copy
        else:
            self.__move_image = shutil.move

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
        xdg_config_home = xdg.BaseDirectory.xdg_config_home
        xdg_user_dirs_file = os.path.join(xdg_config_home, "user-dirs.dirs")

        if not os.path.exists(xdg_user_dirs_file):
            raise FileNotFoundError(
                "XDG user directories configuration file not found."
            )

        with open(xdg_user_dirs_file, "r") as f:
            for line in f:
                if line.startswith(f"XDG_{DIRECTORY_NAME}"):
                    path = os.path.expanduser(
                        line.split("=", 1)[1].strip().strip('"')
                    )
                    path_find = path.find("$HOME/")
                    if path_find > -1:
                        return os.getenv("HOME") + line.split("$HOME", 1)[
                            1
                        ].strip().strip('"')
                    else:
                        return path.strip('"')

    def xdg_picture_path_windows(self):
        user_path = os.path.join(
            xdg.BaseDirectory.xdg_config_home.split(".config")[0], "Pictures"
        )
        return user_path

    def search_images(self):
        files = os.listdir(self.__picture_in)
        for file in files:
            if os.path.splitext(file)[1].lower() in self.__IMAGE_EXTENTION:
                self.__files_images.append(file)

    def generate__list_sort_image(self):
        for name_coef in self.get_name_coef():
            self.__sort_images[name_coef] = []

    def __move_image(self):
        pass

    def resolve(self):
        for image in self.__files_images:
            path_image = self.__picture_in + "/" + image
            coef = int(-1)

            try:
                with Image.open(path_image) as im:
                    xsize, ysize = im.size
                    coef = self.calculate_coef(xsize, ysize)
            except OSError:

                print("Erreur : Impossible de récupérer l'image : {path_image}")

            if coef > -1:
                self.__sort_images[self.sort_coef(coef)].append(image)

    def verif_output(self, verif_path):
        exist_folder = os.path.isdir(verif_path)

        if not exist_folder:
            os.makedirs(verif_path)

    def apply_resolve(self):
        path_out = str

        for name_dict in self.__sort_images:
            path_out = os.path.join(self.__picture_out, name_dict)
            self.verif_output(path_out)
            for image in self.__sort_images[name_dict]:
                self.__move_image(
                    src=os.path.join(self.__picture_in, image),
                    dst=os.path.join(path_out, image),
                )


if __name__ == "__main__":
    ps = Picture_sorter()
    print("Path in : ", ps.get_picture_in_path())
    print("Path out : ", ps.get_picture_out_path())
    ps.default_coef()
    ps.search_images()
    ps.generate__list_sort_image()
    ps.resolve()
    ps.apply_resolve()

