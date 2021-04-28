import sys

def display_N_fibo(a,b,N):
    print("{:04x},".format(a),end='')
    print("{:04x},".format(b),end='')
    for i in range(N-2):
        c = a+b
        a = b
        b = c
        print("{:04x},".format(c),end='')
if __name__=="__main__":
    print("{},{},{}".format(int(sys.argv[1]),int(sys.argv[2]),int(sys.argv[3])))
    display_N_fibo(int(sys.argv[1]),int(sys.argv[2]),int(sys.argv[3]))
    print()