#Hugo BERANGER - M2 MIAGE IA

import timeit
import os
import pandas as pd
import numpy as np

#CHANGER LES VARIABLES D'ENVIRONNEMENT AVANT L'EXECUTION DU PROGRAMME
#source /home/hugo/Downloads/setenv_AOCC.sh"
#source /opt/intel/oneapi/setvars.sh"

repeat = 10
number = 1000
print("=====================================================================================================================")
########################## C++/G++  ##########################
os.chdir("c++/graphe")
cplus_compile_gcc = "g++ dijkstra.cpp -o dijkstra"
os.system("g++ --version ;" + cplus_compile_gcc)

cplus = """
import os
os.system("./dijkstra")"""

cplus_runtime_gcc = timeit.repeat(cplus, repeat=repeat, number=number)

########################## C++/G++ -O1 ##########################
cplus_compile_gcc_o1 = "g++ dijkstra.cpp -o dijkstra -O1"
os.system(cplus_compile_gcc_o1)

cplus_runtime_gcc_o1 = timeit.repeat(cplus, repeat=repeat, number=number)

########################## C++/G++ -O2 ##########################
cplus_compile_gcc_o2 = "g++ dijkstra.cpp -o dijkstra -O2"
os.system( cplus_compile_gcc_o2)

cplus_runtime_gcc_o2 = timeit.repeat(cplus, repeat=repeat, number=number)

########################## C++/G++ -O3 ##########################
cplus_compile_gcc_o3 = "g++ dijkstra.cpp -o dijkstra -O3"
os.system(cplus_compile_gcc_o3)

cplus_runtime_gcc_o3 = timeit.repeat(cplus, repeat=repeat, number=number)

########################## C++/G++ -Ofast ##########################
cplus_compile_gcc_ofast = "g++ dijkstra.cpp -o dijkstra -Ofast"
os.system(cplus_compile_gcc_ofast)

cplus_runtime_gcc_ofast = timeit.repeat(cplus, repeat=repeat, number=number)

print("=====================================================================================================================")
########################## C++/AOCC ##########################
cplus_compile_aocc = "clang++ dijkstra.cpp -o dijkstra"
os.system("clang++ --version ;" + cplus_compile_aocc)

cplus_runtime_aocc = timeit.repeat(cplus, repeat=repeat, number=number)

########################## C++/AOCC -O1 ##########################
cplus_compile_aocc_o1 = "clang++ dijkstra.cpp -o dijkstra -O1"
os.system(cplus_compile_aocc_o1)

cplus_runtime_aocc_o1 = timeit.repeat(cplus, repeat=repeat, number=number)

########################## C++/AOCC -O2 ##########################
cplus_compile_aocc_o2 = "clang++ dijkstra.cpp -o dijkstra -O2"
os.system(cplus_compile_aocc_o2)

cplus_runtime_aocc_o2 = timeit.repeat(cplus, repeat=repeat, number=number)

########################## C++/AOCC -O3 ##########################
cplus_compile_aocc_o3 = "clang++ dijkstra.cpp -o dijkstra -O3"
os.system(cplus_compile_aocc_o3)

cplus_runtime_aocc_o3 = timeit.repeat(cplus, repeat=repeat, number=number)

########################## C++/AOCC -Ofast ##########################
cplus_compile_aocc_ofast = "clang++ dijkstra.cpp -o dijkstra -Ofast"
os.system(cplus_compile_aocc_ofast)

cplus_runtime_aocc_ofast = timeit.repeat(cplus, repeat=repeat, number=number)

########################## C++/AOCC -Ofast ##########################
cplus_compile_aocc_ofast = "clang++ dijkstra.cpp -o dijkstra -Ofast"
os.system(cplus_compile_aocc_ofast)

cplus_runtime_aocc_ofast = timeit.repeat(cplus, repeat=repeat, number=number)

print("=====================================================================================================================")
########################## C++/Intel ##########################
cplus_compile_intel = "dpcpp dijkstra.cpp -o dijkstra"
os.system("dpcpp --version ; " +cplus_compile_intel)

cplus_runtime_intel = timeit.repeat(cplus, repeat=repeat, number=number)

########################## C++/Intel -O1 ##########################
cplus_compile_intel_o1 = "dpcpp dijkstra.cpp -o dijkstra -O1"
os.system(cplus_compile_intel_o1)

