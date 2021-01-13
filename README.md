
#	Read Simulator


Create reads from a reference with added noise to test alignment strategies.


Tried [SiLiCO](https://github.com/ethanagbaker/SiLiCO) and [NanoSim](https://github.com/bcgsc/NanoSim). Looked into [Deep Simulator](https://github.com/liyu95/DeepSimulator) and [SimuSCoP](https://github.com/qasimyu/simuscop).

Need something much simpler.


Then try assembling with [Canu](https://canu.readthedocs.io/en/latest/index.html) or even [Masurca](http://masurca.blogspot.com/)


For example, I'd like to test assembling the HLA/MHC region.
This won't be perfect. I know that.


```BASH
samtools faidx hg38.fa chr6:28,510,120-33,480,577 > hg38-mhc.fa
```





