import os
import platform
import shutil
import xdg.BaseDirectory

from PIL import Image

from .sizeimagestorage import Size_image_storage

# TODO Recurssif mode
# Ajout d'une varialble
# Ajout d'une méthode

# TODO ajout d'un mode verbeux
class Picture_sorter(Size_image_storage):

    DEFAULT_PICTURE_OUT = "./"
    __IMAGE_EXTENTION = [".jpg", ".jpeg", ".png", ".gif"]

    def __init__(self,
        picture_in="",
        picutre_out="",
        verbose=False,
        recursif=False,
        copy=True
    ):

        if not verbose:
            self.log_info = self.log_pass
            self.log_warning = self.log_pass
            self.log_error = self.log_pass

        self.__files_images = list()
        self.__sort_images = {"Other": []}

        self.__current_image = 0
        self.__max_detected_image = 0

        self.__ignore_path = list()

        self.__recursif = False
        self.__copy = False

        self.enabled_copie_mode(copy)
        self.enabled_recursif_mode(recursif)

        self.set_picture_in_path(picture_in)
        self.set_picture_out_path(picutre_out)

    def get_picture_in_path(self):
        return self.__picture_in

    def get_picture_out_path(self):
        return self.__picture_out

    def get_list_images(self):
        return self.__files_images.copy()

    def get_resolve_image(self):
        return self.__sort_images.copy()

    def get_list_extention(self):
        return self.__IMAGE_EXTENTION.copy()

    def get_current_image(self):
        return self.__current_image

    def get_max_image(self):
        return self.__max_detected_image

    def get_copy(self):
        return self.__copy

    def get_recursif(self):
        return self.__recursif

    def reset_search_images(self):
        self.__files_images = list()

    def set_picture_in_path(self, path: str):
        if path == "":
            self.default_in_picture()
            self.log_info("", "Default in path defined")
        else:
            self.__picture_in = str(path)

    def set_event_progress_move(self, callback):
        self.__event_move_image = callback

    def set_event_end_move(self, callback):
        self.__event_end_image = callback

    def set_picture_out_path(self, path: str):
        if path == "":
            self.default_out_picture()
            self.log_info("", "Default out path defined")
        else:
            self.__picture_out = path

        if self.__recursif:
            self.default_ignore_path()

    def add_ignore_path(self, path):
        self.__ignore_path.append(path)

    def add_extention(self, extention):
        self.__IMAGE_EXTENTION.append(extention)

    def remove_extention(self, extention):
        self.__IMAGE_EXTENTION.remove(extention)

    def log_info(self, name, description):
        print(f"[INFO] : {name} {description}")

    def log_warning(self, name, description):
        print(f"[WARNING] : {name} {description}")

    def log_error(self, name, description):
        print(f"[ERROR] : {name} {description}")

    def log_pass(self, name, description):
        pass

    def __event_move_image(self):
        pass

    def __event_end_image(self):
        pass

    def default_in_picture(self):
        path_picture = self.xdg_picture_path()
        self.__picture_in = path_picture

    def default_out_picture(self):
        path_picture = os.path.join(
            self.xdg_picture_path(), "out"
        )  # Si aucun système n'est detecter

        self.__picture_out = path_picture

    def default_ignore_path(self):
        self.add_ignore_path(os.path.split(self.__picture_out)[1])
        self.add_ignore_path((self.__picture_out+"/"))

    def enabled_copie_mode(self, enabled_copie=True):
        self.__copy = enabled_copie
        if enabled_copie:
            self.__move_image = shutil.copy
        else:
            self.__move_image = shutil.move

    def enabled_recursif_mode(self, enabled_recursif=True):
        self.__recursif = enabled_recursif
        if enabled_recursif:
            self.search_images = self.search_images_recursif
        else:
            self.search_images = self.search_images_no_recursif

        if self.__recursif:
            self.default_ignore_path()

    def xdg_picture_path(self) -> str:
        path_picture = self.DEFAULT_PICTURE_OUT
        system = platform.system()

        self.log_info("OS : ", system)

        if system == "Windows":
            path_picture = self.xdg_picture_path_windows()
        elif system == "Linux":
            path_picture = self.xdg_picture_path_linux()

        self.log_info("DEFAULT PATH DETECTED", path_picture)

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

    def __apply_ignore_file(self, files):
        index_delete = list()
        index = 0
        offset = 0
        for file in files:
            for ignore in self.__ignore_path:
                file_index = file.find(ignore)
                if -1 < file_index:
                    index_delete.append(index)
            index+=1
        for i in index_delete:
            files.pop(i-offset)
            offset += 1

    def search_images_recursif(self):
        path = str()
        len_picture_in = len(self.__picture_in) + 1
        for root, dirs, files in os.walk(self.__picture_in, followlinks=True):
            index = int(0)
            for file in files:
                files[index] = os.path.join(root[len_picture_in:], file)
                index += 1
            self.__apply_ignore_file(files)
            self.__add_search_images(files)

    def __add_search_images(self, files=""):
        for file in files:
            if os.path.splitext(file)[1].lower() in self.__IMAGE_EXTENTION:
                self.__files_images.append(file)
                self.__max_detected_image += 1
                self.log_info(f"Image Detectede {self.__max_detected_image} : ", file)

    def search_images_no_recursif(self):
        files = os.listdir(self.__picture_in)
        self.log_info("DETECTED Files", len(files))
        self.__add_search_images(files)
        self.log_info("DETECTED Image", self.__max_detected_image)

    def search_images(self):
        pass

    def generate__list_sort_image(self):
        for name_coef in self.get_name_coef():
            self.__sort_images[name_coef] = []
            self.log_info("NAME COEF : ", name_coef)

    def __move_image(self):
        pass

# TODO Ajouter le nombre d'image résolue

    def resolve(self):
        path_image = str()
        for image in self.__files_images:
            path_image = os.path.join(self.__picture_in, image)
            coef = int(-1)
            try:
                with Image.open(path_image) as im:
                    xsize, ysize = im.size
                    coef = self.calculate_coef(xsize, ysize)
            except OSError:

                self.log_error("Impossible",f"de récupérer l'image : {path_image}")

            if coef > -1:
                self.__sort_images[self.sort_coef(coef)].append(image)

    def verif_output(self, verif_path):
        exist_folder = os.path.isdir(verif_path)

        if not exist_folder:
            self.log_warning(f"Path not exist : {verif_path}", "\nPath auto generate")
            os.makedirs(verif_path)

    def apply_resolve(self):
        path_out = str()
        self.__event_move_image()
        src = str()
        dst = str()
        for name_dict in self.__sort_images:
            path_out = os.path.join(self.__picture_out, name_dict)
            self.verif_output(path_out)
            for image in self.__sort_images[name_dict]:
                src = os.path.join(self.__picture_in, image)
                dst = os.path.join(path_out, os.path.split(image)[1])
                self.log_info("MOVE", f"{name_dict}\n\tstr :{src}\n\tdest{dst}")
                self.__current_image += 1
                self.__move_image(
                    src=src,
                    dst=dst,
                )
                self.__event_move_image()
        self.__event_end_image()


if __name__ == "__main__":
    ps = Picture_sorter()
    print("Path in : ", ps.get_picture_in_path())
    print("Path out : ", ps.get_picture_out_path())
    ps.default_coef()
    ps.search_images()
    ps.generate__list_sort_image()
    ps.resolve()
    ps.apply_resolve()



