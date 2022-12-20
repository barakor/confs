import sys
import json
import subprocess

def command_output(cmd):
    output = []
    if (cmd):
        p = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, \
                                 stderr=subprocess.STDOUT)
        for line in p.stdout.readlines():
            output.append(line.rstrip())
    return b"".join(output)

def find_windows(tree_dict, window_list):
    if len(tree_dict.get("nodes",[])) > 0:
        for node in tree_dict["nodes"]:
            find_windows(node, window_list)
    else:
        if (tree_dict["layout"] != "dockarea" and not tree_dict["name"].startswith("i3bar for output") and not tree_dict["window"] == None):
            window_list.append(tree_dict)

    return window_list        




def main(backwards = False):
    cmd = "i3-msg -t get_tree"
    tree_str = command_output(cmd)
    tree_dict = json.loads(tree_str)
    window_list = find_windows(tree_dict, [])


    
    if backwards:
        next_index = len(window_list)
        for i in range(len(window_list)-1, -1, -1):
            if (window_list[i]["focused"] == True):
                next_index = i-1
                break
    else:
        next_index = -1
        for i in range(len(window_list)):
            if (window_list[i]["focused"] == True):
                next_index = i+1
                break

    

    next_id = 0;
    if next_index == -1 or next_index == len(window_list):
        next_id = window_list[0]["window"]
    else:        
        next_id = window_list[next_index]["window"]

    print (next_id)

backwards = False
argl = sys.argv
if len(argl)>1:
    arg1 = sys.argv[1]
    if arg1 == "backward":
        backwards=True

main(backwards)
