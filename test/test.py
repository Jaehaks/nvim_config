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


# t = input('Enter the time in seconds')
# t = 'est'
t = 300


countdown(t)
count('test')
