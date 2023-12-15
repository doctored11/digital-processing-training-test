N = 53;
n = -(N-1)/2:(N-1)/2;
fc=1.75

function _ = start()
    WArr = calculateWn();
    HdArr = calculateHdn(WArr);
    
     disp('1)  i      w');
    disp('--------------');
    for i = 1:size(WArr, 1)
        printf('%4d  %8.4f\n', WArr(i, 1), WArr(i, 2));
    end
     printf('-------------- \n');

    calculateHdn2(WArr);
end

//
//
//


function WMatrix = calculateWn()
    //весовая функция Хемминга
    WMatrix = [];

    for i = n
        w = 0.54 + 0.46 * cos(2 * %pi * i / N);
        WMatrix = [WMatrix; i, w];
    end
    
       
    
    plot(WMatrix(:,1),WMatrix(:,2))
end


function HdMatrix = calculateHdn(WMatrix)
    //импульсная х-ка
    HdMatrix = [];

    for row = 1:size(WMatrix, 1)
        i = WMatrix(row, :);
//        disp(i(1));
     
            hd = 2 * fc * (sin(i(2) * i(1)) / (i(2) * i(1)));
        
        HdMatrix = [HdMatrix; i(1), hd];
    end
    
    
//    
    disp('2)  i      w');
    disp('--------------');
    for i = 1:size(HdMatrix, 1)
        printf('%4d  %8.4f\n', HdMatrix(i, 1), HdMatrix(i, 2));
    end
    printf('-------------- \n');
//

    figure();
    plot(HdMatrix(:, 1), HdMatrix(:, 2));
end

function calculateHdn2(WMatrix)
    //импульсная х-ка (2)
    //попытка повторить за примером на доске (по отдельности каждый график)
    XY = [];
    wc = 2*%pi*fc;
    figure();

    for i = 1:size(WMatrix, 1)
        x = WMatrix(i, 1);
        
        
        hd = 2*fc*(sin(wc*x) / (wc*x));
        
      
        plot([0, x], [0, hd]);
    end
end

