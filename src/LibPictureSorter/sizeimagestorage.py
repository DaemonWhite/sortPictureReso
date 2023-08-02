class Size_image_storage(object):
    _coefficient = dict()

    def get_coef(self, name_coef: str):
        return self._coefficient[name_coef]

    def get_dict_coeff(self):
        return self._coefficient.copie()

    def get_name_coef(self):
        return self._coefficient.keys()

    def default_coef(self):
        self._coefficient = {
            "pc-statdart" : [1.5, 1.9],
            "pc-old" : [0.9, 1.5],
            "mobile" : [0.0, 0.9],
        }

    def add_coef(self, name_coef: str, min_coef: float, max_coef: float):
        self._coefficient[name_coef] = [min_coef, max_coef]

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
        del self._coefficient[name_coef]

    def list_coef(self):
        print(self._coefficient)

    def calculate_coef(self, width: int, height: int) -> float:
        coef = width / height
        return coef

    def sort_coef(self, coef: float):
        ret_coef = "Other"
        for name_coef in self._coefficient:
            if self._coefficient[name_coef][0] <= coef < self._coefficient[name_coef][1] :
                ret_coef = name_coef
                break

        return ret_coef
if __name__ == "__main__":
    te = Size_image_storage()
    te.default_coef()
    te.add_coef("pc-large", 1.9, 2.3)
    te.remove_coef("pc-statdart")
    te.list_coef()
    te.get_name_coef()
    print("COEF 1 " + te.sort_coef(1))
    print("COEF 0.5 " + te.sort_coef(0.5))
    print("COEF 2.1 " + te.sort_coef(2.1))
    print("COEF 3 " + te.sort_coef(3))
    print("COEF 0 " + te.sort_coef(0))
    print( "Pc Large : ", te.get_coef("pc-large"))
