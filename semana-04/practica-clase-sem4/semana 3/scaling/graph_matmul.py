import matplotlib.pyplot as plt

threads = [1, 2, 3, 4, 5, 6, 7, 8]
times = [
    0.926556,
    0.535680,
    0.471824,
    0.431698,
    0.486611,
    0.446599,
    0.363660,
    0.534611
]

plt.figure(figsize=(8, 5))

plt.plot(threads, times, marker="o", color="orange")

plt.title("Matmul")
plt.xlabel("Number of Threads")
plt.ylabel("Execution Time (s)")

plt.xticks(threads)
plt.grid(True)

plt.tight_layout()
plt.savefig("matmul.png", dpi=300)
plt.show()