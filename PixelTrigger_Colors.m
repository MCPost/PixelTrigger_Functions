%% Get Pixel Trigger Possibilites from Background Color

function rgb_trig_vals = PixelTrig_Possibilities(backgroundcolor, show_visual)

if(~exist('show_visual','var'))
    show_visual = false;
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

if(show_visual)
    
    figure('pos', [112  57  1318  714])
    for i = 1:size(rgb_trig_vals,1)
        ax = axes('Position',[0.02+(0.98/17)*mod((i-1),17) 0.94-(0.98/15)*floor((i-1)/17) 0.04 0.04],'xtick',[],'ytick',[],'visible','off');
        patch([0 0.5 0.5 0],[0 0 1 1],backgroundcolor./256)
        patch([0.5 1 1 0.5],[0 0 1 1],rgb_trig_vals(i,1:3)./256)
        text('parent',ax,  'String',num2str(rgb_trig_vals(i,4)),   'position',[0.5 1.25], 'FontSize',8,  'HorizontalAlignment','center')
    end
    
end

end



%rgb_values(ismember(rgb_values(:,2),[200 202 224 226 232 234])&ismember(rgb_values(:,3),[200 202 224 226 232 234]),:);

