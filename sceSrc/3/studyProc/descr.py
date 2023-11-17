import math

import numpy as np
import matplotlib.pyplot as plt


def generate_analog_signal(amplitude, frequency, phase, duration, sampling_rate):
    t = np.arange(0, duration, 0.0001)
    analog_signal = amplitude * np.cos(2 * np.pi * frequency * t + phase)
    return t, analog_signal


def quantize_signal(signal, quantization_levels, sampling_rate):
    quantization_step = (max(signal) - min(signal)) / quantization_levels
    quantized_signal = np.round((signal - min(signal)) / quantization_step).astype(int)

    qtime = np.arange(0, len(quantized_signal)) / sampling_rate

    return quantized_signal, qtime

def quantize_signal_U(signal, quantization_levels, sampling_rate):
    print(max(signal), min(signal));
    quantization_step = (max(signal) - min(signal)) / quantization_levels
    quantized_values = np.round((signal) / quantization_step).astype(int)
    quantized_signal = quantization_step * quantized_values

    qtime = np.arange(0, len(quantized_signal)) / sampling_rate

    return quantized_signal, qtime



def discretize_signal(analog_signal, sampling_rate):
    t_discrete = np.arange(0, analog_signal[0][-1], 1 / sampling_rate)[:len(analog_signal[1])]
    discrete_signal = np.interp(t_discrete, analog_signal[0], analog_signal[1])
    return t_discrete, discrete_signal


def calculate_quantization_error(original_signal, quantized_signal):
    quantization_error = original_signal - quantized_signal

    for original, quantized in zip(original_signal, quantized_signal):
        print(f'Входной: {original}, Квантованый: {quantized}, Результат: {original - quantized}')

    return quantization_error


def plot_signals(analog_signal, discrete_signal, quantized_signal,quantized_signal_U, quantization_levels):
    plt.figure(figsize=(12, 10))

    plt.subplot(3, 1, 1)
    plt.plot(analog_signal[0], analog_signal[1], label='Аналоговый')
    plt.title('Аналоговый Сигнал')
    plt.xlabel('Время')
    plt.ylabel('Амплитуда')
    plt.legend()

    plt.stem(discrete_signal[0], discrete_signal[1], linefmt='r-', markerfmt='ro', basefmt='k-',
             label='Дискретный')
    plt.title('Исходный сигнал')
    plt.xlabel('Времяя')
    plt.ylabel('Амплитуда')
    plt.legend()

    quantization_levels = np.arange(quantization_levels + 1)
    binary_levels = [binary_repr(level) for level in quantization_levels]

    plt.subplot(3, 1, 2)
    plt.step(qtime, quantized_signal, 'o-', label='Квантованный', markersize=5)
    plt.yticks(quantization_levels, binary_levels)
    plt.ylim(-0.5, quantization_levels[-1] + 0.5)
    plt.grid(axis='y', linestyle='--', alpha=0.7)

    plt.title('Квантованный сигнал')
    plt.xlabel('Время')
    plt.ylabel('Уровень квантования')
    plt.legend()

    plt.tight_layout()


    plt.subplot(3, 1, 3)
    plt.plot(analog_signal[0], analog_signal[1], label='Аналоговый')
    plt.title('Аналоговый Сигнал')
    plt.xlabel('Время')
    plt.ylabel('Амплитуда')
    plt.legend()

    plt.stem(discrete_signal[0], discrete_signal[1], linefmt='r-', markerfmt='ro', basefmt='k-',
             label='Дискретный')
    plt.title('Дискретный сигнал')
    plt.xlabel('Время')
    plt.ylabel('Амплитуда')
    plt.legend()


    plt.step(qtime, quantized_signal_U, 'o-', label='Квантованный', markersize=5)


    plt.grid(axis='y', linestyle='--', alpha=0.7)

    plt.title('Квантованный сигнал')
    plt.xlabel('Время')
    plt.ylabel('Уровень квантования')
    plt.legend()

    plt.tight_layout()



def plot_histogram(quantization_error):
    plt.figure(figsize=(12, 12))
    plt.hist(quantization_error, bins='auto', color='blue', edgecolor='black')
    plt.title('Гистограмма ошибки квантования')
    plt.xlabel('Ошибка')
    plt.ylabel('Частота')

def binary_repr(value, width=4):

    binary_str = bin(value)[2:]
    return binary_str.zfill(width)


# --------
#
# тчк входа
# --------


# sampling_rate = 256
# quantization_levels = 15
#
# amplitude = 5
# frequency =11
# phase = math.pi
# duration = 0.5
#
# analog_signal = generate_analog_signal(amplitude, frequency, phase, duration, sampling_rate)
#
# discrete_signal = discretize_signal(analog_signal, sampling_rate)
#
# quantized_signal, qtime = quantize_signal(discrete_signal[1], quantization_levels, sampling_rate)
# quantized_signal_U, _ = quantize_signal_U(discrete_signal[1], quantization_levels, sampling_rate)
#
# quantization_error = calculate_quantization_error(discrete_signal[1], quantized_signal_U)
#
# plot_signals(analog_signal, discrete_signal, quantized_signal,quantized_signal_U, quantization_levels)
# plot_histogram(quantization_error)
#
# plt.show()



# прочий бред

data = [
"мало точек",
2,
2.8284271,
4,
2.8284271,
2,
"мало точек",
"мало точек",
"мало точек",
2,
2.8284271,
4,
2.8284271,
2,
"мало точек",
"мало точек",
"мало точек",
2,
2.8284271,
4,
2.8284271,
2,
"мало точек",
"мало точек",
"мало точек"

]

# Замена 'мало точек' на 0
data = [x if isinstance(x, (float, int)) else 0 for x in data]

plt.plot(data, marker='*', color='green',alpha=0.4)
plt.title('График восстановленных частот')

plt.ylabel('Частоты')

# # Найти индекс первого пика
# first_peak_index = data.index(max(data[:len(data)//2], key=lambda x: (isinstance(x, (float, int)), x)))
#
# # Добавить вертикальную пунктирную линию
# plt.axvline(x=first_peak_index, linestyle='--', color='gray')

# Добавить подпись с частотой
# plt.text(first_peak_index, max(data), f'Частота: {data[first_peak_index]}', rotation=90, va='top')

plt.show()