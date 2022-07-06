## 1. Install Docker with GPU Support
Follow the instructions [here](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#docker).
## 2. Docker build
```bash
docker build --tag ericwangyz/gromacs:v2022.2_cuda11.4_mpi -f gmx_2022.2_cuda11.4_mpi.dockerfile
docker push ericwangyz/gromacs:v2022.2_cuda11.4_mpi
```
## 3. Test Docker
Start a container
```bash
docker run --rm --gpus all -v `pwd`/test_case:/data -it ericwangyz/gromacs:v2022.2_cuda11.4_mpi
```

Test if GPU is available:
```bash
nvidia-smi
```
Run test cases
```
cd /data
chmod +x rungmx.sh
./rungmx.sh
```
The following is performance on T4
```
               Core t (s)   Wall t (s)        (%)
       Time:       57.291        7.168      799.3
                 (ns/day)    (hour/ns)
Performance:     1205.384        0.020
```
