import matplotlib.pyplot as plt
import numpy as np


fig, axs = plt.subplots(2, 3, figsize=(12, 6))


t = np.linspace(0, 2 * np.pi, 1000)
frequencies = [1, 2, 3, 4, 5, 6]  # Частоты синусоид


for i, ax in enumerate(axs.flat):
    ax.set_title(f'')
    for j in range(i + 1):
        y = np.sin(frequencies[j] * t)
        ax.plot(t, y)

# создаем допо холсты для нече и чет частот
fig_odd, axs_odd = plt.subplots(1, 1, figsize=(4, 3))
fig_even, axs_even = plt.subplots(1, 1, figsize=(4, 3))

odd_frequencies = [f for f in frequencies if f % 2 != 0]
even_frequencies = [f for f in frequencies if f % 2 == 0]

# поиск пересечений
def find_intersection_points(freqs, t):
    intersection_points = []
    y_values = [np.sin(freq * t) for freq in freqs]
    for i in range(len(t)):
        y_values_at_time = [y[i] for y in y_values]
        if all(round(y_val, 1) == round(y_values_at_time[0], 1) for y_val in y_values_at_time):
            intersection_points.append((t[i], y_values_at_time[0]))
    return intersection_points


intersection_points_odd = find_intersection_points(odd_frequencies, t)
intersection_points_even = find_intersection_points(even_frequencies, t)


for freq in odd_frequencies:
    y = np.sin(freq * t)
    axs_odd.plot(t, y)

axs_odd.set_title('Синусоиды с нечетными частотами')
axs_odd.legend()


for freq in even_frequencies:
    y = np.sin(freq * t)
    axs_even.plot(t, y)

axs_even.set_title('Синусоиды с четными частотами')
axs_even.legend()


intersection_points_odd = list(zip(*intersection_points_odd))
intersection_points_even = list(zip(*intersection_points_even))
axs_odd.plot(intersection_points_odd[0], intersection_points_odd[1], 'ro', markersize=5)
axs_even.plot(intersection_points_even[0], intersection_points_even[1], 'ro', markersize=5)

plt.show()
