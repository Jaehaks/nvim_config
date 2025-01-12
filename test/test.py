import os
import time


def count(t):
    print('test')


def countdown(t: int):
    while t:
        mins, secs = divmod(t, 60)
        timer = '{:2d}:{:2d}'.format(mins)
        print(timer, end='\r')
        time.sleep(1)
        t -= 1
        print('Timer completed!')
        print(os.getcwd())


print()
t = input('Enter the time in seconds')
# t = 'est'
t = 300

# create a class
class Room:
    length = 0.0
    breadth = 0.0

    # method to calculate area
    def calculate_area(self):
        print("Area of Room =", self.length * self.breadth)

# create object of Room class
study_room = Room(r)

# assign values to all the properties
study_room.length = 42.5
study_room.breadth = 30.8

# access method inside class
study_room.calculate_area()


countdown(t)
count('test')


