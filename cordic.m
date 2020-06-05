function output = cordic(current_z,isSigned,wordLength,fractionLength)
%%% Simulation Parameters
iteration_num = wordLength;
%%% Defining algorithm inputs
current_x = fi(1.2075,isSigned,wordLength,fractionLength);
current_y = fi(0,isSigned,wordLength,fractionLength);
%%% Defining algorithm variables
i=1;
flag = 0;
%%% The algorithm
while(i<iteration_num)
    if (current_z < 0)
        next_z = fi(current_z + fi(ROM_lookup(i),isSigned,wordLength,fractionLength),isSigned,wordLength,fractionLength);
        next_x = fi(current_x - bitsra(current_y,i),isSigned,wordLength,fractionLength);
        next_y = fi(current_y - bitsra(current_x,i),isSigned,wordLength,fractionLength);
    else
        next_z = fi(current_z - fi(ROM_lookup(i),isSigned,wordLength,fractionLength),isSigned,wordLength,fractionLength);
        next_x = fi(current_x + bitsra(current_y,i),isSigned,wordLength,fractionLength);
        next_y = fi(current_y + bitsra(current_x,i),isSigned,wordLength,fractionLength);
    end
    q = quantizer('fixed', 'convergent', 'wrap', [wordLength fractionLength]);


    current_x = next_x;
    current_y = next_y;
    current_z = next_z;
   
    if ((i ~= 4) && (i ~= 13) && (i~=40))
        i = i+1;
    elseif (flag == 0)
        flag = 1;
    elseif (flag == 1)
        flag = 0;
        i = i+1;
    end
end
T = numerictype('Signed', true,...
    'WordLength', wordLength,...
    'FractionLength', fractionLength);
output = cordic_Div(current_y,current_x,isSigned,wordLength,fractionLength);