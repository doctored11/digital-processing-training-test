E = [-12,-10,-4,5,11,19,23,21,15,5,-3,-8];
D = [15,18,22,28,33,35,33,32,30,28,21,17];
B = [26,24,21,18,14,11,10,10,12,15,20,23];

function calcAll() //точка входа 
    clc();
     printf("==================\n\n");
    sE = squareRootOfSumOfSquares(E);
    sD = squareRootOfSumOfSquares(D);
    sB = squareRootOfSumOfSquares(B);
    printf("|E| = %d |D| = %d |B| = %d\n", sE, sD, sB);
    sclED =  calculateScalarProduct(E, D);
    sclEB =  calculateScalarProduct(E, B);
    sclBD =  calculateScalarProduct(B, D);
    printf("<ED> = %d <EB> = %d <BD> = %d\n", sclED, sclEB, sclBD);
    crlED = calculateCorelProduct(sclED,sE, sD);
    crlEB = calculateCorelProduct(sclEB,sE, sB);
    crlBD = calculateCorelProduct(sclBD,sB, sD);
    printf("crlED = %.3f crlEB = %.3f crlBD = %.3f\n", crlED, crlEB, crlBD);
    centeredE = centerVector(E);
    centeredD = centerVector(D);
    centeredB = centerVector(B);
    printf("\n\n");
    printf("Центрированный вектор E:\n");
    disp(centeredE);
    printf("\n");
    printf("Центрированный вектор D:\n");
    disp(centeredD);
    printf("\n");
    printf("Центрированный вектор B:\n");
    disp(centeredB);
    printf("\n");
    vectors = {E, D, B};
    plotMultipleVectors(vectors);
    printf("==================\n\n");

endfunction

//
//
//
function result = squareRootOfSumOfSquares(vector)
    result = sqrt(sum(vector.^2));
endfunction

function scalarRes = calculateScalarProduct(vector1, vector2)
    if length(vector1) ~= length(vector2)
        error('Длины  должны быть равны');
    end
    scalarRes = sum(vector1 .* vector2);
endfunction

function crlRes = calculateCorelProduct(scalar,vector1, vector2)
  
    crlRes = scalar/(vector1 .* vector2);
endfunction

function centeredVector = centerVector(vector)
    meanValue = mean(vector); 
    centeredVector = vector - meanValue; 
endfunction

//
function plotMultipleVectors(vectors)
    clf(); 
    styles = ['r-'; 'g-'; 'b-'; 'c-'; 'm-'; 'y-'; 'k-'];
  
    for i = 1:length(vectors)
        plot(vectors{i}, styles(i));
    end   
endfunction
//
//это если вдруг нужно будет перевести в к
function modifiedVector = plusToVector(vector, number)
    modifiedVector = vector + number;
endfunction



