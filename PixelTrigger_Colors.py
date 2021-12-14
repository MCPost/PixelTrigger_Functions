'''
Get Possible Combinations of Green and Blue values corresponding to different triggers

Inputs:
 
 backgroundcolor       3 element vector specifing the RGB values (between
                       0 and 255) of the background color (e.g. [200,200,200]
 show_visual           If set to true, a figure with all different colors
                       that lead to different trigger values. For each
                       plot the left color is the backgroundcolor and the
                       right is the trigger color
                       (Note that those are not all colors resulting in 
                       their corresponding triggers)

Outputs:
 
 rgb_trig_vals         255 x 4 list of RGB colors (column 1-3) and their 
                       trigger values (column 4).


C.Postzich, 14.Dec.2021

'''


# Import Libraries
import matplotlib
import matplotlib.pyplot as plt
import matplotlib.gridspec as grd
import math

# Define Function
def PixelTrigger_Colors(backgroundcolor, show_visual):

    all_comb = [bin(i) for i in range(255)]

    green_startval = bin(backgroundcolor[1])
    blue_startval = bin(backgroundcolor[2])

    temp_blue = temp_green = []
    rgb_trig_vals = [[[backgroundcolor[0],0,0],i] for i in range(len(all_comb))]
    for i in range(len(all_comb)):
        temp_comb = list(all_comb[i])
        temp_comb = temp_comb[2:]
        temp_comb = list('0'*max(0, 8-len(temp_comb))) + temp_comb

        temp_green = list(green_startval)
        temp_green = temp_green[2:]
        temp_green = list('0'*max(0, 8-len(temp_green))) + temp_green
        temp_green[0::2] = temp_comb[0:4]
        rgb_trig_vals[i][0][1] = int(''.join(temp_green),2)

        temp_blue = list(blue_startval)
        temp_blue = temp_blue[2:]
        temp_blue = list('0'*max(0, 8-len(temp_blue))) + temp_blue
        temp_blue[0::2] = temp_comb[4:8]
        rgb_trig_vals[i][0][2] = int(''.join(temp_blue),2)

        rgb_trig_vals[i][0] = tuple(rgb_trig_vals[i][0])

    del rgb_trig_vals[[i for i,x in enumerate(rgb_trig_vals) if x[0][1] == backgroundcolor[1] and x[0][2] == backgroundcolor[2]][0]]

    if show_visual:
        fig = plt.figure(figsize = (12.0, 6.5), constrained_layout=True)
        gs = fig.add_gridspec(15, 17)
        for i,x in enumerate(rgb_trig_vals):
            ax = fig.add_subplot(gs[math.floor(i/17), i % 17])
            ax.tick_params( bottom = False, left = False,labelbottom = False, labelleft = False)
            ax.add_patch(plt.Rectangle((0.0,0.0), 0.5, 1.0, fill = True, facecolor = [y/256 for _,y in enumerate(backgroundcolor)]))
            ax.add_patch(plt.Rectangle((0.5,0.0), 0.5, 1.0, fill = True, facecolor = [y/256 for _,y in enumerate(x[0])]))
            ax.set_title(str(x[1]),fontdict = {'fontsize': 7}, pad=2)
        plt.show()
        
    return rgb_trig_vals


backgroundcolor = (200,200,200)
rgb_trig_vals = PixelTrigger_Colors(backgroundcolor, True)







