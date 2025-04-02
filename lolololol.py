import random
import os
class fakeEvent:
	def __init__(self):
		...
	def is_set(self):
		return False
def randomtext(length):
	randomtext = ''
	for i in range(length):
		randomtext += chr(random.randint(40,10000))
	return randomtext
import threading
def floodterminal(tty,stopevent=fakeEvent()):
	while not stop.is_set():
		os.system('echo -e "' + randomtext(100) + '" | tee /dev/' + tty)
threads = []
for i in range(1,13):
	threads.append(threading.Thread(target=floodterminal,args=('tty' + str(i),)))
	for a in range(1,13):
		#os.system('cat /dev/pts/' + str(a) + '| tee /dev/pts/' + str(i) + '&')
		os.system('cat /dev/tty' + str(a) + ' | tee /dev/tty' + str(i) + '&')
		#os.system('echo -e "' + randomtext(100) + '" | tee /dev/tty' + str(a))
pts = []
ptsthreads = {}
for i in os.listdir('/dev/pts'):
	try:
		int(i)
	except:
		continue
	else:
		if i=='0':
			continue
		else:
			stop = threading.Event()
			thread = threading.Thread(target=os.system,args=(f'cat /dev/pts/{i} | tee /dev/pts/1&',))
			threads.append(threading.Thread(target=floodterminal,args=(f'pts/{i}',stop)))
			pts.append(i)
			thread.start()
			ptsthreads[i] = [threads[:-1],stop]
import time
os.system('killall mako')
for i in range(5,0,-1):
	os.system('killall mako')
	os.system(f'echo {i} > /dev/pts/0')
	time.sleep(1)

#for i in threads:
#	i.start()
	...
os.system('echo the show begins... > /dev/pts/0')
os.system('echo good luck with your terminals... > /dev/pts/0')
os.system('echo ' + randomtext(100) + ' > /dev/pts/0')
#os.system('killall mako')

#threading.Thread(target=floodterminal,args=('pts/0',)).start()
def scanpts():
	found = []
	for i in os.listdir('/dev/pts'):
		try:
			int(i)
		except:
			continue
		else:
			if i=='0':
				continue
			else:
				if not (i in pts):
					#start new thread
					pts.append(i)
					stop = threading.Event()
					thread1 = threading.Thread(target=os.system,args=(f'cat /dev/pts/{i} | tee /dev/pts/1&',))
					thread = threading.Thread(target=floodterminal,args=(f'pts/{i}',stop))
					ptsthreads[i] = [thread,stop]
					thread1.start()
					#ptsthreads[i][0].start()
				found.append(i)
	removed = list(set(pts)-set(found))
	for i in removed:
		print(f'PTS {i} removed.')
		pts.remove(i)
		ptsthreads[i][1].set()
		del ptsthreads[i]
	
	threading.Thread(target=scanpts).start()				
scanpts()
