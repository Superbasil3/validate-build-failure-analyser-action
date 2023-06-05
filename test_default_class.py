import unittest
from default_class import DefaultClass

class TestDefaultClass(unittest.TestCase):
    def test_greet(self):
        my_object = DefaultClass("John")
        self.assertEqual(my_object.greet(), "Hello, John!")

class Test2DefaultClass(unittest.TestCase):
    def test_greet(self):
        my_object = DefaultClass("Tom")
        self.assertEqual(my_object.greet(), "Hello, John!")

if __name__ == '__main__':
    unittest.main()