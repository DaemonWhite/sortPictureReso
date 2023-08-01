import sys
import os

from LibPictureSorter import Picture_sorter

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
    render_help("v", "version", "Version system")
    render_help("h", "help", "Help mode")

def main():
    argument = sys.argv.copy()
    is_copie = False
    path_in = ""
    path_out = ""
    index = 1
    penality = 0
    while index < len(argument):
        if argument[index]=="-h" or argument[index]=="--help":
            help()
        elif argument[index]=="-v" or argument[index]=="--version":
            version()
        elif argument[index]=="-c" or argument[index]=="--copie":
            is_copie = True
        elif argument[index]=="-i" or argument[index]=="path_in":
            try:
                exist_folder = os.path.isdir(argument[index + 1])
            except:
                exist_folder = False
            if not exist_folder:
                print("Erreur : dossier non existant")
                return 1
            path_in = argument[index + 1]
            index += 1
        elif argument[index]=="-o" or argument[index]=="path_out":
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
    print("Path in : {}".format(ps.get_picture_in_path()))
    print("Path out : {}".format(ps.get_picture_out_path()))
    ps.enabled_copie_mode(is_copie)
    ps.default_coef()
    ps.search_images()
    ps.generate__list_sort_image()
    ps.resolve()
    ps.apply_resolve()

main()
