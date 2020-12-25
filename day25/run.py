import math


def find_key(subj, loop_size):
    return pow(subj, loop_size, 20201227)  # pow(a,b,c)=~


def find_size(subj, value):
    i = 0
    val = 1
    while val != value:
        i = i+1
        val = (val * subj) % 20201227
    return i


pub_a = 10441485
pub_b = 1004920
loopA = 0
# find loop_size (SLOW)
# while find_key(7, loopA) != pub_a:
#     loopA += 1

# extra function (much faster!!!)
loopA = find_size(7, pub_a)

key = find_key(pub_b, loopA)
print('loop_size:', loopA)
print('encryption key:', key)
