function triggervalue = rgb2triggervalue(RGB)

%%Convert RGB Triplet into Trigger Value for ProPixx
% 
% Inputs:
%  
%  RGB                3 element vector specifing an RGB triplet with values between
%                     0 and 255 (e.g. [200,200,200])
% 
% Outputs:
%  
%  triggervalue       integer between 0 and 255 indicating the trigger value associated
%                     with the RGB triplet
%                        
% 
% C.Postzich, 25.Dec.2021


green_bin = dec2bin(RGB(2));
green_bin = [repmat('0',1,8-length(green_bin)) green_bin];
blue_bin = dec2bin(RGB(3));
blue_bin = [repmat('0',1,8-length(blue_bin)) blue_bin];

%trigger_bin = [green_bin(1:2:8) blue_bin(1:2:8)];
trigger_bin = [blue_bin(5:8) green_bin(5:8)];
triggervalue = bin2dec(trigger_bin);

end