'''
Convert RGB Triplet into Trigger Value for ProPixx

Inputs:
 
 RGB                3 element vector specifing an RGB triplet with values between
                    0 and 255 (e.g. [200,200,200])

Outputs:
 
 triggervalue       integer between 0 and 255 indicating the trigger value associated
                    with the RGB triplet
                       

C.Postzich, 25.Dec.2021

'''


def rgb2triggervalue(rgb):

    green_bin = list(bin(rgb[1]))
    green_bin = green_bin[2:]
    green_bin = list('0'*max(0, 8-len(green_bin))) + green_bin
    blue_bin = list(bin(rgb[2]))
    blue_bin = blue_bin[2:]
    blue_bin = list('0'*max(0, 8-len(blue_bin))) + blue_bin

    #trigger_bin = green_bin[0::2] + blue_bin[0::2]
    trigger_bin =  blue_bin[4:8] + green_bin[4:8]
    trigger_bin = "0b" + "".join(trigger_bin)
    return(int(trigger_bin,2))


print(rgb2triggervalue([103,0,2]))
print(rgb2triggervalue([255,1,3]))
print(rgb2triggervalue([10,4,1]))
print(rgb2triggervalue([0,2,0]))
print(rgb2triggervalue([0,8,0]))
print(rgb2triggervalue([0,10,0]))
print(rgb2triggervalue([128,128,128]))
