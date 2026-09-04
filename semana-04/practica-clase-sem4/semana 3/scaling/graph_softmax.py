import matplotlib.pyplot as plt

threads = [1, 2, 3, 4, 5, 6, 7, 8]
times = [
    1.140511,
    0.839102,
    0.797587,
    0.838317,
    0.882432,
    0.975839,
    1.093668,
    2.731647
]

plt.figure(figsize=(8, 5))

plt.plot(threads, times, marker="o", color="lightgreen")

plt.title("Softmax")
plt.xlabel("Number of Threads")
plt.ylabel("Execution Time (s)")

plt.xticks(threads)
plt.grid(True)

plt.tight_layout()
plt.savefig("softmax.png", dpi=300)
plt.show()