cplus_runtime_intel_o1 = timeit.repeat(cplus, repeat=repeat, number=number)

########################## C++/Intel -O2 ##########################
cplus_compile_intel_o2 = "dpcpp dijkstra.cpp -o dijkstra -O2"
os.system(cplus_compile_intel_o2)

cplus_runtime_intel_o2 = timeit.repeat(cplus, repeat=repeat, number=number)

########################## C++/Intel -O3 ##########################
cplus_compile_intel_o3 = "dpcpp dijkstra.cpp -o dijkstra -O3"
os.system(cplus_compile_intel_o3)

cplus_runtime_intel_o3 = timeit.repeat(cplus, repeat=repeat, number=number)

########################## C++/Intel -Ofast ##########################
cplus_compile_intel_ofast = "dpcpp dijkstra.cpp -o dijkstra -Ofast"
os.system(cplus_compile_intel_ofast)

cplus_runtime_intel_ofast = timeit.repeat(cplus, repeat=repeat, number=number)

print("=====================================================================================================================")
########################## RUST/rustc ##########################
os.chdir("../..")
os.chdir("rust/graphe/src")
rust_compile = "rustc main.rs"
os.system("rustc --version ; " +rust_compile)

rust = """
import os
os.system("./main")"""

rust_runtime = timeit.repeat(rust, repeat=repeat, number=number)

########################## RUST/rustc -C opt-level=1 ##########################
rust_compile_1 = "rustc -C opt-level=1 main.rs"
os.system(rust_compile_1)

rust_runtime_1 = timeit.repeat(rust, repeat=repeat, number=number)

########################## RUST/rustc -C opt-level=2 ##########################
rust_compile_2 = "rustc -C opt-level=2 main.rs"
os.system(rust_compile_2)

rust_runtime_2 = timeit.repeat(rust, repeat=repeat, number=number)

########################## RUST/rustc -C opt-level=3 ##########################
rust_compile_3 = "rustc -C opt-level=3 main.rs"
os.system(rust_compile_3)

rust_runtime_3 = timeit.repeat(rust, repeat=repeat, number=number)

print("=====================================================================================================================")
########################## DATA ##########################
times_df = pd.DataFrame()

times_df["g++"] = cplus_runtime_gcc
times_df["g++ -O1"] = cplus_runtime_gcc_o1
times_df["g++ -O2"] = cplus_runtime_gcc_o2
times_df["g++ -O3"] = cplus_runtime_gcc_o3
times_df["g++ -Ofast"] = cplus_runtime_gcc_ofast

times_df["aocc"] = cplus_runtime_aocc
times_df["aocc -O1"] = cplus_runtime_aocc_o1
times_df["aocc -O2"] = cplus_runtime_aocc_o2
times_df["aocc -O3"] = cplus_runtime_aocc_o3
times_df["aocc -Ofast"] = cplus_runtime_aocc_ofast

times_df["intel"] = cplus_runtime_intel
times_df["intel -O1"] = cplus_runtime_intel_o1
times_df["intel -O2"] = cplus_runtime_intel_o2
times_df["intel -O3"] = cplus_runtime_intel_o3
times_df["intel -Ofast"] = cplus_runtime_intel_ofast

times_df["rustc"] = rust_runtime
times_df["rustc -1"] = rust_runtime_1
times_df["rustc -2"] = rust_runtime_2
times_df["rustc -3"] = rust_runtime_3

mini = pd.DataFrame(times_df.min()).transpose()
maxi = pd.DataFrame(times_df.max()).transpose()
mean = pd.DataFrame(times_df.mean()).transpose()

score = times_df.mean()
max_score = score.max()

# print(score.iloc[0:0])

# for x in range(len(score)):
#     score.iloc[x:1] = round((score.iloc[x:1]/max_score)*100)

# print("score :", score)

# score = pd.DataFrame(score).transpose()

times_df = times_df.append(mini, ignore_index=True)
times_df = times_df.append(maxi, ignore_index=True)
times_df = times_df.append(mean, ignore_index=True)
#times_df = times_df.append(score, ignore_index = True)
times_df = times_df.rename({repeat:'min'})
times_df = times_df.rename({repeat+1:'max'})
times_df = times_df.rename({repeat+2:'mean'})
#times_df = times_df.rename({repeat+3:'score'})

print(times_df)
os.chdir("../../..")
times_df.to_csv (r"execution_times.csv", header=True)
