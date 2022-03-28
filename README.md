# RTGENE with output in .csv
This repository contains only certain files from: [RT_GENE](https://github.com/Tobias-Fischer/rt_gene) edited to fit certain needs and requirements. 



## RT_GENE recreation walkthrough
1. Download the Dockerfile in this repository.
2. Open the [Dockerfile](./Dockerfile) and fill the brackets with the appropriate names or directories.
3. Build the dockerfile using: `$ sudo docker build -f [Dockerfile] . -t [tag_name]`   choose a tag name, put in the dockerfile name and remove brackets (the terminal should be in the same directory as the dockerfile, otherwise substitute the '.' with a PATH)
4. Run the docker container using: `$ sudo docker run --gpus all -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v [/host/path/of/volume/to/mount]:/root/RTGENE -it [tag_name]`, fill the brackets with proper info then remove the brackets.
6. Navigate to proper directory using: `$ cd $HOME/rt_gene/rt_gene_standalone/` in the Docker container terminal.
7. Run the following command to download and test required models: `$ python estimate_gaze_standalone.py --save-estimate --no-vis-gaze`.
8. If step 7 was a success, run this command for a specific folder of images: `$ python estimate_gaze_standalone_csv.py /root/RTGENE/[.../images_folder] --save-estimate --no-vis-gaze`, fill the brackets with proper path and remove brackets.

## estimate_gaze_standalone_csv.py
Here, the following will explain what edits were done in order to change the original source from writing output of each image into a separate text file into one csv file with all results altogether.

1. Create and open a .csv file with a given name and defined column names.
```
with open('results.csv', 'w') as file:
	writer = csv.writer(file)
	writer.writerow(["Frame_number", "Headpose_Horizontal_rad", "Headpose_Vertical_rad", "Gaze_Horizontal_rad", "Gaze_Vertical_rad"])
```
