%%% Test parameters
test_iteration = 1000;
test_begin_angle = -pi/2;
test_end_angle = pi/2;
%%% Fixed Point Parameters of angle
isSigned = 1;
wordLength = 18;
fractionLength = 16;
%%% Test generator
test_double_input = linspace(test_begin_angle,test_end_angle,test_iteration);
test_fixed_input = fi(test_double_input,isSigned,wordLength,fractionLength);
%%% Test file opening
fileID = fopen('test.txt','w');
for i = 1:test_iteration
    tmp = test_fixed_input(i);
    fprintf(fileID,'%s\n',tmp.bin);
end
fclose(fileID);

