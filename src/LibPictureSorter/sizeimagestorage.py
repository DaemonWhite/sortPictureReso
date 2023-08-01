class Size_image_storage(object):
    _coefficient = dict()

    def get_coef(self, name_coef: str):
        return self.__coefficient[name_coef]

    def get_dict_coeff(self):
        return self.__coefficient.copie()

    def get_name_coef(self):
        return self.__coefficient.keys()

    def default_coef(self):
        self.__coefficient = {
            "pc-statdart" : [1.5, 1.9],
            "pc-old" : [0.9, 1.5],
            "mobile" : [0.0, 0.9],
        }

    def add_coef(self, name_coef: str, min_coef: float, max_coef: float):
        self.__coefficient[name_coef] = [min_coef, max_coef]

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

    def remove_coef(self, name_coef):
        del self.__coefficient[name_coef]

    def list_coef(self):
        print(self.__coefficient)

    def calculate_coef(self, width: int, height: int) -> float:
        coef = width / height
        return coef

if __name__ == "__main__":
    te = Size_image_storage()
    te.default_coef()
    te.add_coef("pc-large", 1.9, 2.3)
    te.remove_coef("pc-statdart")
    te.list_coef()
    te.get_name_coef()
    print( "Pc Large : ", te.get_coef("pc-large"))
