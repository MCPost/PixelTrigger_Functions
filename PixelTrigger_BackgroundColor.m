function rgb_trig_vals = PixelTrigger_BackgroundColor(backgroundcolor, varargin)

%% Get Possible Combinations of Green and Blue values corresponding to different triggers

%' Inputs:
% 
% backgroundcolor       3 element vector specifing the RGB values (between
%                       0 and 255) of the background color (e.g. [200,200,200]
% show_visual           If set to true, a figure with colors that lead to 
%                       different trigger values. The colors are chosen to 
%                       minize the distance from the backgroundcolor. For each
%                       plot the left color is the backgroundcolor and the
%                       right is the trigger color. The bold trigger value
%                       identifies the trigger value of your
%                       backgroundcolor (best to choose a backgroundcolor
%                       with trigger value 0)
%
%' Outputs:
% 
% rgb_trig_vals         255 x 4 list of RGB colors (column 1-3) and their 
%                       trigger values (column 4).
%
% C.Postzich, 25.Dec.2021


% Validate Function Inputs
validateattributes(backgroundcolor,{'numeric'},{'numel',3,'>=',0,'<',255,'nonnan'},'PixelTrigger_Colors','backgroundcolor')

if(isempty(varargin))
    show_visual = false;
else
    validateattributes(varargin{2},{'logical'},{'numel',1},'PixelTrigger_Colors','show_visual')
    show_visual = varargin{2};
end


all_combinations = dec2bin(0:255);

rgb_trig_vals = repmat([backgroundcolor(1),0,0],size(all_combinations,1),1);
for i = 1:size(all_combinations,1)
    temp_bin_g = '00000000';
    %temp_bin_g(1:2:8) = all_combinations(i,1:4);
    temp_bin_g(5:8) = all_combinations(i,1:4);
    temp_bin_b = '00000000';
    %temp_bin_b(1:2:8) = all_combinations(i,5:8);
    temp_bin_b(5:8) = all_combinations(i,5:8);
    temp_comb = zeros(size(all_combinations,1),3);
    for j = 1:size(all_combinations,1)
        %temp_bin_g(2:2:8) = all_combinations(j,1:4);
        temp_bin_g(1:4) = all_combinations(j,1:4);
        %temp_bin_b(2:2:8) = all_combinations(j,5:8);
        temp_bin_b(1:4) = all_combinations(j,5:8);
        temp_comb(j,1:2) = [bin2dec(temp_bin_g) bin2dec(temp_bin_b)];
        temp_diffcol = [transpose(0:255), repmat(temp_comb(j,1:2),256,1)];
        %[temp_comb(j,3), temp_comb(j,4)] = min(1 - dot(temp_diffcol, repmat(backgroundcolor,256,1),2) ./ vecnorm(backgroundcolor,1) ./ vecnorm(temp_diffcol,1,2));
        [temp_comb(j,3), temp_comb(j,4)] = min(sum((temp_diffcol - backgroundcolor).^2,2));
    end
    [~,idx] = min(temp_comb(:,3));
    
    rgb_trig_vals(i,1:3) = [temp_comb(idx,4)-1 temp_comb(idx,1:2)];
    rgb_trig_vals(i,4) = rgb2triggervalue(rgb_trig_vals(i,:));
end

% Plot Colors belonging to trigger values if visuals are wanted
if(show_visual)
    
    background_trigval = rgb2triggervalue(backgroundcolor);
    
    figure('pos', [112  57  1318  714])
    for i = 1:size(rgb_trig_vals,1)
        ax = axes('Position',[0.02+(0.98/18)*mod((i-1),18) 0.94-(0.98/15)*floor((i-1)/18) 0.04 0.04],'xtick',[],'ytick',[],'visible','off');
        patch([0 0.5 0.5 0],[0 0 1 1],backgroundcolor./256, 'tag',sprintf('Color (%d,%d,%d)',backgroundcolor(1), backgroundcolor(2), backgroundcolor(3)))
        patch([0.5 1 1 0.5],[0 0 1 1],rgb_trig_vals(i,1:3)./256)
        if(background_trigval == (i-1))
            text('parent',ax,  'String',num2str(rgb_trig_vals(i,4)),   'position',[0.5 1.25], 'FontSize',8, 'FontWeight','bold', 'Color','r',  'HorizontalAlignment','center')
        else
            text('parent',ax,  'String',num2str(rgb_trig_vals(i,4)),   'position',[0.5 1.25], 'FontSize',8,  'HorizontalAlignment','center')
        end
    end
    dcm = datacursormode;
    dcm.SnapToDataVertex = 'off';
    dcm.Enable = 'on';
    dcm.UpdateFcn = @displayColor;
    
end

end

% Callback function for verifying the blue and green values match the
% trigger value
function triggervalue = rgb2triggervalue(RGB)

green_bin = dec2bin(RGB(2));
green_bin = [repmat('0',1,8-length(green_bin)) green_bin];
blue_bin = dec2bin(RGB(3));
blue_bin = [repmat('0',1,8-length(blue_bin)) blue_bin];

%trigger_bin = [green_bin(1:2:8) blue_bin(1:2:8)];
trigger_bin = [green_bin(5:8) blue_bin(5:8)];
triggervalue = bin2dec(trigger_bin);

end

% Callback function for displaying color info in the figure
function txt = displayColor(~,info)
    txt = sprintf('RGB(%d,%d,%d)',info.Target.FaceColor(1)*256,info.Target.FaceColor(2)*256,info.Target.FaceColor(3)*256);
end
