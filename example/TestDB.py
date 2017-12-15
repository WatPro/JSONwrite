#!/usr/bin/env python3

from pymongo import MongoClient

client = MongoClient()
MongoClient('localhost', 27017)
db = client['testdb']
collection = db['birthday']


if __name__ == '__main__':
    db.drop_collection('birthday')
    collection = db['birthday']
    from bson.json_util import loads
    with open("BirthTest.json", "r") as f:
        for line in f:
            collection.insert_one(loads(line))





