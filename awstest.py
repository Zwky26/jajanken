from threading import Thread
import boto3
import requests
from bs4 import BeautifulSoup
from requests_html import HTMLSession
import csv
import os
from datetime import date, datetime

def getNames(path):
    #function that returns list of names from csv file
    os.chdir(path)
    with open(r"playerIDs.csv", "r") as playernames:
        namefile = csv.reader(playernames, delimiter=',')
        names = []
        for row in namefile:
            names.append(row[0])
    os.chdir(path + "teststore")
    return names

def makeBucket():
    #function that makes the corresponding bucket in s3 where we will write all the cached data into
    #name of bucket is day of execution, like "09.12.2021"
    now = datetime.now()
    bucketName = now.strftime("%m" + "." + "%d" + "." + "%Y")
    print(bucketName)
    s3 = boto3.client('s3')
    s3.create_bucket(Bucket=bucketName)
    response = s3.list_buckets()
    buckets = [bucket['Name'] for bucket in response['Buckets']]
    # Print out the bucket list
    print("Bucket List: %s" % buckets)
    return bucketName

def procedure(name, bucket, session, s3Session):
    #procedure will be done for each playername. What will happen is we simulate the page being loaded, get the content, and write to a file
    #file will correspond to name of member, then we upload said file to bucket
    url = "https://chess.com/member/" + name

    resp = session.get(url)
    resp.html.render()
    filename = name + ".txt"
    textfile = open(filename, "w")
    a = textfile.write(resp.html.html)
    textfile.close()
    data = open(filename, 'rb')
    s3Session.Bucket(bucket).put_object(Key = filename, Body = data)
    return


names = getNames("//mnt//c//Users//Zackw//Downloads//Zack and Eric Chess//")

made = makeBucket()

session = HTMLSession()
s3 = boto3.resource('s3')
for name in names[1:]:
    procedure(name, made, session, s3)

print("Done!")