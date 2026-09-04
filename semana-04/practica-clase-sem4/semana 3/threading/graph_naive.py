import matplotlib.pyplot as plt

threads = [1, 2, 3, 4, 5, 6, 7, 8]
times = [4.615, 4.627, 4.733, 5.247, 5.806, 7.091, 8.726, 9.054]

plt.figure(figsize=(8, 5))

plt.plot(threads, times, marker="o", color="cyan")

plt.title("CPU Naive")
plt.xlabel("Number of Threads")
plt.ylabel("Execution Time (s)")

plt.xticks(threads)
plt.grid(True)

plt.tight_layout()
plt.savefig("naive.png", dpi=300)
plt.show()