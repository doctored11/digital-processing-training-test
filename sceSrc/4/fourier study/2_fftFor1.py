import numpy as np
import matplotlib.pyplot as plt

# Параметры сигнала
sampling_rate = 1000  # Частота дискретизации (Герц)
duration = 1.0  # Длительность сигнала (секунды)
t = np.linspace(0, duration, int(sampling_rate * duration), endpoint=False)  # Временная ось

# Генерация двух случайных гармоник
frequency1 = np.random.uniform(1, 6)  # Частота первой гармоники (Герц)
amplitude1 = np.random.uniform(0.5, 2.0)  # Амплитуда первой гармоники
harmonic1 = amplitude1 * np.sin(2 * np.pi * frequency1 * t)

frequency2 = np.random.uniform(1, 6)  # Частота второй гармоники (Герц)
amplitude2 = np.random.uniform(0.5, 2.0)  # Амплитуда второй гармоники
harmonic2 = amplitude2 * np.sin(2 * np.pi * frequency2 * t)


frequency3 = np.random.uniform(6, 10)  # Частота второй гармоники (Герц)
amplitude3 = np.random.uniform(0.5, 2.0)  # Амплитуда второй гармоники
harmonic3 = amplitude3 * np.sin(2 * np.pi * frequency3 * t)
harmonic3 = harmonic2
# Сложение гармоник
signal = harmonic1 + harmonic2

# Отображение исходного сигнала
plt.figure(figsize=(12, 8))
plt.subplot(3, 1, 1)
plt.plot(t, signal)
plt.xlabel('Время (секунды)')
plt.ylabel('Амплитуда')
plt.title('а) Исходный сигнал')
plt.grid(True)

# Отображение первой гармоники
plt.subplot(3, 1, 2)
plt.plot(t, harmonic3)
plt.xlabel('Время (секунды)')
plt.ylabel('Амплитуда')
plt.title('б) Якобы случайная частота')
plt.grid(True)

# Отображение умножения первой гармоники на сигнал и закраска
result_signal = harmonic3 * signal
plt.subplot(3, 1, 3)
plt.plot(t, result_signal, color='blue')
plt.fill_between(t, 0, result_signal, where=(result_signal >= 0), color='green', alpha=0.5)
plt.fill_between(t, 0, result_signal, where=(result_signal < 0), color='red', alpha=0.5)
plt.xlabel('Время (секунды)')
plt.ylabel('Амплитуда')
plt.title('c) частота, умноженная на исследуемый сигнал ')
plt.grid(True)

# Вычисление площадей
area_above_zero = np.trapz(result_signal[result_signal >= 0], dx=t[1] - t[0])
area_below_zero = np.trapz(result_signal[result_signal < 0], dx=t[1] - t[0])

# Вывод площадей на экран
print(f'Площадь над нулем (зеленая): {area_above_zero}')
print(f'Площадь под нулем (красная): {area_below_zero}')

plt.tight_layout()
plt.show()
