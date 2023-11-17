//это дерьмо может работать реально медленно

//то что надо знать
U0=27;
//для синусоид at
U01 = 18;

Tc1=0.32;
f1 = 10;
phase1 =0; //%pi/6

//bt
Tc2 = 0.32;
Fd = 1000;

//ct
t0=0.26
Tc3=2*t0

//dt

B=10
Tc4=0.26


//
t=0:0.001:Tc1;
t2 =-Tc2:1/Fd:Tc2;
t3=-Tc3:0.001:Tc3;
t4=0:0.001:Tc4;


function start()
    
     
    at = createSignal(U01, f1, phase1, '1', 'r-'); //эта структура тянется с первой лабы, тогда я думал что параметры сигналов будут нужны
    bt = createSingleImpulse(t2, -Tc2/2, Tc2/2, U0);
    ct = createUnitStepSignal(t3,t0);
    dt = exp(B*t4);
    
 
     max_length = max([length(at), length(bt), length(ct), length(dt)]);
   

    at_balanced.amplitude = [at.amplitude, zeros(1, max_length - length(at.amplitude))];
    bt_balanced = [bt, zeros(1, max_length - length(bt))];
    ct_balanced = [ct, zeros(1, max_length - length(ct))];
    dt_balanced = [dt, zeros(1, max_length - length(dt))];
    
    //свертки (не фольга)
    y1=calcConvolution(at.amplitude,at.amplitude)
    y2=calcConvolution(at.amplitude,bt)
    y3=calcConvolution(at.amplitude,ct)
    y4 =calcConvolution(at.amplitude,dt)
    
    y5=calcConvolution(bt,bt)
    y6=calcConvolution(bt,ct)
    y7=calcConvolution(bt,dt)
   
    y8=calcConvolution(dt,ct)
    y9=calcConvolution(dt,dt)
    
    y10 = calcConvolution(ct,ct)
    
    
       
   

    
    //1) Дистрибутивность
yData11=calcConvolution(at_balanced.amplitude,bt_balanced+ct_balanced)
yData12=calcConvolution(at_balanced.amplitude,bt_balanced)+calcConvolution(at_balanced.amplitude,ct_balanced)
//2) Коммутативность
yData21=calcConvolution(ct_balanced,bt_balanced)
yData22=calcConvolution(bt_balanced,ct_balanced)
//3) Ассоциативность
yData31=calcConvolution(calcConvolution(ct_balanced,bt_balanced),dt_balanced)
yData32=calcConvolution(calcConvolution(dt_balanced,ct_balanced),bt_balanced) 

//Построение графиков
scf(1)
subplot(2,2,1); plot(t, at.amplitude); xtitle('a(t)')
subplot(2,2,2); plot(t2, bt); xtitle('b(t)')
subplot(2,2,3); plot(t3, ct); xtitle('c(t)')
subplot(2,2,4); plot(t4, dt); xtitle('d(t)')
//
scf(2)

step=0.001

tBuff =0:step:(size(y1,'*')-1)*step;

disp(length(y1));
disp(length(y2));
disp(length(y3));
disp(length(tBuff));


//построение свертков
scf(2)
step = 0.001;
y = {y1, y2, y3, y4, y5, y6,y7,y8,y9,y10}; 
titles = {'a(t)*a(t)', 'a(t)*b(t)','a(t)*c(t)', 'a(t)*d(t)',  'b(t)*b(t)', 'b(t)*c(t)','b(t)*d(t)',  'd(t)*c(t)', 'd(t)*d(t)','c(t)*c(t)'};

for i = 1:10
    subplot(2, 5, i);
    disp(i)
   
    disp(size( y{i}))
    plot(0:step:(size(y{i}, '*') - 1) * step, y{i});
    
    xtitle(['Свертка ', titles{i}]);
end


//Проверка свойств
scf(3)
yData = {yData11, yData12, yData21, yData22, yData31, yData32};
titles = {'Дистрибутивность 1', 'Дистрибутивность 2', 'Комммутативность 1', 'Комммутативность 2', 'Ассоциативность 1', 'Ассоциативность 2'};
for i = 1:6
    subplot(3, 2, i);
    plot(0:step:((size(yData{i}, '*') - 1) * step), yData{i});
    title(['График ', titles{i}]);
end


    
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
    tic();
    N = size(signal)(2);//ищем кол-во точек в строке
     
    frequencies = Fd * (0:(N/2)) / N;
    
   
    Dpf = fft(signal);
     
    Dpfa = abs(Dpf(1:size(frequencies)(2)));

  
    amplitudeSpectrum = Dpfa;
     elapsedTime = toc(); 
      disp('Время выполнения функции ДПФ: ' + string(elapsedTime) + ' секунд');

   
endfunction
  

function [amplitudeSpectrum, frequencies, Dpf] = computeDFTWithFFTW(signal, Fd, method) //результат тот же 

     //инициализацию вынес для справедливого замера
    Dpf = fftw(signal); //это не повторение ( в info есть ремарка о инициализации в части случаев)
    //с этой инициализацией сильно медленнее (а смысл то в производительности)
    
   
    tic();
    N = size(signal)(2);
    frequencies = Fd * (0:(N/2)) / N;
  
  
    if method == 1
        flag = 'FFTW_ESTIMATE';
    elseif method == 2
       
        flag = 'FFTW_MEASURE'; 
        
    else
     
        flag = 'FFTW_PATIENT';
    end
    fftw_flags(flag)
    Dpf = fftw(signal);
    Dpfa = abs(Dpf(1:size(frequencies)(2)));
    amplitudeSpectrum = Dpfa;
     elapsedTime = toc(); 
      disp('Время выполнения функции ' + string(method) + ': ' + string(elapsedTime) + ' секунд');


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

//как же удобно у самого себя все функции из 1ой лабы воровать 
function unitStepSignal = createUnitStepSignal(t, t_0)
    unitStepSignal = zeros(size(t));  
    unitStepSignal(t >=t_0) = 1; 
        
    plot(t, unitStepSignal);      
    
    xlabel('Время');
    ylabel('Амплитуда');
    title('Единичный ступенчатый сигнал Хевисайда');
    
    
    a=get("current_axes")
    a.auto_scale = "off"
    a.data_bounds=[-1,-1;1.5,5]
    
endfunction

function y = calcConvolution(h, s)
    //форм 4
    size_h = size(h, '*'); 
    size_s = size(s, '*'); 
    size_y = size_h + size_s - 1; 

    y = zeros(1, size_y); 

    for k = 1:size_y
        n_min = max(1, k + 1 - size_s);
        n_max = min(k, size_h);

        for n = n_min:n_max
            y(k) = y(k) + h(n) * s(k + 1 - n);
        end
    end
endfunction

