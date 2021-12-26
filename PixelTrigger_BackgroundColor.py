'''
Get the closest RGB triplets for all triggers given a background rgb color

Inputs:
 
 backgroundcolor       3 element vector specifing the RGB values (between
                       0 and 255) of the background color (e.g. [200,200,200]
 show_visual           If set to true, a figure with all different colors
                       that lead to different trigger values. For each
                       plot the left color is the backgroundcolor and the
                       right is the trigger color
                       (Note that those are not all colors resulting in 
                       their corresponding triggers)
 red_dim_samples       Number of samples along the red color dimension during
                       search. Values of 256 and higher lead to a full search
                       (really slow and often unnecessary). Default = 10

Outputs:
 
 rgb_trig_vals         dict with 256 entries: Each key belongs to a different 
                       trigger value while the entry for a key is the RGB triplet
                       with the closest possible color matching the background
                       


C.Postzich, 25.Dec.2021

'''


# Import Libraries
import matplotlib
import matplotlib.pyplot as plt
import matplotlib.gridspec
import numpy as np


# Define Function
def PixelTrigger_BackgroundColor(backgroundcolor, show_visual, red_dim_samples = 10):

    print("Search for closest color to background for each trigger value:\n")

    all_comb = [bin(i) for i in range(256)]

    temp_blue = temp_green = []
    rgb_trig_vals = {}
    for i,x in enumerate(all_comb):
        temp_comb = list(x)
        temp_comb = temp_comb[2:]
        temp_comb = list('0'*max(0, 8-len(temp_comb))) + temp_comb

        temp_green = list('00000000')
        temp_green[0::2] = temp_comb[0:4]
        temp_blue = list('00000000')
        temp_blue[0::2] = temp_comb[4:8]

        temp_closecol = np.zeros((256,4))
        for j,y in enumerate(all_comb):
            temp_comb2 = list(y)
            temp_comb2 = temp_comb2[2:]
            temp_comb2 = list('0'*max(0, 8-len(temp_comb2))) + temp_comb2
            temp_green[1::2] = temp_comb2[0:4]
            temp_blue[1::2] = temp_comb2[4:8]
            temp_closecol[j,0:4] = get_closest_col([int(''.join(temp_green),2), int(''.join(temp_blue),2)], backgroundcolor, red_dim_samples)
        
        rgb_trig_vals.update({i: tuple([int(n) for _,n in enumerate(temp_closecol[temp_closecol[:,3].argmin(),0:3])])})
        disp_progress(i+1, len(all_comb))
    print("\n\n")

    #del rgb_trig_vals[[i for i,x in enumerate(rgb_trig_vals) if x[0][1] == backgroundcolor[1] and x[0][2] == backgroundcolor[2]][0]]

    if show_visual:
        fig = plt.figure(figsize = (12.0, 6.5), constrained_layout=True)
        gs = fig.add_gridspec(15, 18)
        for i,key in enumerate(rgb_trig_vals):
            ax = fig.add_subplot(gs[int(np.floor(i/18)), i % 18])
            ax.tick_params( bottom = False, left = False,labelbottom = False, labelleft = False)
            ax.add_patch(plt.Rectangle((0.0,0.0), 0.5, 1.0, fill = True, facecolor = [y/256 for _,y in enumerate(backgroundcolor)]))
            ax.add_patch(plt.Rectangle((0.5,0.0), 0.5, 1.0, fill = True, facecolor = [y/256 for _,y in enumerate(rgb_trig_vals[key])]))
            ax.set_title(str(key),fontdict = {'fontsize': 7}, pad=2)
        plt.show()
        
    return rgb_trig_vals

def get_closest_col(bg, backgroundcolor, red_dim_samples):
    eps = 0.0000000001
    bkgd_norm = np.linalg.norm(backgroundcolor)
    start_val = int(np.mean(bg))
    col_dist_list = np.zeros((np.amin([255,start_val+red_dim_samples]) - np.amax([0, start_val-red_dim_samples]),4))
    for ind, c in enumerate(range(np.amax([0, start_val-red_dim_samples]), np.amin([255,start_val+red_dim_samples]), 1)):
        col_dist_list[ind,0:3] = [c] + bg
        col_dist_list[ind,3] = 1 - np.dot(col_dist_list[ind,0:3],backgroundcolor) / np.max([eps, np.linalg.norm(col_dist_list[ind,0:3])]) / bkgd_norm
    return(col_dist_list[col_dist_list[:,3].argmin(),])

def disp_progress(ind, full, barLength = 50):
    perc_done = float(ind) * 100 / full
    prog_done   = '-' * int(perc_done/100 * barLength)
    space  = ' ' * (barLength - len(prog_done))

    print('Progress: [%s%s] %d %% triggers evaluated' % (prog_done, space, perc_done), end='\r')


backgroundcolor = (200,200,200)
rgb_trig_vals = PixelTrigger_BackgroundColor(backgroundcolor,True)
print("\n".join("{}\t{}".format(k, v) for k, v in rgb_trig_vals.items()))

