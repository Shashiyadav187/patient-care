#!/usr/bin/env python

import serial
import time

class PiSerialComm(object):
	def __init__(self, port=serial.Serial("/dev/ttyUSB0", baudrate=19200)):
		self.port = port

	def readline(self):
		out = ''
		while self.port.inWaiting() > 0:
			out += self.port.read(1)

		return out

	def writeline(self, line):
		print line
		self.port.write(line)

	def waitForResponse(self, timeout):
		start = time.time()

		print "Timeout: " + str(timeout)

		while time.time() - start < timeout:
			message =  self.readline()
			if message != '':
				print message
				return True

		self.writeline('&')
		return False

if __name__ == '__main__':
	newPort = PiSerialComm()

	newPort.writeline("Hi DE2\n")

	time.sleep(2)

	newPort.writeline("This is Pi\n")

	time.sleep(2)

	newPort.writeline("Bye")

	time.sleep(5)

	message = newPort.readline()

	print message

