import sys
import os

from LibPictureSorter import Picture_sorter, ConfigPictureSorter, Size_image_storage

def version():
    print("Version : 0.0.3")
    print("Script By DaemonWhite")
    print("Script use XDG user")

def render_help(argument, complet_argument, descritpion):
    print("-{} --{}\t{}".format(argument, complet_argument, descritpion))

def help():
    render_help("c", "copie", "Enable copie mode by default move")
    render_help("i", "path_in", "Paht for the search picture")
    render_help("o", "path_output", "Path for the move picture")
    render_help("rc", "remove-ceofficient", "remove coefficient")
    render_help("ac", "add-coefficient", "add coefficient")
    render_help("p", "path-change", "change default path in and out")
    render_help("l", "list-configuration", "Print configuration")
    render_help("v", "version", "Version system")
    render_help("h", "help", "Help mode")

def ls_conf(cps: ConfigPictureSorter):
    print("\n-- PATH --")
    print("Path input : {}".format(cps.get_path_in()))
    print("Path output : {}".format(cps.get_path_out()))
    print("\n-- CONFIGUATION --")
    print("copy : {}".format(cps.get_copy()))
    print("\n-- COEF --")
    coefs = cps.get_all_coefficient()
    for coef in coefs:
        print("{} -->\t Min : {}x{} -- {}; Max : {}x{} -- {};"
        .format(coef,
        coefs[coef]["min_width"],
        coefs[coef]["min_height"],
        coefs[coef]["min_coef"],
        coefs[coef]["max_width"],
        coefs[coef]["max_height"],
        coefs[coef]["max_coef"])
        )

def main():
    cps = ConfigPictureSorter()
    cps.load()
    path_in = ""
    path_out = ""

    if cps.get_default():
        pc_old = [1800, 1200]
        phone = [1090, 1200]
        null = 0
        pc_standar = [2000, 1000]
        pc_large = [2960, 1040]
        ps = Picture_sorter()
        cps.modify_path_in(ps.get_picture_in_path())
        cps.modify_path_out(ps.get_picture_out_path())
        cps.add_coefficient("pc-stadart", pc_old[0], pc_old[1] , pc_standar[0], pc_standar[1])
        cps.add_coefficient("pc-old", phone[0], phone[1] , pc_old[0], pc_old[1])
        cps.add_coefficient("phone", null, null , phone[0], phone[1])
        cps.add_coefficient("pc-large", pc_standar[0], pc_standar[1] , pc_large[0], pc_large[1])
        cps.disable_default()
        cps.save()
        del ps

    path_in = cps.get_path_in()
    path_out = cps.get_path_out()

    argument = sys.argv.copy()
    is_copie = False
    index = 1
    penality = 0
    while index < len(argument):
        if argument[index]=="-h" or argument[index]=="--help":
            help()
        elif argument[index]=="-v" or argument[index]=="--version":
            version()
        elif argument[index]=="-c" or argument[index]=="--copie":
            is_copie = True
        elif argument[index]=="-l" or argument[index]=="--list-configuration":
            ls_conf(cps)
        elif argument[index]=="-i" or argument[index]=="--path_in":
            try:
                exist_folder = os.path.isdir(argument[index + 1])
            except:
                exist_folder = False
            if not exist_folder:
                print("Erreur : dossier non existant")
                return 1
            path_in = argument[index + 1]
            index += 1
        elif argument[index]=="-o" or argument[index]=="--path_out":
            try:
                path_out = argument[index + 1]
                index += 1
            except:
                print("Erreur : Chemin non définie")
                return 1
        else:
            print("Argument inconnue {}".format(argument[index]))
            return 1
        index += 1

    ps = Picture_sorter(path_in, path_out)

    ls_coef = cps.get_all_coefficient()
    for name_coef in ls_coef:
        ps.add_coef(name_coef,
        ls_coef[name_coef]["min_coef"],
        ls_coef[name_coef]["max_coef"])
    del ls_coef

    ps.enabled_copie_mode(is_copie)
    ps.search_images()
    ps.generate__list_sort_image()
    ps.resolve()
    ps.apply_resolve()

main()
