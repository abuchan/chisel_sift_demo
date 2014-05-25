#!/usr/bin/python

import glob

def part_info(filename):
  name = filename.split('/')[-1]
  start_file = open(filename + '/start')
  size_file = open(filename + '/size')
  start = int(start_file.read())
  size = int(size_file.read())
  info = {'name':name, 'start':start, 'size':size}
  start_file.close()
  size_file.close()
  return info

# Return number of bytes necessary to image partitions with 16M buffer at end
def total_size(infos):
  max_part = 0
  for part in infos:
    part_end = part['start'] + part['size']
    if part_end > max_part:
      max_part = part_end
  # Assuming 512 block size, how constant is this?
  return int((max_part * 512) + 16*1024*1024)

def print_info(device, infos):
  info_list = []
  for part in infos:
    info_list.append('%s: %dM' % (part['name'],int(part['size']*512/(1024*1024))))
  info_list.sort()
  print 'Partition info for %s is:' % device
  for i in info_list:
    print '  ' + i

dev = raw_input("Enter device name (e.g. sdb): ")

parts = glob.glob('/sys/block/%s/%s*' % (dev,dev))

infos = [part_info(p) for p in parts]

print_info(dev, infos)

#n_bytes = total_size(infos)
n_bytes = 10*4*1024*1024

total_M = n_bytes/(1024*1024)

cont = raw_input('\nImage will be %sM. Continue (yes/no)? ' % total_M)

import subprocess

if cont == 'yes':
  outfile = raw_input('Enter output file: ')
  n_blocks = n_bytes/(4*1024*1024)
  w_proc = subprocess.Popen(['which','pv'],stdout=subprocess.PIPE)
  use_pv = (len(w_proc.communicate()[0]) > 0)
  
  if use_pv:
    fstr =  'pv /dev/%s -s %d | dd of=%s bs=4M count=%d iflag=fullblock'
    cmd = fstr % (dev,n_bytes,outfile,n_blocks) 
  else:
    cmd = 'dd if=/dev/%s of=%s bs=4M count=%d' % (dev,outfile,n_blocks)
  print 'Use this command: %s' % cmd
else:
  print 'Aborted, exiting'
