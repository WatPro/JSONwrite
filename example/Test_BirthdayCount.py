#!/usr/bin/env python3

################################################################################
########## Test The Module BirthdayCount                              ##########
################################################################################


########## Import from standard libeary    ##########
import unittest
from unittest.mock import patch
from datetime import date
from io import StringIO

########## Import from related third party ##########
#from pymongo import MongoClient

########## Import the testing target       ##########
import BirthdayCount
from BirthdayCount import BirthdayCalculation as BC, UserInterface as UI
from TestDB import collection 

class TestBirthdayCalculation(unittest.TestCase):

    def __test_calculator(self,data): 
        with patch('BirthdayCount.date') as mock_date:
            mock_date.side_effect = lambda *args, **kw: date(*args, **kw) 
            mock_date.today.return_value = date(
                data['premise']['today_year'], 
                data['premise']['today_month'], 
                data['premise']['today_day']
            )
            self.assertEqual(
                BC.calculator(data['input']['DOB_month'],data['input']['DOB_day']), 
                data['expect']['answer']
            ) 

    def test_calculator(self):
        for doc in collection.find(
            {
                "version":"v0.1", 
                "module":"BirthdayCount",
                "class":"BirthdayCalculation",
                "method":"calculator"
            },
            {"_id":0,"premise":1,"input":1,"expect":1}):
            with self.subTest('test_calculator'):
                self.__test_calculator(doc)

class TestUserInterface(unittest.TestCase):
    
    def test_ask(self): 
        UI_ui = UI()
        with patch('BirthdayCount.stdin', StringIO("1\n1\n")) , \
             patch('BirthdayCount.stdout', new_callable=StringIO): 
            self.assertEqual(UI_ui.ask(),(1,1))
        with patch('BirthdayCount.stdin', StringIO("02\n29\n")), \
             patch('BirthdayCount.stdout', new_callable=StringIO): 
            self.assertEqual(UI_ui.ask(),(2,29))
        with patch('BirthdayCount.stdin', StringIO("100\n100\n100\n100\n100\n100\n100\n")), \
             patch('BirthdayCount.stdout', new_callable=StringIO): 
            self.assertEqual(UI_ui.ask(),None)

if __name__ == '__main__':
    unittest.main(verbosity=2)
    
    