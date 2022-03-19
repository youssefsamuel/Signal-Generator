%Name: Seif Mohamed Amr, ID: 6827, Group: 3, section 2
%Name: Youssef Samuel Nachaat, ID: 6978, Group: 2, section 1
clear;
clc;
close all;
loop = 1; %Variable used to be able to plot more than 1 figure.(when loop = 0, the program terminates.)
while loop 
 close all;
 fs = input('Please enter the sampling frequency of the signal: ');
 while fs <= 0 %Always positive value.
     fs = input('Invalid Input, sampling frequency always positive!\nPlease enter the sampling frequency of the signal: ');
 end
 start_time = input('Start time scale: ');
 end_time = input('End time scale: ');
 while end_time <= start_time %end time must be > start time
     end_time = input('Invalid Input, end time must be greater than start time\nEnd time scale: ');
 end
 totalTime = linspace(start_time, end_time, (end_time - start_time) * fs); %The total time duration of the signal to be drawn.
 num_of_breakpoints = input('Number of break points: '); 
 breakpoints(1) = start_time; %A vector is created to store the values of the breakpoints positions,&the first entry is the start time of the function. 
 for i = 2:num_of_breakpoints+1 %Loop starts from 2 (the second entry of the vector) and ends when i equals the number of breakpoints+1 
     %(loop a number of times equals the number of breakpoints)
     breakpoints(i) = input(['Position of break point #' num2str(i-1) ': ']); %store the position of each breakpoint.
     while breakpoints(i) < start_time || breakpoints(i) > end_time || breakpoints(i) < breakpoints(i-1)
       breakpoints(i) = input(['Invalid Input!, current breakpoint must be within range and greater than the last one\nPosition of break point #' num2str(i-1) ': ']);
     end
 end
 breakpoints(num_of_breakpoints+2) = end_time; %the last entry of the breakpoints vector is the end time of the function.
 G = []; %Vector G will represent the total function to be plotted.
 for k = 1:num_of_breakpoints+1 %we loop a number of time equals the number of seperate functions. 
     %(if we have 2 breakpoints we have 3 seperate fns)
     t1 = breakpoints(k); %start time of the current function.
     t2 = breakpoints(k+1); %end time of the current function.
     choice = input(['\nPlease choose desired function in the interval [' num2str(t1) ' ' num2str(t2) ']: \n1.DC signal\n2.Ramp signal\n3.General order polynomial\n4.Exponential signal\n5.Sinusoidal signal\nChoice: ']);
     while choice < 1 || choice > 5 %You have only 5 options.
         choice = input('\nInvalid Input!! You to choose an option from list!\nPlease re-enter your choice: ');
     end
     tempT = linspace(t1, t2, (t2 - t1) * fs); %Duration of the current function.
     switch choice
         case 1 %DC signal
             A = input('Amplitude: ');
             Y = A * ones(1, (t2-t1)*fs);
         case 2 %Ramp Signal
             slope = input('Slope: ');
             intercept = input('Intercept with y-axis: ');
             Y = slope*tempT + intercept;
         case 3 %General Polynomial
            p = 0; %vector to contain the coefficients in descending order.
            highestPower = input('Highest Power: '); 
            for i = highestPower:-1:0
                coefficient = input(['Coefficient of (x)^ ' num2str(i) ': ']);
                p = [p coefficient];
            end
            Y = polyval(p, tempT); %function to evaluate the polynomial p at each point in tempT.
            %note that coefficient of x^0 is the intercept.
         case 4 %Exponential Signal.
             A = input('Amplitude: ');
             k = input('Exponent: ');
             Y = A * exp(k*tempT);
         case 5 %Sinusoidal Signal 
             Type = input('Choose:\n1-> sine wave\n2-> cosine wave\n');
             A = input('Amplitude: ');
             f = input('Frequency(Hz): ');
             phase = input('Phase(Degree): ');
             c = input('DC shift: ');
             phase = deg2rad(phase);
             if(Type == 1)
                Y = A * sin(2*pi*f*tempT + phase) + c;
             else
                Y = A * cos(2*pi*f*tempT + phase) + c;
             end
     end 
     G = [G Y]; %After each region we concatinate the formed vector with a vector G that will represent the total function.
 end
 plot(totalTime, G);
 title('Signal');
 grid on;
 operation = 0; 
 again = 1;
 numsOfOpsPerformed = 0; %Number of operations performed on the signal.
 while operation ~= 6 && again == 1 %loop ends when operation = 6, user choosed 'none' from the list, or when again = 0, which means he doesnt want any more operations.
     operation = input('\nOperations to perform on the signal: \n1.Amplitude Scaling\n2.Time Reversal\n3.Time Shift\n4.Expanding the signal\n5.Compressing the signal\n6.None\nPlease enter the number of the operation: ');
         while operation < 1 || operation > 6 %You only have 6 options.
             operation = input('\nInvalid Input!! You to choose an option from list!\nPlease re-enter your choice: ');
         end
     if operation ~= 6 %If the user didnt choose none.
        switch operation
             case 1 %Amplitude Scaling
                 scale = input('Scale Value: ');
                newTime = totalTime;
                G = scale * G;
            case 2 %Time Reversal
                newTime = -totalTime;
            case 3 %Time Shift
                shift = input('Shift Value: '); 
                newTime = totalTime - shift;
            case 4 %Expanding the Signal
                scale = input('Expanding Value: ');
                newTime = totalTime * scale;
            case 5  %Compressing the Signal
                 scale = input('Compressing Value: ');
                newTime = totalTime / scale;
        end
        numsOfOpsPerformed = numsOfOpsPerformed + 1;
        figure;
        plot(newTime, G); %Plot the signal after an operation.
        title(['Operation #', num2str(numsOfOpsPerformed)]);
        grid on;
        totalTime = newTime; 
        again = input('\nYou want to perform another operation?\nYes: 1\nNo: 0\nChoice: ');
        while again ~=0 && again ~=1 
            again = input('\nInvalid Input!! You to choose an option from list!\nRe-enter your choice: ');   
        end
     end
 end
      loop = input('\nYou want to plot another signal?\nYes: 1\nNo: 0\nChoice: ');   
      while loop ~=0 && loop ~=1 %You only have 2 options, yes or no.
         loop = input('\nInvalid Input!! You to choose an option from list!\nRe-enter your choice: ');   
      end
end