#!/bin/python3
import sys
import os

from LibPictureSorter import Picture_sorter, ConfigPictureSorter, Size_image_storage



# TODO Ajout de la configuration non implémentée
# - Ajout coefficient
# - Suprimer coeffiient
# - Changer les chemins par défault
# - Ajouter le meson

class ArguemntControl(object):
    def __init__(self):
        self.__dict_argument = dict()
        self.__argument = sys.argv.copy()
        self.__index = 1

    def add_arguemnt(self,
            name: str,
            litle_name: str,
            description: str,
            methode,
            option=0):
        self.__dict_argument[("--" + name)] = {
            'litle_name' : ("-" +litle_name),
            'description' : description,
            'methode' : methode,
            'option' : option
        }

    def ls_help(self):
        for name_arg in self.__dict_argument:
            print("{}\t {}\t\t{}"
                .format(
                    self.__dict_argument[name_arg]['litle_name'],
                    name_arg,
                    self.__dict_argument[name_arg]['description']
                )
            )

    def no_implemented(self):
        print("Error not implemented options")

    def run(self):
        argument = []
        missing = 0
        max_missing = len(self.__dict_argument)
        while self.__index < len(self.__argument):
            for name_arg in self.__dict_argument:
                if  (
                    name_arg==self.__argument[self.__index]
                    or self.__dict_argument[name_arg]['litle_name']
                    ==self.__argument[self.__index]
                ):
                    for option in range(0, self.__dict_argument[name_arg]['option']):
                        self.__index +=1
                        argument.append(self.__argument[self.__index])
                    self.__dict_argument[name_arg]['methode'](*argument)
                    break
                else:
                    missing += 1
            if missing >= max_missing:
                print("Error missing command : {}"
                    .format(self.__argument[self.__index])
                )
                break
            else:
                missing = 0

            self.__index +=1



class Application(object):

    def __init__(self,):
        self.__cps = ConfigPictureSorter()
        self.__cps.load()
        self.__path_in = ""
        self.__path_out = ""

        self.__call_sort = True
        self.__call_help = False
        self.__call_conf_pah = False
        self.__call_add_coef = False
        self.__call_remove_coef = False

        if self.__cps.get_default():
            self.reset()

        path_in = self.__cps.get_path_in()
        path_out = self.__cps.get_path_out()

        argument = sys.argv.copy()
        self.__copy = False

    def set__callback_help(self, method):
        self.__callback_help = method

    def set_path_in(self, *path_in):
        self.__path_in = path_in[0]

    def set_path_out(self, *path_out):
        self.__path_out = path_out[0]

    def ennabled_copy(self, enable=True):
        self.__copy = enable

    def enable_add_coef(self):
        self.__call_add_coef = True

    def enable_remove_coef(self):
        self.__call_remove_coef = True

    def enable_help(self):
        self.__call_help = True

    def add_coef(self):
        pass

    def remove_coef(self):
        pass

    def __callback_help(self):
        pass

    def reset(self):
        pc_old = [1800, 1200]
        phone = [1090, 1200]
        null = 0
        pc_standar = [2000, 1000]
        pc_large = [2960, 1040]
        ps = Picture_sorter()
        self.__cps.modify_path_in(ps.get_picture_in_path())
        self.__cps.modify_path_out(ps.get_picture_out_path())
        self.__cps.add_coefficient("pc-stadart", pc_old[0], pc_old[1] , pc_standar[0], pc_standar[1])
        self.__cps.add_coefficient("pc-old", phone[0], phone[1] , pc_old[0], pc_old[1])
        self.__cps.add_coefficient("phone", null, null , phone[0], phone[1])
        self.__cps.add_coefficient("pc-large", pc_standar[0], pc_standar[1] , pc_large[0], pc_large[1])
        self.__cps.disable_default()
        self.__cps.save()
        del ps

    def ls_conf(self):
        print("\n-- PATH --")
        print("Path input : {}".format(self.__cps.get_path_in()))
        print("Path output : {}".format(self.__cps.get_path_out()))
        print("\n-- CONFIGUATION --")
        print("copy : {}".format(self.__cps.get_copy()))
        print("\n-- COEF --")
        coefs = self.__cps.get_all_coefficient()
        for coef in coefs:
            print("{} -->\t Min : {}x{} -- {}; Max : {}x{} -- {};"
            .format(coef,
            coefs[coef]["min_width"],
            coefs[coef]["min_height"],
            coefs[coef]["min_coef"],
            coefs[coef]["max_width"],
            coefs[coef]["max_height"],
            coefs[coef]["max_coef"]))

    def version(self):
        print("Version : 0.0.4")
        print("Script By DaemonWhite")
        print("Script use XDG user")

    def run(self):
        if self.__call_help:
            self.__callback_help()
            self.__call_sort=False

        if self.__call_conf_pah:
            self.conf_path()
            self.__call_sort=False

        if self.__call_add_coef:
            self.add_coef()
            self.__call_sort=False

        if self.__call_remove_coef:
            self.remove_coef()
            self.__call_sort=False

        if self.__call_sort:
            self.sort()

    def conf_path(self):
        #TODO Ajout de la verification d'erreur
        path_in = input("Entrer le chemin par defaut pour chercher des images")
        path_out = input("Entrer le chemin par defaut pour la sortir des images")

    def sort(self):
        ps = Picture_sorter(self.__path_in, self.__path_out)

        ls_coef = self.__cps.get_all_coefficient()
        for name_coef in ls_coef:
            ps.add_coef(name_coef,
            ls_coef[name_coef]["min_coef"],
            ls_coef[name_coef]["max_coef"])
        del ls_coef

        ps.enabled_copie_mode(self.__copy)
        ps.search_images()
        ps.generate__list_sort_image()
        ps.resolve()
        ps.apply_resolve()

def teste():
    print("tu es beau")

def te(*path):
    print("tu es beau {}".format(path[0]))

def main():
    #TODO Ajout la possibiliter de desactiver le trie
    app = Application()
    ac= ArguemntControl()
    app.set__callback_help(ac.ls_help)
    ac.add_arguemnt("copy", "c", "Enable copie mode by default move", app.ennabled_copy)
    ac.add_arguemnt("path-change", "p", "change default path in and out", ac.no_implemented, 0)
    ac.add_arguemnt("path_in", "i", "Paht for the search picture",  app.set_path_in, 1)
    ac.add_arguemnt("path_out", "o", "Paht for the out picture", app.set_path_out, 1)
    ac.add_arguemnt("remove-ceofficien", "rc", "remove coefficient", ac.no_implemented)
    ac.add_arguemnt("add-coefficient", "ac", "add coefficient", ac.no_implemented)
    ac.add_arguemnt("default", "d", "Default value of this app", app.reset)
    ac.add_arguemnt("list-configuration", "l", "Print configuration", app.ls_conf)
    ac.add_arguemnt("version", "v", "Version system", app.version)
    ac.add_arguemnt("help", "h", "List all command", app.enable_help)
    ac.run()
    app.run()

    #     elif argument[index]=="-i" or argument[index]=="--path_in":
    #         try:
    #             exist_folder = os.path.isdir(argument[index + 1])
    #         except:
    #             exist_folder = False
    #         if not exist_folder:
    #             print("Erreur : dossier non existant")
    #             return 1
    #         path_in = argument[index + 1]
    #         index += 1
    #     elif argument[index]=="-o" or argument[index]=="--path_out":
    #         try:
    #             path_out = argument[index + 1]
    #             index += 1
    #         except:
    #             print("Erreur : Chemin non définie")
    #             return 1



if __name__ == "__main__":
    main()
