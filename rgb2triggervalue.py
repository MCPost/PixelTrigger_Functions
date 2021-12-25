
def rgb2triggervalue(rgb):

    green_bin = list(bin(rgb[1]))
    green_bin = green_bin[2:]
    green_bin = list('0'*max(0, 8-len(green_bin))) + green_bin
    blue_bin = list(bin(rgb[2]))
    blue_bin = blue_bin[2:]
    blue_bin = list('0'*max(0, 8-len(blue_bin))) + blue_bin

    trigger_bin = green_bin[0::2] + blue_bin[0::2]
    trigger_bin = "0b" + "".join(trigger_bin)
    return(int(trigger_bin,2))


print(rgb2triggervalue([0,1,14]))
print(rgb2triggervalue([200,202,201]))
print(rgb2triggervalue([27,14,226]))