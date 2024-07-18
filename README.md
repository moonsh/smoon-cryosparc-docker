# smoon-cryosparc-docker

Docker file to install single workstaion version of CryoSparc.


This repository is for the people who want to build docker image containing CryoSparc software.

Because CryoSparc requires the availability of GPU, I had an issue with installing the software directly inside of docker container. (The install prcoess includes GPU check using nvidia-smi command) 

To avoid the issue, we install CryoSparc inside a docker container and commit the changes to a new docker image.


1. First you need to get lincense ID from https://cryosparc.com/. 

2. Modify the license ID in Dockerfile

3. Open terminal where Dockerfile exists and build docker image

```
docker build -t [image name] . 
```

4. After building is done, open a docker container. we will install Cryosparc inside of the docker container. 

```
docker run --name [container name] --gpus '"device=0,1"' --env NVIDIA_DISABLE_REQUIRE=1 -it [image name]
```
--gpus : You can specify which GPU will be used for installing. \
--env NVIDIA_DISABLE_REQUIRE=1 : If you face cuda error, you can use this additionaly.

5. Go to cryosparc_master folder and Install CryoSparc

```
./install.sh    --standalone \
                --license "your license number without quotation marks" \
                --worker_path /home/cryosparcuser/cryosparc/cryosparc_worker \
                --ssdpath /scratch/cryosparc_cache \
                --initial_email "someone@structura.bio" \
                --initial_password "Password123" \
                --initial_username "username" \
                --initial_firstname "FirstName" \
                --initial_lastname "LastName" \
                --port 39001
```

6. Check the cryosparc command is working if not then change path and update current shell session.

```
export PATH=/home/cryosparcuser/cryosparc/cryosparc_master/bin:$PATH
```

```
source ~/.bashrc
```

7. check cryosparcm working

```
cryosparcm start
```

8. Exit from current docker container and save current docker container as new docker image

```
docker commit <container_id> <new_image_name>
```