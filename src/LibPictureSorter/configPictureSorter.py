import os
import json
import xdg.BaseDirectory

# On veut sauvegarder les chemins in/out
# On veut Les stocker resolution avec le coef
#

class ConfigPictureSorter(object):
    def __init__(self, name = "PictureSorter"):
        self.__json_data = {
            "default" : True,
            "copy" : False,
            "path_in" : "./",
            "path_out" : "./out",
            "coefficient" : {},
        }
        self.__xdg = self.__get_xdg_path()

        self.__name_file = name + ".json"
        self.__folder_file = os.path.join(self.__xdg, "PictureSorterConf")

        if not os.path.isdir(self.__folder_file):
            os.makedirs(self.__folder_file)

        if not os.path.isfile(os.path.join(self.__folder_file, self.__name_file)):
            self.save()

    def __get_xdg_path(self):
        return xdg.BaseDirectory.xdg_config_home

    def modify_path_in(self, path):
        self.__json_data["path_in"] = path

    def modify_path_out(self, path):
        self.__json_data["path_in"] = path

    def add_coefficient(self, name: str,
    min_width: int,
    min_height : int,
    max_width: int,
    max_height : int,
    ):
        self.__json_data["coefficient"][name] = {
            "width" : width,
            "height" :  height,
            "min_coef" : float(min_width / min_height),
            "max_coef" : float(max_width / max_height),
        }

    def enabled_copy_mode(self, copy = True):
        self.__json_data["copy"] = copy

    def disable_default(self, default = False):
        self.__json_data["default"] = default

    def remove_coefficient(self, name):
        del self.__json_data["coefficient"][name]

    def get_copy(self):
        return self.__json_data["copy"]

    def get_default(self):
        return self.__json_data["default"]

    def get_coefficent(self, name):
        W = self.__json_data["coefficient"][name]["width"]
        H = self.__json_data["coefficient"][name]["height"]
        C = self.__json_data["coefficient"][name]["coef"]
        return W,H,C

    def get_all_coefficient(self):
        return self.__json_data["coefficient"].copy()

    def get_path_in(self):
        return self.__json_data["path_in"]

    def get_path_out(self):
        return self.__json_data["path_out"]

    def save(self):
        path = os.path.join(self.__folder_file, self.__name_file)
        print(path)
        with open(path, 'w') as json_file:
            json.dump(self.__json_data, json_file)


    def load(self):
        path = os.path.join(self.__folder_file, self.__name_file)
        with open(path, 'r') as json_file:
            self.__json_data = json.load(json_file)

if __name__ == "__main__":
    cps = ConfigPictureSorter()
    cps.load()
    print(cps.get_coefficent("pc-main"))
    cps.add_coefficient("pc-main", 1920, 1080)
    cps.add_coefficient("phone-main", 1080, 1920)
    cps.save()
    print(cps.get_all_coefficient())
