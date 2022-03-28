#must change cuda based on OS existing cuda version so that would change for 11.1.1 for linx3 instead of 11.0.3 for amr-gt62vr
FROM nvidia/cuda:11.1.1-cudnn8-devel-ubuntu18.04

RUN apt-get update && apt-get install -y lsb-release && apt-get clean all
RUN apt-get -y install git
#RUN apt-get -y install python3.7 && apt-get -y install python3-pip && pip3 install --upgrade pip
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata

#install python 2 with pip, these commands are for python 2 only
RUN apt-get -y install python curl
RUN curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py
RUN python get-pip.py
RUN apt-get -y install python-tk
RUN pip install future
RUN apt-get update
RUN apt-get install -y python3-opencv
RUN apt-get install wget
RUN apt-get install -y python-dev

RUN pip install numpy
RUN pip install scipy
RUN pip install tqdm
RUN pip install Pillow
RUN pip install matplotlib
RUN pip install tensorflow-gpu     
RUN pip install torch torchvision 
RUN pip install opencv-python==4.2.0.32

RUN cd $HOME && git clone https://github.com/Tobias-Fischer/rt_gene.git
RUN cd $HOME/rt_gene/rt_gene_standalone && wget https://raw.githubusercontent.com/Zayat-commits/rtgene_csv/main/estimate_gaze_standalone_csv.py
RUN pip install pyyaml



#ENV PYTHONPATH=$HOME/rt_gene/rt_gene/src

CMD export PYTHONPATH=$HOME/rt_gene/rt_gene/src && bash




