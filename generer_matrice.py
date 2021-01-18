# Hugo BERANGER - M2 MIAGE IA

import random

f1 = open("matrice1.txt", "w")
f2 = open("matrice2.txt", "w")
dim = 500

for i in range (dim):
    for x in range (dim):
        r = random.uniform(0.0,1000.0)
        f1.write(str(r)+"\n")
        r = random.uniform(0.0,1000.0)
        f2.write(str(r)+"\n")
f1.close()
f2.close()