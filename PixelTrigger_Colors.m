function rgb_trig_vals = PixelTrigger_Colors(backgroundcolor, varargin)

%% Get Possible Combinations of Green and Blue values corresponding to different triggers

%' Inputs:
% 
% backgroundcolor       3 element vector specifing the RGB values (between
%                       0 and 255) of the background color (e.g. [200,200,200]
% show_visual           If set to true, a figure with all different colors
%                       that lead to different trigger values. For each
%                       plot the left color is the backgroundcolor and the
%                       right is the trigger color
%                       (Note that those are not all colors resulting in 
%                       their corresponding triggers)
%
%' Outputs:
% 
% rgb_trig_vals         255 x 4 list of RGB colors (column 1-3) and their 
%                       trigger values (column 4).
%
% C.Postzich, 14.Dec.2021


% Validate Function Inputs
validateattributes(backgroundcolor,{'numeric'},{'numel',3,'>=',0,'<',255,'nonnan'},'PixelTrigger_Colors','backgroundcolor')

if(isempty(varargin))
    show_visual = false;
else
    validateattributes(varargin{1},{'logical'},{'numel',1},'PixelTrigger_Colors','show_visual')
    show_visual = varargin{1};
end


all_combinations = dec2bin(0:255);

green_startval = dec2bin(backgroundcolor(2));
blue_startval = dec2bin(backgroundcolor(3));

temp_blue = []; temp_green = [];
rgb_trig_vals = repmat([backgroundcolor(1),0,0],size(all_combinations,1),1);
for i = 1:size(all_combinations,1)
    temp_green = green_startval;
    temp_green(1:2:8) = all_combinations(i,1:4);
    rgb_trig_vals(i,2) = bin2dec(temp_green);
    
    temp_blue = blue_startval;
    temp_blue(1:2:8) = all_combinations(i,5:8);
    rgb_trig_vals(i,3) = bin2dec(temp_blue);
end
rgb_trig_vals(:,4) = transpose(0:255);
rgb_trig_vals(rgb_trig_vals(:,1) == backgroundcolor(1) &...
    rgb_trig_vals(:,2) == backgroundcolor(2) &...
    rgb_trig_vals(:,3) == backgroundcolor(3),:) = [];

% Plot Colors belonging to trigger values if visuals are wanted
if(show_visual)
    
    figure('pos', [112  57  1318  714])
    for i = 1:size(rgb_trig_vals,1)
        ax = axes('Position',[0.02+(0.98/17)*mod((i-1),17) 0.94-(0.98/15)*floor((i-1)/17) 0.04 0.04],'xtick',[],'ytick',[],'visible','off');
        patch([0 0.5 0.5 0],[0 0 1 1],backgroundcolor./256, 'tag',sprintf('Color (%d,%d,%d)',backgroundcolor(1), backgroundcolor(2), backgroundcolor(3)))
        patch([0.5 1 1 0.5],[0 0 1 1],rgb_trig_vals(i,1:3)./256)
        text('parent',ax,  'String',num2str(rgb_trig_vals(i,4)),   'position',[0.5 1.25], 'FontSize',8,  'HorizontalAlignment','center')
    end
    dcm = datacursormode;
    dcm.SnapToDataVertex = 'off';
    dcm.Enable = 'on';
    dcm.UpdateFcn = @displayColor;
    
end

end

% Callback function for displaying color info in the figure
function txt = displayColor(~,info)
    txt = sprintf('RGB(%d,%d,%d)',info.Target.FaceColor(1)*256,info.Target.FaceColor(2)*256,info.Target.FaceColor(3)*256);
end