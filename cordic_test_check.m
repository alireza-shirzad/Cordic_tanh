clc
%%% Fixed Point Parameters of angle
isSigned = 1;
wordLength = 18;
fractionLength = 16;
fid = fopen('test_result.txt');
output = [];
tmp = fi(0,isSigned,wordLength,fractionLength);
tline = fgetl(fid);
if (~contains(tline,'x'))
    tmp.bin = tline;
    ouput = [output str2num(tmp.value)];
end
i = 0;
while true
    tline = fgetl(fid);
    if (tline~=-1)
        if (~contains(tline,'x'))
            i = i+1;
            if (i>1000)
                break;
            end
            tmp.bin = tline;
            output = [output str2num(tmp.value)];
        end
    else
        break;
    end
end
fclose('all');
test_double_input = linspace(test_begin_angle,test_end_angle,test_iteration);
test_fixed_input = fi(test_double_input,isSigned,wordLength,fractionLength);
for i=1:test_iteration
    i
    test_fixed_output(i) = cordic(test_fixed_input(i),isSigned,wordLength,fractionLength);
end
plot (test_double_input,tanh(test_double_input))
hold on
plot(test_double_input,test_fixed_output)
hold on
plot(test_double_input,output)
title ('CORDIC tanh')
legend('tanh','simulation with matlab','simulation with verliog')
xlabel('x')
ylabel('y')