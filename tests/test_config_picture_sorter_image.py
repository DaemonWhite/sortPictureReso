import unittest
from unittest.mock import patch
from sortpicturereso.LibPictureSorter  import ConfigPictureSorter  # Replace 'your_module' with the actual module name

class TestConfigPictureSorter(unittest.TestCase):

    def test_add_coefficient(self):
        MIN_W = 800
        MIN_H = 600
        MAX_W = 1600
        MAX_H = 1200

        cps = ConfigPictureSorter()
        cps.add_coefficient("test-coef", MIN_W, MIN_H, MAX_W, MAX_H)


        coefficients = cps.get_all_coefficient()
        self.assertIn("test-coef", coefficients)


        coef_data = coefficients["test-coef"]
        self.assertEqual(coef_data["min_width"], MIN_W)
        self.assertEqual(coef_data["min_height"], MIN_H)
        self.assertEqual(coef_data["max_width"], MAX_W)
        self.assertEqual(coef_data["max_height"], MAX_H)

    def test_calculate_coef(self):
        MIN_W = 800
        MIN_H = 600
        MAX_W = 1600
        MAX_H = 1200

        MIN_COEF = MIN_W / MIN_H
        MAX_COEF = MAX_W / MAX_H

        cps = ConfigPictureSorter()
        cps.add_coefficient("test-coef", MIN_W, MIN_H, MAX_W, MAX_H)


        coefficients = cps.get_all_coefficient()
        self.assertIn("test-coef", coefficients)


        coef_data = coefficients["test-coef"]
        self.assertEqual(coef_data["min_coef"], MIN_COEF)
        self.assertEqual(coef_data["max_coef"], MAX_COEF)

    def test_remove_coefficient(self):

        cps = ConfigPictureSorter()
        cps.add_coefficient("test-coef", 800, 600, 1600, 1200)
        cps.remove_coefficient("test-coef")


        coefficients = cps.get_all_coefficient()
        self.assertNotIn("test-coef", coefficients)

    def test_enabled_copy_mode(self):

        cps = ConfigPictureSorter()
        cps.enabled_copy_mode()


        self.assertTrue(cps.get_copy())

    def test_disable_default(self):

        cps = ConfigPictureSorter()
        cps.disable_default()


        self.assertFalse(cps.get_default())

if __name__ == "__main__":
    unittest.main()

