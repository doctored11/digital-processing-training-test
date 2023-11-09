import numpy as np
import matplotlib.pyplot as plt

# Параметры сигнала
sampling_rate = 1000  # Частота дискретизации
duration = 10.0
t = np.linspace(0, duration, int(sampling_rate * duration), endpoint=False)  # Временная ось

min_gen_fr = 2
max_gen_fr = 6
min_research_fr = 0.1
max_research_fr = 10

# создание случайных гармоник с разными амплитудами и фазами
num_harmonics = 150
amplitudes = np.random.uniform(0.5, 2.0, num_harmonics)
frequencies = np.random.uniform(min_gen_fr, max_gen_fr, num_harmonics)

signal = np.zeros_like(t)

# Создание сигнала из гармоник
for i in range(num_harmonics):
    harmonic = amplitudes[i] * np.sin(2 * np.pi * frequencies[i] * t)
    signal += harmonic
    print(f'Гармоника {i + 1}: Амплитуда = {amplitudes[i]}, Частота = {frequencies[i]} Герц')

research_frequencies = np.arange(min_research_fr, max_research_fr + 0.01, 0.01)
areas = {}

for frequency in research_frequencies:
    research_signal = 10 * np.sin(2 * np.pi * frequency * t)
    result_signal = research_signal * signal
    area_above_zero = np.trapz(result_signal[result_signal >= 0], dx=t[1] - t[0])
    area_below_zero = np.trapz(result_signal[result_signal < 0], dx=t[1] - t[0])
    total_area = area_above_zero + area_below_zero
    areas[frequency] = total_area

# Отображение исходного сигнала и столбчатой диаграммы
plt.figure(figsize=(12, 12))

# Первый график: сигнал
plt.subplot(2, 1, 1)
plt.plot(t, signal)
plt.xlabel('Время (секунды)')
plt.ylabel('Амплитуда')
plt.title('a) Сигнал из случайных гармоник')
plt.grid(True)

# Второй график: столбчатая диаграмма
plt.subplot(2, 1, 2)
freq_values = list(areas.keys())
area_values = list(areas.values())
plt.bar(freq_values, area_values, width=0.5)
plt.xlabel('Частота (Герц)')
plt.ylabel('Сумма площадей')
plt.title('b) Столбчатая диаграмма частоты по площади')
plt.grid(True)

plt.tight_layout()
plt.show()
