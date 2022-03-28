# RTGENE with output in .csv
This repository contains only certain files from: [RT_GENE](https://github.com/Tobias-Fischer/rt_gene) edited to fit certain needs and requirements. 



## RT_GENE recreation walkthrough
1. Download the Dockerfile in this repository.
2. Build the dockerfile using: `$ sudo docker build -f [Dockerfile] . -t [tag_name]`   choose a tag name, put in the dockerfile name and remove brackets (the terminal should be in the same directory as the dockerfile, otherwise substitute the '.' with a PATH)
3. Run the docker container using: `$ sudo docker run --gpus all -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v [/host/path/of/volume/to/mount]:/root/RTGENE -it [tag_name]`, fill the brackets with proper info then remove the brackets.
4. Navigate to proper directory using: `$ cd $HOME/rt_gene/rt_gene_standalone/` in the Docker container terminal.
5. Run the following command to download and test required models: `$ python estimate_gaze_standalone.py --save-estimate --no-vis-gaze`.
6. If step 5 was a success, run this command for a specific folder of images: `$ python estimate_gaze_standalone_csv.py /root/RTGENE/[.../images_folder] --save-estimate --no-vis-gaze`, fill the brackets with proper path and remove brackets.

## estimate_gaze_standalone_csv.py
Here, the following will explain what edits were done in order to change the original source from writing output of each image into a separate text file into one csv file with all results altogether.

1. Create and open a .csv file with a given name of image file and defined column names after an image/directory is properly read.
```
with open(os.path.basename(os.path.dirname(os.path.dirname(args.im_path))) + '.csv', 'w') as csvfile: 
        writer = csv.writer(csvfile)
        writer.writerow(["Frame_number", "Headpose_Horizontal_rad", "Headpose_Vertical_rad", "Gaze_Horizontal_rad", "Gaze_Vertical_rad"])
```
2. Edit the saving method by saving each results as a new entry row to the .csv file
```
if args.save_estimate:
            # add subject_id to cope with multiple persons in one image
	    #textfile method:
            ...
	    #csv method:
	    csv_row = os.path.splitext(base_name)[0] + ', ' + str(headpose[1]) + ', ' + str(headpose[0]) + ', ' + str(gaze[1]) + ', ' + str(gaze[0]) + '\n' 
	    with open(os.path.basename(os.path.dirname(os.path.dirname(args.im_path))) + '.csv', 'a') as f:
		f.write(csv_row)
```

## Automating RT_GENE for bulk entries
To make the process faster and run RT_GENE on multiple directories at the same time, utilizing multithreading is necessary which is hardware dependent and some trials should be done at first to check the capacity of such device. In our case, the available processing unit can run 3 threads simultaneously with a success rate of 92%, meaning in some cases some threads produced empty csv files and needed to be run again.

* Type in the Docker container terminal: `$ python estimate_gaze_standalone_csv.py /root/RTGENE/*/[images_folder] --save-estimate --no-vis-gaze &` 3 times equates to 3 threads. Use `wait` in order to separate between batches of threads.
 ### Example:
 ```
 $ python estimate_gaze_standalone_csv.py /root/RTGENE/*/[images_folder1] --save-estimate --no-vis-gaze &
 $ python estimate_gaze_standalone_csv.py /root/RTGENE/*/[images_folder2] --save-estimate --no-vis-gaze &
 $ python estimate_gaze_standalone_csv.py /root/RTGENE/*/[images_folder3] --save-estimate --no-vis-gaze &
 wait
 $ python estimate_gaze_standalone_csv.py /root/RTGENE/*/[images_folder4] --save-estimate --no-vis-gaze &
 $ python estimate_gaze_standalone_csv.py /root/RTGENE/*/[images_folder5] --save-estimate --no-vis-gaze &
 $ python estimate_gaze_standalone_csv.py /root/RTGENE/*/[images_folder6] --save-estimate --no-vis-gaze &
 ```
 *The process can be further automated by creating a bash file with a function looping over the commands mentioned above if the files are named in a way that allows that.
