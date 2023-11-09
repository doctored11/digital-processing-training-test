import numpy as np
import matplotlib.pyplot as plt
import random



sampling_rate = 1000
duration = 10.0
t = np.linspace(0, duration, int(sampling_rate * duration), endpoint=False)

# генерим случайные гармоники с разными амплитудами и фазами
num_harmonics = 150
amplitudes = np.random.uniform(0.5, 2.0, num_harmonics)
frequencies = np.random.uniform(1, 6, num_harmonics)


signal = np.zeros_like(t)  # Инициализация сигнала нулями


for i in range(num_harmonics):
    harmonic = amplitudes[i] * np.sin(2 * np.pi * frequencies[i] * t )
    signal += harmonic

    print(f'Гармоника {i + 1}: Амплитуда = {amplitudes[i]}, Частота = {frequencies[i]} Герц, ')


plt.figure(figsize=(12, 8))

# Первый график - сигнал
plt.subplot(3, 1, 1)
plt.plot(t, signal)
plt.xlabel('Время (секунды)')
plt.ylabel('Амплитуда')
plt.title('a) Сигнал из  случайных гармоник')
plt.grid(True)


#вторй
frequency3 = np.random.uniform(6, 10)
amplitude3 = np.random.uniform(2.0, 3.0)
harmonic3 = amplitude3 * np.sin(2 * np.pi * frequency3 * t)
#если нужно совпадение раскоментить
#i =  random.randint(0, num_harmonics);
#harmonic3 = amplitudes[i] * np.sin(2 * np.pi * frequencies[i] * t)

# рис второй
plt.subplot(3, 1, 2)
plt.plot(t, amplitude3 * np.sin(2 * np.pi * frequency3 * t))
plt.xlabel('Время (секунды)')
plt.ylabel('Амплитуда')
plt.title('б) Якобы случайная частота')
plt.grid(True)

# Третий график  - результат умножения двух пред
result_signal = harmonic3 * signal
plt.subplot(3, 1, 3)
plt.plot(t, result_signal, color='blue')
plt.fill_between(t, 0, result_signal, where=(result_signal >= 0), color='green', alpha=0.5)
plt.fill_between(t, 0, result_signal, where=(result_signal < 0), color='red', alpha=0.5)
plt.xlabel('Время (секунды)')
plt.ylabel('Амплитуда')
plt.title('c) частота, умноженная на исследуемый сигнал')
plt.grid(True)

# вычисление площадей
area_above_zero = np.trapz(result_signal[result_signal >= 0], dx=t[1] - t[0])
area_below_zero = np.trapz(result_signal[result_signal < 0], dx=t[1] - t[0])

print(f'Площадь над нулем (зеленая): {area_above_zero}')
print(f'Площадь под нулем (красная): {area_below_zero}')

plt.tight_layout()
plt.show()
