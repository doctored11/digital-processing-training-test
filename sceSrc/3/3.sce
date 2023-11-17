function start()
    t = -0:0.0001:0.6;
    Fs = 8;
    S = 8;//типо N (на S забили - мы панки)

    // 1.6.3
//    signals = fillArrOfSignals(Fs / S, Fs, 3, 11);
//    interpolatedSignals = [];
////
//    for i = 1:length(signals)
//        plotCreate();
//        interpolatedSignal = signals(i);
//        subplot(1, 2, 1);
//
//       
//        [amplitude, time] = plotDrawDiscretizationHarmonicSignals(signals(i), t);
//        interpolatedSignal.amplitude = amplitude;
//        interpolatedSignal.time = time;
//        disp('--1--')
//        disp(size(interpolatedSignal.amplitude))
//        interpolatedSignals = [interpolatedSignals, interpolatedSignal];
//
//        dt = 1 / Fs;
//        t_discrete = min(t):dt:max(t);
//        subplot(1, 2, 2)
//        plotDrawHarmonicSignals(interpolatedSignal, t_discrete, 0);
//    end
////    
////
////
////   
//    clc()
//    for i = 1:length(interpolatedSignals)
//        zero_crossings = findZeroCrossings(interpolatedSignals(i));
//        figure()
//        plot(interpolatedSignals(i).time,interpolatedSignals(i).amplitude)
//        [period, frequency] = calculatePeriodAndFrequency(zero_crossings);
//        disp('Период сигнала ' + string(i) + ': ' + string(period));
//        disp('Частота сигнала ' + string(i) + ': ' + string(frequency));
//    end

//
//    
//    buffSignal = createSignal(10,3*Fs/5, %pi/4, '', 'r')

////
////    //1.7.1
////    
////    квантования это амплитуда а дискретизация это по времени 
    plotCreate();

     buffSignal = createSignal(10,Fs/(2*sqrt(S)), 0, '', 'r')
    discrSignal = plotDrawDiscretizationHarmonicSignals(buffSignal,t,Fs)
   quantizedSignal=  quantHarmonicSignal (discrSignal)
////     
//   
//////    
//
//меняя частоту дискр у одного сигнала
//        buffSig = createSignal(10,Fs/2, 0, '', '-b')
//        plotOriginalAndReconstructedSignal(buffSig,Fs/S,Fs,S)
// 



endfunction






////////////////////////
//вспомогательные 
////////////////////////
function signal = createSignal(amplitude, frequency, phase, name, style,t)
    signal = struct('amplitude',amplitude * cos(2*%pi*frequency*t + phase),'nominalAmplitude',amplitude, 'frequency', frequency, 'phase', phase, 'name', name, 'style', style, 'time',t);
endfunction

function addGridToPlot()
    clf();
    xgrid();
    
endfunction


function clr = getRandomColor(rndNum)
     colors = [ '-g', '-c', '-m', '-y', '-r'];
    if (rndNum == 0) || (rndNum > size(colors, 2)) then
        rndNum = ceil(rand() * length(colors));
    end

    clr = colors(rndNum); 
endfunction

function plotCreate()
 
    sleep(500);
    figure();
     addGridToPlot()
    sleep(100); 
endfunction


////////////////
//рисовалки
////////////////
function plotDrawHarmonicSignals(signals,t,_mode) 
    
     if nargin < 3 then
        _mode = 0;  
    end
//    addGridToPlot();
    legend_labels = []; 

    for i = 1:length(signals)
     if (_mode)   plotCreate() end;        

        
        
        plot(t, signals(i).amplitude, signals(i).style);
        legend_labels = [legend_labels, signals(i).name];
    end
//    legend(legend_labels);
    xlabel('Время');
    ylabel('Амплитуда');
    title('Гармонический сигнал');
endfunction
//

function [step_points, time] = plotDrawDiscretizationHarmonicSignals(signal, t,Fs)
    legend_labels = [];
    step_points = [];

    U0 = signal.nominalAmplitude;
    fr0 = signal.frequency;
    phase0 = signal.phase;

    dt = 1 / Fs;
    t_discrete = min(t):dt:max(t);
    style = getRandomColor(0);

    descrSignal = createSignal(U0, fr0, phase0, 'descr', sprintf('%s', style), t_discrete);
    amplDescr = descrSignal.amplitude;

    plot2d3(t_discrete, amplDescr);
    plotDrawHarmonicSignals(signal); 
    legend_labels = [legend_labels, signal.name];

    step_points = [t_discrete', amplDescr'];
    time = t_discrete; 
    xlabel('Время');
    ylabel('Амплитуда');
    title('Дискретизированный сигнал ' + signal.name);

endfunction

