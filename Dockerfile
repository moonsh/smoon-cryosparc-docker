# Use the specified base image
#FROM registry.sdcc.bnl.gov/sciserver/gpu-essentials:pytorch-2.1.0b041924c

# FROM nvidia/cuda:11.4.3-devel-ubuntu20.04
FROM nvidia/cuda:11.4.3-devel-ubuntu20.04

# Set environment variables
ENV LICENSE_ID="your license id"
ENV CRYOSPARC_USER="cryosparcuser"
ENV INSTALL_PATH="/home/$CRYOSPARC_USER/cryosparc"
ENV WORKER_PATH="$INSTALL_PATH/cryosparc_worker"
ENV SSD_PATH="/scratch/cryosparc_cache"
ENV USER=cryosparcuser  


# Set USER environment variable explicitly

# Create user and necessary directories as root
USER root
RUN apt-get update && \
    apt-get install -y iputils-ping curl vim && \	
    useradd -ms /bin/bash $CRYOSPARC_USER && \
    mkdir -p $INSTALL_PATH && \
    mkdir -p $SSD_PATH && \
    chown -R $CRYOSPARC_USER:$CRYOSPARC_USER $INSTALL_PATH $SSD_PATH

# Switch to the cryosparcuser for subsequent commands
USER $CRYOSPARC_USER
WORKDIR $INSTALL_PATH

# Ensure that cryosparcuser has write permissions
RUN chmod -R 777 $INSTALL_PATH

# Download cryosparc_master package
RUN curl -L https://get.cryosparc.com/download/master-latest/$LICENSE_ID -o cryosparc_master.tar.gz

# Download cryosparc_worker package
RUN curl -L https://get.cryosparc.com/download/worker-latest/$LICENSE_ID -o cryosparc_worker.tar.gz

# Extract cryosparc_master package
RUN tar -xf cryosparc_master.tar.gz

# Extract cryosparc_worker package
RUN tar -xf cryosparc_worker.tar.gz

# Expose the necessary ports
# PORT_NUMBER is used for the main CryoSPARC web interface
# 39001 and 39002 are default ports used for other CryoSPARC services
EXPOSE 39000
EXPOSE 39001
EXPOSE 39002
EXPOSE 39003
EXPOSE 39004
EXPOSE 39006



# Set up the entrypoint
ENTRYPOINT ["bash"]

