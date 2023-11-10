 t = -1:0.001:15


tau=1;
function start()
    signals = [
        createSignal(2, 0.5, %pi/4, '1', 'r-'),
        createSignal(1, 0.5, -%pi/6, '2', 'b-')
       ];
       
   result_sum = addSignals(signals(1), signals(2));
   result_substract= subtractSignals(signals(1), signals(2));
   result_multy = multiplySignals(signals(1), signals(2));
   result_devide = devideSignals(signals(1), signals(2));
   
   //то что нужно - просто раскоментируй ) Ctrl + shift+D
   //и вызов start())
   signals = [
            signals;
//            result_sum;
//            result_substract;
//            result_multy;
            result_devide;
            ];
//   plotCreate() ;
//   plotDrawHarmonicSignals(signals);
//   
//   plotCreate();
//   plotLissajousFigure(signals(1), signals(2));
//   
//   plotCreate()
//   plotLissajousWithPhaseShift(signals(1), signals(2));
////   
   plotCreate() 
   plotLissajousWithFrequencyShift(signals(1), signals(2));
   
//plotCreate() ;
//clf()
//  createSquarewave(50, 2, 5, t);
////////   
//   plotCreate() ;
//   clf()
//   createTriangularewave(10,1,5,t);
////   
//   plotCreate();
//  createSawwave(10,1,5,t);
//   
//   plotCreate() ;
//   createFurieFourth(1000,1,3,t,tau);
//   
//   plotCreate() ;
//   createFurieFifth(1000,10,3,t,tau);
//   
//   plotCreate() ;
//  createFurieSixth(4,1,5,t);
   
//   plotCreate() ;
//   plotDrawStepSignal(signals(1));
//
//    plotCreate() ;
//    clf()
//    createSingleImpulse(t, 0.5,1, 5.0);
////    
//    plotCreate();
//    clf()
//    createUnitStepSignal(t);
    
endfunction

//////////////////////////////
// Подготовительные моменты 
//////////////////////////////
function signal = createSignal(amplitude, frequency, phase, name, style)
    signal = struct('amplitude',amplitude * sin(2*%pi*frequency*t + phase),'nominalAmplitude',amplitude, 'frequency', frequency, 'phase', phase, 'name', name, 'style', style);
endfunction

function addGridToPlot()
    clf();
    xgrid();
    
endfunction

function plotDrawHarmonicSignals(signals) 
    addGridToPlot();
    legend_labels = []; 

    for i = 1:length(signals)
        plot(t, signals(i).amplitude, signals(i).style);
        legend_labels = [legend_labels, signals(i).name];
    end
    legend(legend_labels);
    xlabel('Время');
    ylabel('Амплитуда');
    title('Гармонический сигнал');
endfunction

function plotDrawStepSignal(signal) 
    addGridToPlot();
    plot2d2(t, signal.amplitude);

    legend(signal.name);
    xlabel('Время');
    ylabel('Амплитуда');
    title('Гармонический сигнал');
endfunction

/////////////////////////////////////////////////
//////     Мат операции
////////////////////////////////////////////////
function result_signal = addSignals(signal1, signal2)
    checkVectorLength(signal1.amplitude, signal2.amplitude);

    result_amplitude = signal1.amplitude+signal2.amplitude;
    
    stl = getRandomColor();
    namePattern = '(%s) + (%s)'
    
    result_signal = createResByAmplitude(result_amplitude,namePattern,signal1,signal2)
endfunction

function result_signal = subtractSignals(signal1, signal2)
    checkVectorLength(signal1.amplitude, signal2.amplitude);

    result_amplitude = signal1.amplitude-signal2.amplitude;
    
    stl = getRandomColor();
    namePattern = '(%s) -- (%s)'
    
    result_signal = createResByAmplitude(result_amplitude,namePattern,signal1,signal2)
endfunction


function result_signal = multiplySignals(signal1, signal2)
    checkVectorLength(signal1.amplitude, signal2.amplitude);

    result_amplitude = signal1.amplitude.*signal2.amplitude;
    
    stl = getRandomColor();
    namePattern = '(%s) * (%s)'
    
    result_signal = createResByAmplitude(result_amplitude,namePattern,signal1,signal2)