function quantizedSignal = quantHarmonicSignal(signal) //топ 10 перегруженных функций

    quantizationStep = (max(signal(:, 2)) - min(signal(:, 2))) / S;

    quantizedSignal = signal;

    for i = 1:size(signal, 1)
    quantizedSignal(i, 2) = floor((signal(i, 2) - min(signal(:, 2))) / quantizationStep+0.4) ;
    end
    // построение графика оригинального и квантованного 
    figure()
    clf();  
     subplot(1, 3, 1);
    plot(signal(:, 1), signal(:, 2));
    
    subplot(1, 3, 2);
    plot2d2(quantizedSignal(:, 1), quantizedSignal(:, 2));
    disp(quantizedSignal)
  
    xlabel('Время');
    ylabel('Уровень кванта');
    title('Квантование дискретизированного сигнала');
    
    quantizedSignal_U = quantizedSignal;
    
   quantizedSignal_U(:, 2) = quantizationStep * quantizedSignal_U(:, 2) - max(signal(:, 2));
    KP= signal(:, 2)(1)-quantizedSignal_U(:, 2)(1)//коэф погрешности - подгонка( чтоб покрасивее(первая точка была в нуле у востановленного кванта))
    disp(signal(:, 2)(1),quantizedSignal_U(:, 2)(1),signal(:, 2)(1)-quantizedSignal_U(:, 2)(1))
    quantizedSignal_U(:, 2)=quantizedSignal_U(:, 2)+KP

    disp("___")
    disp(signal(:, 2))
    disp(quantizedSignal_U(:, 2))
     quantizationError = signal(:, 2) - quantizedSignal_U(:, 2);
    disp("Погрешность квантования:")
    disp(quantizationError);
    
     subplot(1, 3, 3);
    histplot(length(quantizationError)+1, quantizationError);
    rms_value = sqrt(mean(quantizationError.^2));
    disp("Среднеквадратичное значение ошибки : " + string(rms_value));
    varianceValue = stdev(quantizationError);
    disp("Дисперсия ошибки квантования:"+string( varianceValue));    
   mean_error = mean(quantizationError);
    disp("Математическое ожидание ошибки: " + string(mean_error));

    
   

endfunction











///////////////////////////////////
/// сигналы - создание и функции
///////////////////////////////////

//discretizationStep =df ,discretizationFrequency=fd
function arr = fillArrOfSignals(discretizationStep, discretizationFrequency, N1, amplitude)
    fmax = N1 * discretizationFrequency+discretizationStep;
    arr = [];
    i=1
    for fr = discretizationStep:discretizationStep:fmax
        
        style =  getRandomColor(i);
        i=i+1;
        newSignal = createSignal(amplitude, fr, 0, sprintf('частота: %d', fr),sprintf('%s', style),t);
        arr = [arr, newSignal]; // Добавляем сигнал в массив arr
    end
    
    
    
    
endfunction

////////////
//y = y1 + (x - x1) / (x2 - x1) * (y2 - y1)
function zero_crossings = findZeroCrossings(signal)
    
    zero_crossings = [];

    for i = 2:1:length(signal.amplitude(:, 1))
       
       time =signal.amplitude(:, 1);
       amplitude =signal.amplitude(:, 2);
       
        if amplitude(i - 1) * amplitude(i) <= 0
            
            t1 = time(i - 1);
            t2 = time(i);
            a1 = amplitude(i - 1);
            a2 = amplitude(i);
            t_AcrossingZero = t1 + (t2 - t1) * a1 / (a1 - a2);
            
            zero_crossings = [zero_crossings, t_AcrossingZero];
        end
    end
endfunction



function [period, frequency] = calculatePeriodAndFrequency(zero_crossings)
    if length(zero_crossings) < 2
        disp('не ну нужно минимум 2 точки в нуле');
       period = 'не известно'; frequency = 'мало точек';
       return
   
end

    
    //разница между соседями
//    zero_crossings = unique(zero_crossings);
    time_diff = diff(zero_crossings);
     disp("пересечения с нулем")
 
   

    period = mean(time_diff)*2;
    frequency = 1 / period;
endfunction

//

function quantized_signal = quantizeSignalAutoMaxAmplitude(signal, N)
    //ну там N еще 2 в степени n - ну это как нибудь потом...
    disp(signal)
    U = max(signal(:,2)); 
    h = U / (N - 1); 
    quantized_signal = round(signal / h) * h;
endfunction




function plotOriginalAndReconstructedSignal(originalSignal, df, Fs, S)
  interpolatedSignals=[]
      t = originalSignal.time;
    
    for current_df = df:df:2 * Fs + df
        current_Fs = current_df;
       
        figure();
        
        subplot(1, 2, 1);


        plot(t,  originalSignal.amplitude)
          title(sprintf('df = %d', current_df));
          [amplitude, time] = plotDrawDiscretizationHarmonicSignals(originalSignal, t,current_df);
          interpolatedSignal = createSignal(10,0,0,0,0)
          interpolatedSignal.amplitude = amplitude;
          interpolatedSignal.time = time;

        interpolatedSignals =[interpolatedSignals, interpolatedSignal]
        

        subplot(1, 2, 2);
      
        plot(time, amplitude(:,2), 'g');
        title(sprintf('df = %d', current_df));
       
    end
    
    
    
       clc() //cорян забся
        for i = 1:length(interpolatedSignals) 
            
        zero_crossings = findZeroCrossings(interpolatedSignals(i));
//        figure()
//        plot(interpolatedSignals(i).time,interpolatedSignals(i).amplitude)
        [period, frequency] = calculatePeriodAndFrequency(zero_crossings);
        disp('Период сигнала ' + string(i) + ': ' + string(period));
        disp('Частота сигнала ' + string(i) + ': ' + string(frequency));
    end
    
endfunction
