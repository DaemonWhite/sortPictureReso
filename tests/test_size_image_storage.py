#!/bin/python3
import unittest
from sortpicturereso.LibPictureSorter import Size_image_storage

class TestSizeImageStorage(unittest.TestCase):

    def setUp(self):
        # Créer une instance de Size_image_storage et définir les coefficients par défaut
        self.sis = Size_image_storage()
        self.sis.default_coef()

    def test_get_name_coef(self):
        # Vérifier si les noms des coefficients sont corrects
        expected_names = {"pc-statdart", "pc-old", "mobile"}
        self.assertEqual(set(self.sis.get_name_coef()), expected_names)

    def test_add_coef(self):
        # Vérifier si un nouveau coefficient est correctement ajouté
        self.sis.add_coef("test-coef", 0.1, 0.2)
        self.assertIn("test-coef", self.sis.get_name_coef())
        self.assertEqual(self.sis.get_coef("test-coef"), [0.1, 0.2])

    def test_remove_coef(self):
        # Vérifier si un coefficient est correctement supprimé
        self.sis.remove_coef("pc-statdart")
        self.assertNotIn("pc-statdart", self.sis.get_name_coef())

    def test_calculate_coef(self):
        # Vérifier si le calcul du coefficient est correct
        self.assertAlmostEqual(self.sis.calculate_coef(1920, 1080), 1.777777, places=5)

    def test_sort_coef(self):
        # Vérifier si la fonction de tri des coefficients fonctionne correctement*
        self.assertEqual(self.sis.sort_coef(1.5), "pc-statdart")
        self.assertEqual(self.sis.sort_coef(0.5), "mobile")
        self.assertNotEqual(self.sis.sort_coef(2.1), "test-coef")  # Le test-coef doit être ajouté avant
        self.assertEqual(self.sis.sort_coef(3), "Other")
        self.assertEqual(self.sis.sort_coef(0), "mobile", 'Test Mobile')

if __name__ == '__main__':
    unittest.main()