endfunction

function result_signal = devideSignals(signal1, signal2)
    checkVectorLength(signal1.amplitude, signal2.amplitude);

    result_amplitude = signal1.amplitude./signal2.amplitude;
    
    stl = getRandomColor();
    namePattern = '(%s) / (%s)'
    
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

///Побочные приколы
function checkVectorLength(vector1, vector2)
    if length(vector1) ~= length(vector2)
        error('Длины векторов должны быть одинаковыми');
    end
endfunction

function clr = getRandomColor()
    colors = [ '--g', '--c', '--m', '--y']; 
    index = ceil(rand() * length(colors)); 
    clr = colors(index); 
endfunction

function plotCreate()
    sleep(500);
    figure();
    sleep(100); 
endfunction

///////////////////////////////////////////////////////////////////
///////   лиссажу
//////////////////////////////////////////////////////////////////

function plotLissajousFigure(signalX, signalY)
    addGridToPlot()
   checkVectorLength(signalX.amplitude, signalY.amplitude);
  
    
    x = signalX.amplitude ;
    y = signalY.amplitude ;

    plot(x, y);
    xlabel('Сигнал X');
    ylabel('Сигнал Y');
    title('Фигура Лиссажу');
//    legend(['фаза ' + string(signalX.phase) + ', частота ' + string(signalX.frequency), ...
//        'фаза ' + string(signalY.phase) + ', частота ' + string(signalY.frequency)])

    
endfunction
//
function plotLissajousWithPhaseShift(signalX, signalY)
    clf(); 
    step = %pi/6
    phases = 0:step:2*%pi;
    
    all_x = [];
    all_y = []; 
    
    
    //subplot - все на одну картинку!!!!!!!
    count = length(phases);
    c_x = ceil(sqrt( count));
    c_y = ceil(count / c_x);
    i=0
    for phase = phases
        i=i+1;
        
        
        shiftedSignalX = shiftSignal(signalX,  phase,0);
        //Вариант с Subplot (все на 1ом)
        subplot(c_x,c_y,i);
        plot(shiftedSignalX.amplitude,signalY.amplitude)
        
        
        //Вариант с перерисовкой
       //sleep(300);
       //plotLissajousFigure(shiftedSignalX, signalY);
        
    end
   

endfunction

function plotLissajousWithFrequencyShift(signalX, signalY)
    clf(); 
    step = 0.5
    frequenses = 0:step:3*%pi; 
    count = length(frequenses);
    c_x = ceil(sqrt( count));
    c_y = ceil(count / c_x);
    i=0
    
    for frequence = frequenses
        shiftedSignalX = shiftSignal(signalX,0,frequence);
        

        //вариант  subplot
         i=i+1;
        subplot(c_x,c_y,i);
        plot(shiftedSignalX.amplitude,signalY.amplitude)
        
        //вариант с перерисовкой
        // sleep(300);
        //plotLissajousFigure(shiftedSignalX, signalY);
        
    end

endfunction


function shiftedSignal = shiftSignal(signal, phaseShift, frequencyShift)
    shiftedSignal = struct('amplitude',signal.nominalAmplitude * sin(2*%pi*(signal.frequency+frequencyShift)*t ...
      + signal.phase+phaseShift),...
     'nominalAmplitude',signal.nominalAmplitude,'frequency', signal.frequency+frequencyShift, 'phase', signal.phase+phaseShift,...
     'name', signal.name, 'style', signal.style);
endfunction

//////////////////////////////////////////////////////////////
/////////////// Фурье Приколы
//////////////////////////////////////////////////////////////

function createSquarewave(numHarmonics, amplitude, T, t)
    bufferSum =0
    frequency = 2*%pi /T
    for k = 1:2:numHarmonics*2
        bufferSum = bufferSum + sin(k*frequency*t)/k
    end
    static =(4*amplitude/%pi)
    furieBase(bufferSum,static,t)
   
endfunction


function createTriangularewave(numHarmonics, amplitude, T, t)
    bufferSum =0
