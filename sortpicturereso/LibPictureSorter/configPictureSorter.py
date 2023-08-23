import os
import json
import platform
import xdg.BaseDirectory

# TODO Stocker des inforamtions suplémentaires
# Recupérer des infos à la demande
# Stocker des infos à la demande


class ConfigPictureSorter(object):
    """ Save and load ConfigPictureSorter"""
    def __init__(self, name="PictureSorter"):
        self.__json_data = {
            "default": True,
            "copy": False,
            "recursif": False,
            "path_in": "./",
            "path_out": "./out",
            "coefficient": {},
        }
        self.__xdg = self.__get_xdg_path()

        self.__name_file = name + ".json"
        self.__folder_file = os.path.join(self.__xdg, "PictureSorterConf")

        if not os.path.isdir(self.__folder_file):
            os.makedirs(self.__folder_file)

        if not os.path.isfile(os.path.join(self.__folder_file, self.__name_file)):
            self.save()

    def __get_xdg_path(self):
        """ Load default config path by os"""
        path_conf_user = "./"
        system = platform.system()

        try:
            path_conf_user = xdg.BaseDirectory.xdg_config_home
        except:
            print("Warning: no conf path detected")
            path_conf_user = "./"

        if system == "Windows":
            path_conf_user = os.path.join(
                path_conf_user.split("\.config")[0], "\AppData\Local"
            )
        return path_conf_user

    def modify_path_in(self, path):
        self.__json_data["path_in"] = path

    def modify_path_out(self, path):
        self.__json_data["path_out"] = path

    def __calc_ceof(self, w, h) -> float:
        """Calculate the coefficient  Width / Heigth = Coef """
        calc = 0
        if h != 0:
            calc = w / h

        return calc

    def add_coefficient(
            self,
            name: str,
            min_width: int,
            min_height: int,
            max_width: int,
            max_height: int,
        ):
        """ Add coefficient in config """
        self.__json_data["coefficient"][name] = {
            "min_width": min_width,
            "min_height": min_height,
            "max_width": max_width,
            "max_height": max_height,
            "min_coef": self.__calc_ceof(min_width, min_height),
            "max_coef": self.__calc_ceof(max_width, max_height),
        }

    def enabled_copy_mode(self, copy=True):
        """ Enable/Diable copy mode settings """
        self.__json_data["copy"] = copy

    def enabled_recursif_mode[self, recursif=True]:
        self.__json_data["recursif"] = recursif

    def disable_default(self, default=False):
        """Disable default settings for the prevent is not default"""
        self.__json_data["default"] = default

    def remove_coefficient(self, name):
        """Remove coefficient in configuration"""
        del self.__json_data["coefficient"][name]

    def get_copy(self):
        """Get state copy in conf """
        return self.__json_data["copy"]

    def get_default(self):
        """Get default in conf """
        return self.__json_data["default"]

    def get_resolve(self):
        return self.__json_data["recursif"]

    def get_coefficent(self, name):
        """get_coefficient by name"""
        W = self.__json_data["coefficient"][name]["width"]
        H = self.__json_data["coefficient"][name]["height"]
        C = self.__json_data["coefficient"][name]["coef"]
        return W, H, C

    def get_all_coefficient(self):
        """"get all coefficient in config"""
        return self.__json_data["coefficient"].copy()

    def get_path_in(self):
        """get path for get images"""
        return self.__json_data["path_in"]

    def get_path_out(self):
        """get path for save images"""
        return self.__json_data["path_out"]

    def save(self):
        """Save configuration in json file"""
        path = os.path.join(self.__folder_file, self.__name_file)
        with open(path, "w") as json_file:
            json.dump(self.__json_data, json_file)

    def load(self):
        """ load configuration in file """
        path = os.path.join(self.__folder_file, self.__name_file)
        with open(path, "r") as json_file:
            self.__json_data = json.load(json_file)
