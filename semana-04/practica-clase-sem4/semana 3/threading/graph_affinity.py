import matplotlib.pyplot as plt

hilos = [1, 2, 3, 4, 5, 6, 7, 8]
tiempos = [6.04, 5.30, 6.36, 6.96, 7.81, 7.93, 10.09, 10.52]

plt.figure(figsize=(8, 5))

plt.plot(hilos, tiempos, marker="o", color = "pink")

plt.title("CPU Affinity")
plt.xlabel("Number of Threads")
plt.ylabel("Execution Time (s)")

plt.xticks(hilos)
plt.grid(True)
 
plt.tight_layout()
plt.savefig("affinity.png", dpi=300)
plt.show()