frequency = 2*%pi /T
    for k = 1:2:numHarmonics*2
         bufferSum = bufferSum + (-1)^((k-1)/2)  * ...
          sin(k*frequency*t)/(k^2);
   
    end
    static =(8*amplitude/(%pi^2))
    furieBase(bufferSum,static,t)
   
endfunction
function createSawwave(numHarmonics, amplitude, T, t)
    frequency = 2*%pi /T
    bufferSum =0
    for k = 1:1:numHarmonics+1
         bufferSum = bufferSum + 1/k*sin(k*frequency*t)
   
    end
    static = -(amplitude/2-amplitude/%pi); // '-' для разворота)
    furieBase(bufferSum,static,t)
   
endfunction

//

function createFurieFourth(numHarmonics, amplitude, T, t,tau)
    frequency = 2*%pi /T
    bufferSum =0
    for k = 1:2:numHarmonics*2
         bufferSum = bufferSum +...
          1/k .* sin((k.*frequency*tau)/2) .* cos(k*frequency*t); 
   
    end
    static = 4*amplitude/%pi; 
    furieBase(bufferSum,static,t)
   
endfunction

//---

function createFurieFifth(numHarmonics, amplitude, T, t, tau) //
    frequency = 2*%pi /T
    
    //-_-
    //Тут не по шаблону(

    clf();
    bufferSum =0
    for k = 1:1:numHarmonics+1 
          bufferSum = bufferSum +...
          (1/k * sin(k*frequency*tau/2) * cos(k*frequency*t));
   
    end
    static = tau *frequency+2/%pi;
//    
    wave = static .* bufferSum;
    wave = amplitude .* wave;
    plot(t, wave);
   
endfunction

function createFurieSixth(numHarmonics, amplitude, T, t) 
    frequency = 2*%pi /T
    //-_-
    //Тут не по шаблону(
    clf();
    bufferSum =0
    for S = 1:1:numHarmonics+1 
          bufferSum = bufferSum +...
          (-1)^(S+1) / (((2*S)^2) -1)* cos(2*S * frequency * t)
   
    end
    static =0.5
    
    wave = static + bufferSum;
    wave = 4* amplitude/%pi .* wave;
    plot(t, wave);
   
endfunction

//-------//

function furieBase( mainFuriePart, statisFuriePart,t)
    //t - передаю для возможности отделить время именно для Фурье
    wave = statisFuriePart * mainFuriePart;
    plot(t, wave);
    xlabel('Время');
    ylabel('Амплитуда');
    title('Фурье Приколямбы');
    
endfunction

//////////////////////////////////////////////
////////// импульсы
/////////////////////////////////////////////

function createSingleImpulse(t, t1, t2, Amplitude)
    impulseSignal = zeros(size(t));  
    impulseSignal(t > t1  ) = Amplitude;  //:(
    impulseSignal(t > t2  ) = 0;  
    
    plot(t, impulseSignal);           
    xlabel('Время');
    ylabel('Амплитуда');
    title('Одиночный импульс');
    
   
    a=get("current_axes");
    a.auto_scale = "off";
    a.data_bounds=[-1,-Amplitude-0.2;1.5,Amplitude+0.2];
endfunction
  

function unitStepSignal = createUnitStepSignal(t)
    unitStepSignal = zeros(size(t));  
    unitStepSignal(t >= 0) = 1; 
        
    plot(t, unitStepSignal);      
    
    xlabel('Время');
    ylabel('Амплитуда');
    title('Единичный ступенчатый сигнал Хевисайда');
    
    
    a=get("current_axes")
    a.auto_scale = "off"
    a.data_bounds=[-1,-1;1.5,5]
    
endfunction
//как же удобно у самого себя все функции из 1ой лабы воровать 
function unitStepSignal = createUnitStepSignal(t)
    unitStepSignal = zeros(size(t));  
    unitStepSignal(t >= 0) = 1; 
        
    plot(t, unitStepSignal);      
    
    xlabel('Время');
    ylabel('Амплитуда');
    title('Единичный ступенчатый сигнал Хевисайда');
    
    
    a=get("current_axes")
    a.auto_scale = "off"
    a.data_bounds=[-1,-1;1.5,5]
    
endfunction
