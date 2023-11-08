t = -0:0.001:0.2;
Fs =44
S=8

function start()
    //1.6.2
    signals = fillArrOfSignals(S*2,Fs,2,11); //шаг дискретизации заложен ( должен быть в 2 раза больше частоты)
   
   
     interpolatedSignals=[]
     for i=1:length(signals)
          plotCreate()
          interpolatedSignal= signals(i); //3=i
          subplot(1,2,1)
          interpolatedSignal.amplitude = plotDrawDiscretizationHarmonicSignals(signals(i))(:, 2);//костылек (обрезаем время) + 3=i
          disp('--1--')
            disp(size(interpolatedSignal.amplitude))
//          interpolatedSignals=[interpolatedSignals,interpolatedSignal]
          
            dt = 1/Fs       //фиксируем для наблюдения последствий нарушения теоремы
//        dt = 1 / (4* signals(1).frequency);   //Котельников 2x+ 
         t_discrete = min(t):dt:max(t);
          subplot(1,2,2)
        plotDrawHarmonicSignals(interpolatedSignal,t_discrete,0); //востановлением занимается plot()
     end
     
         

////   //поиск частоты п 
//   
    clc()
    for i=1:length(interpolatedSignals)
   
         zero_crossings = findZeroCrossings(interpolatedSignals(i));
        
        [period, frequency] = calculatePeriodAndFrequency(zero_crossings);
        disp('Период сигнала ' + string(i) + ': ' + string(period));
        disp('Частота сигнала ' + string(i) + ': ' + string(frequency));
    end
//
//    //Построить график изменения частоты дискретизированного
//    //сигнала. Объяснить его особенности -- это не понял, частота же не меняется ( у одного сигнала)
////
////    //1.7.1
////    
////    
//    plotCreate();
//    buffSignal = createSignal(1, 3*Fs/5, 0, '1.7.1', 'r')
//    discrSignal = plotDrawDiscretizationHarmonicSignals(buffSignal)
////    
////    //1.7.2 - описание конечно я не понял 
////    N=2^9;// -но чем степень выше тем выше точность 
////    quantized_signal = quantizeSignalAutoMaxAmplitude(discrSignal, N);
////    plot2d2( quantized_signal(:,1),quantized_signal(:,2)); 
////    
////    //1.7.3 - не вообще не понял, не нашел инструкцию в методе к этому
////    

endfunction






////////////////////////
//вспомогательные 
////////////////////////
function signal = createSignal(amplitude, frequency, phase, name, style,t)
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


function step_points = plotDrawDiscretizationHarmonicSignals(signals)
    legend_labels = [];
    step_points = [];

    for i = 1:length(signals)
       
   
        U0=signals(i).nominalAmplitude;
        fr0 = signals(i).frequency; //- так надо для коректного квантования(это частота сигнала а не квантования)
        
        

//        dt = 1 / (4* signals(i).frequency);   //Котельников 2x+           
        dt = 1/Fs       //фиксируем для наблюдения последствий нарушения теоремы

        t_discrete = min(t):dt:max(t);
        style =  getRandomColor(0);
        
        descrSignal =  createSignal(U0, fr0, 0, 'descr',sprintf('%s', style),t_discrete)
        amplDescr =descrSignal.amplitude;
       
        
       
        plot2d3(t_discrete, amplDescr);
        plotDrawHarmonicSignals(signals(i)) //просто вывод исходного для наглядности
//        plot2d2(t_discrete, amplDescr);
        legend_labels = [legend_labels, signals(i).name];
      

        step_points = [step_points; [t_discrete', amplDescr']];
    end

//    legend(legend_labels);
    xlabel('Время');
    ylabel('Амплитуда');
    title('Дискретизированный сигнал');
endfunction





///////////////////////////////////
/// сигналы - создание и функции
///////////////////////////////////

//discretizationStep =df ,discretizationFrequency=fd
function arr = fillArrOfSignals(discretizationStep, discretizationFrequency, N1, amplitude)
    fmax = N1 * discretizationFrequency;
    arr = [];
    i=1
    for fr = discretizationStep:discretizationStep:fmax
        
        style =  getRandomColor(i);
        i=i+1;
        newSignal = createSignal(amplitude, fr, 0, '1',sprintf('%s', style),t);
        arr = [arr, newSignal]; // Добавляем сигнал в массив arr
    end
endfunction

////////////
//y = y1 + (x - x1) / (x2 - x1) * (y2 - y1)
function zero_crossings = findZeroCrossings(signal)
    
    zero_crossings = [];

    for i = 2:1:length(signal.amplitude)
       
        if signal.amplitude(i - 1) * signal.amplitude(i) <= 0
            t1 = t(i - 1);
            t2 = t(i);
            a1 = signal.amplitude(i - 1);
            a2 = signal.amplitude(i);
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
    zero_crossings = unique(zero_crossings);
    time_diff = diff(zero_crossings);
   

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

//1.7.3 - вопросы конечно

