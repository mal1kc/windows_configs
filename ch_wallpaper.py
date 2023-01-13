import os
import random
import shutil
import ctypes

def main(wallpapers_path:str,cur_wall_path:str):
    random_selected_image = wallpapers_path + str(random.choice(os.listdir(wallpapers_path)))
    print(f'{random_selected_image= }')
    shutil.copyfile(random_selected_image,cur_wall_path)
    os.system('wal -c')
    os.system(f'wal -e -s -t -i "{random_selected_image}"')
    ctypes.windll.user32.SystemParametersInfoW(20,0,random_selected_image,0)
    

if __name__ == "__main__":
    wallpapers_path = '~/Pictures/wallpapers/'.replace('~', 'C:/Users/malikc')
    cur_wall_path = '~/Pictures/current_wallpaper'.replace('~', 'C:/Users/malikc')
    main(wallpapers_path,cur_wall_path)
