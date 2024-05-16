import time
import os
def greeting(name: str) -> str:
    return 0

def countdown(t):
    while t:
        mins, secs = divmod(t,60)
        timer = '{:02d}:{02d}'.format(mins,)
        print(timer, end='\r')
        time.sleep(1)
        t -= 1
    print('Timer completed!')    
    print(os.getcwd())

# t = input('Enter the time in seconds')    
t = 'est'
# countdown(int(t))
countdown(t)

