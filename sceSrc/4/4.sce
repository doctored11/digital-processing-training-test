
//то что надо знать
Tc = 0.32;
U0=20;
Fd = 1000;
//для синусоид
U01 = 11;
U02=U0-U01;
f1 = 110;//частота
f2 = 15;
phase1 =%pi/6;
phase2 =%pi/4;

//

t =-Tc:1/Fd:Tc;

function start()
    
    //v1 одиночный импульс
   impulseSignal = createSingleImpulse(t, -Tc/2, Tc/2, U0)
 
  [amplitudeSpectrum, frequencies,Dpf] = computeDFT(impulseSignal, Fd);
  //обратный ДПФ
    ReverseDpf=ifft(Dpf)
  //СПМ (дпф на сопр вектор)
    Spm = amplitudeSpectrum.*conj(amplitudeSpectrum)
    
    
    
    //Построение графиков
    disp(amplitudeSpectrum)
    figure;
    subplot(2,2,1); plot(t, impulseSignal); xtitle('Исходный сигнал')
    subplot(2,2,2); plot(frequencies, amplitudeSpectrum); xtitle('ДПФ')
    subplot(2,2,3); plot(t, ReverseDpf); xtitle('ОДПФ')
    subplot(2,2,4); plot(frequencies, Spm); xtitle('СПМ')


    //v2 сумма синусоид 
//    тут по приколу используем самописные ДПФ и обратный ДПФ
    signals = [
        createSignal(U01, f1, phase1, '1', 'r-'),
        createSignal(U02, f2, phase2, '2', 'b-')
       ];
       
     result_sum = addSignals(signals(1), signals(2));
      [amplitudeSpectrum, frequencies,Dpf] = manualDFT(result_sum.amplitude, Fd); //перезаписываем - все равно не нужны старые
      
     //обратный ДПФ
    ReverseDpf=manualReverseDFT(Dpf)
    //спм
    Spm = amplitudeSpectrum.*conj(amplitudeSpectrum)
    //
    
    disp(size( amplitudeSpectrum.'))
    disp(size(frequencies))
     figure;
    subplot(2,2,1); plot(t, result_sum.amplitude); xtitle('Исходный сигнал')
       subplot(2,2,2); plot(frequencies, amplitudeSpectrum.'); xtitle('ДПФ')

    subplot(2,2,3); plot(t, ReverseDpf); xtitle('ОДПФ')
    subplot(2,2,4); plot(frequencies, Spm); xtitle('СПМ')

    
endfunction






////////////////////////
//вспомогательные 
////////////////////////
function signal = createSignal(amplitude, frequency, phase, name, style)
    signal = struct('amplitude',amplitude * sin(2*%pi*frequency*t + phase),'nominalAmplitude',amplitude, 'frequency', frequency, 'phase', phase, 'name', name, 'style', style);
endfunction

function addGridToPlot()
    clf();
    xgrid();
    
endfunction


function clr = getRandomColor(rndNum)
     colors = [ '--g', '--c', '--m', '--y', '--r'];
    if (rndNum == 0) || (rndNum > size(colors, 2)) then
        rndNum = ceil(rand() * length(colors));
    end

    clr = colors(rndNum); 
endfunction

function plotCreate()
    sleep(500);
    figure();
    sleep(100); 
endfunction

function impulseSignal = createSingleImpulse(t, t1, t2, Amplitude)
    impulseSignal = zeros(size(t));  
    impulseSignal(t > t1  ) = Amplitude;  //:(
    impulseSignal(t > t2  ) = 0;  
    
    plot(t, impulseSignal);           
    xlabel('Время');
    ylabel('Амплитуда');
    title('Одиночный импульс');
    
   
    a=get("current_axes");
    a.auto_scale = "off";
    a.data_bounds=[t1 *1.2,-Amplitude/4;t2*1.2,Amplitude*1.2];
    
endfunction

function [amplitudeSpectrum, frequencies, Dpf] = computeDFT(signal, Fd)
    N = size(signal)(2);//ищем кол-во точек в строке
     
    frequencies = Fd * (0:(N/2)) / N;
    
   
    Dpf = fft(signal);
     
    Dpfa = abs(Dpf(1:size(frequencies)(2)));

  
    amplitudeSpectrum = Dpfa;
   
endfunction
  


/////////////////////////////////////////////////
//////     Мат операции
////////////////////////////////////////////////
function result_signal = addSignals(signal1, signal2)
  

    result_amplitude = signal1.amplitude+signal2.amplitude;
    
    stl = getRandomColor(0);
    namePattern = '(%s) + (%s)'
    
    result_signal = createResByAmplitude(result_amplitude,namePattern,signal1,signal2)
endfunction
//


function result_signal = createResByAmplitude(amplitude,namePattern,signal1,signal2)
    
     result_signal = struct('amplitude',amplitude, ...
                            'nominalAmplitude',amplitude, ...
                           'frequency', signal1.frequency, ...
                           'phase', signal1.phase, ... 
                           'name', sprintf(namePattern, signal1.name, signal2.name), ...
                           'style', sprintf('%c', stl));
endfunction


//
// ручные dft без ttf и подобного
function [amplitudeSpectrum, frequencies, Dpf] = manualDFT(signal, Fs)
    N = length(signal); 
    amplitudeSpectrum = zeros(1, N); 
    frequencies = (0:N-1) * Fs / N; 

    for n = 1:N
        sumComplex = 0;

        for k = 1:N
            angle = -%i * 2 * %pi * (n-1) * (k-1) / N;
            sumComplex = sumComplex + signal(k) * exp(angle);
        end

        Dpf(n) = sumComplex/N;
    end

    amplitudeSpectrum = abs(Dpf);
    
endfunction

//
function signal = manualReverseDFT(Dpf)
    N = length(Dpf);
    signal = zeros(1, N);

    for n = 1:N
        sumComplex = 0;

        for k = 1:N
            angle = %i * 2 * %pi * (n-1) * (k-1) / N;
            sumComplex = sumComplex + Dpf(k) * exp(angle);
        end

        signal(n) = sumComplex ;
    end
endfunction

