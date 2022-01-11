function GB = triggervalue2gb(triggervalue)

%% Convert a Trigger Value into all possbile GB tuples for ProPixx
% 
% Inputs:
%  
%  triggervalue       integer between 0 and 255 indicating the trigger value 
% 
% Outputs:
% 
%  GB                 list of all 2 element vector specifing an GB tuple with values between
%                     0 and 255 (e.g. [200,200,200]) that are associated with the triggervalue
%                     (Note that the the red value can vary freely)
%
% C.Postzich, 25.Dec.2021

trigger_bin = dec2bin(triggervalue);
trigger_bin = [repmat('0',1,8-length(trigger_bin)) trigger_bin];

all_combinations = dec2bin(0:255);

temp_bin_g = '00000000';
%temp_bin_g(1:2:8) = trigger_bin(1:4);
temp_bin_g(5:8) = trigger_bin(1:4);
temp_bin_b = '00000000';
%temp_bin_b(1:2:8) = trigger_bin(5:8);
temp_bin_b(5:8) = trigger_bin(5:8);
GB = zeros(size(all_combinations,1),2);
for j = 1:size(all_combinations,1)
    %temp_bin_g(2:2:8) = all_combinations(j,1:4);
    temp_bin_g(1:4) = all_combinations(j,1:4);
    %temp_bin_b(2:2:8) = all_combinations(j,5:8);
    temp_bin_b(1:4) = all_combinations(j,5:8);
    GB(j,1:2) = [bin2dec(temp_bin_g) bin2dec(temp_bin_b)];
end


end