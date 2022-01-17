'''
Convert a Trigger Value into all possbile RGB triplets for ProPixx

Inputs:
 
 triggervalue       integer between 0 and 255 indicating the trigger value 

Outputs:

 GB                 list of all 2 element vector specifing an GB tuple with values between
                    0 and 255 (e.g. [200,200]) that are associated with the triggervalue
                    (Note that the the red value can vary freely)
 
                       

C.Postzich, 25.Dec.2021

'''

import numpy as np
print(np.__version__)

def triggervalue2gb(triggervalue):

    trigger_bin = list(bin(triggervalue))
    trigger_bin = trigger_bin[2:]
    trigger_bin = list('0'*max(0, 8-len(trigger_bin))) + trigger_bin

    all_comb = [bin(i) for i in range(256)]

    temp_green = list('00000000')
    #temp_green[0::2] = trigger_bin[0:4]
    temp_green[4:8] = trigger_bin[4:8]
    temp_blue = list('00000000')
    #temp_blue[0::2] = trigger_bin[4:8]
    temp_blue[4:8] = trigger_bin[0:4]

    GB = [[] for _ in range(len(all_comb))]
    for j,y in enumerate(all_comb):
        temp_comb2 = list(y)
        temp_comb2 = temp_comb2[2:]
        temp_comb2 = list('0'*max(0, 8-len(temp_comb2))) + temp_comb2
        #temp_green[1::2] = temp_comb2[0:4]
        temp_green[0:4] = temp_comb2[0:4]
        #temp_blue[1::2] = temp_comb2[4:8]
        temp_blue[0:4] = temp_comb2[4:8]
        GB[j] = (int("0b" + "".join(temp_green),2), int("0b" + "".join(temp_blue),2))

    return(GB)

print(triggervalue2gb(32))
