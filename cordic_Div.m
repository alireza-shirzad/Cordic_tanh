function output = cordic_Div(y,x,isSigned,wordLength,fractionLength)
%%% Simulation Parameters
iteration_num = wordLength;
%%% Defining algorithm inputs
current_x = fi(x,isSigned,wordLength,fractionLength);
current_y = fi(y,isSigned,wordLength,fractionLength);
current_z = fi(0,isSigned,wordLength,fractionLength);
%%% Defining algorithm variables
i=0;
%%% The algorithm
while(i<iteration_num)
    if (current_y >= 0)
        next_z = fi(current_z + fi(2^(-i),isSigned,wordLength,fractionLength),isSigned,wordLength,fractionLength);
        next_y = fi(current_y - bitsra(current_x,i),isSigned,wordLength,fractionLength);
    else
        next_z = fi(current_z - fi(2^(-i),isSigned,wordLength,fractionLength),isSigned,wordLength,fractionLength);
        next_y = fi(current_y + bitsra(current_x,i),isSigned,wordLength,fractionLength);
    end
    current_y = next_y;
    current_z = next_z;
    i = i+1;
end
output = current_z;