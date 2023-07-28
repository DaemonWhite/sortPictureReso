#!/bin/python3

class Size_image_storage(object):

    def __init__(self):
        self.__coefficient = dict()

    def default_coef(self):
        self.__coefficient = {
            "pc-statdart" : [1.5, 1.9],
            "pc-old" : [0.9, 1.5],
            "mobile" : [0.0, 0.9],
        }

    def list_coef(self):
        print(self.__coefficient)

    def get_coef(self, name_coef: str):
        return self.__coefficient[name_coef]

    def get_dict_coeff(self):
        return self.__coefficient

    def add_coef(self, name_coef: str, min_coef: float, max_coef: float):
        self.__coefficient[name_coef] = [min_coef, max_coef]

    def calculate_coef(width: int, height: int) -> float:
        coef = width / height
        return coef

    def add_auto_coef_by_resolution(
        self,
        name_coef: str,
        min_width: int,
        min_height: int,
        max_width: int,
        max_height: int):

        low_coef = self.calculate_coef(min_width, min_height)
        max_coef = self.calculate_coef(max_width, max_height)

        self.add_coef(name_coef, low_coef, max_coef)

if __name__ == "__main__":
    te = Size_image_storage()
    te.default_coef()
    te.add_coef("pc-large", 1.9, 2.3)
    te.list_coef()

# class Picture_sorter(object):

#     def __init__(self,):
#         self.__coeficient("low")



