#!/bin/python3

class Size_image_storage():

    def __init__(self):
        self.__coefficient = dict()

    def default_coef():
        self.__coefficent = {
            "pc-statdart" = [1.5, 1.9],
            "pc-old" = [0.9, 1.5],
            "mobile" = [0.0, 0.9],
        }

    def list_coef():
        print(self.__coefficient)

    def get_dict_coeff():
        return self.__coefficient

    def add_coef(str name_coef, float min,float max):
        self.__coefficent += {
            name_coef = [min, max]
        }

    def calculate_coef(width, height):
        coef = width / height
        return coef

    def add_auto_coef_by_resolution(str name, int min_width, int min_height, int max_width, int max_height):
        low_coef = self.calculate_coef(min_width, min_height)
        max_coef = self.calculate_coef(max_width, max_height)

        self.add_coef(name, low_coef, max_coef)


# class Picture_sorter(object):

#     def __init__(self,):
#         self.__coeficient("low")



