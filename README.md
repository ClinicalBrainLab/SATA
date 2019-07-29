# Systematic Approach for tDCS analysis (SATA) is a Matlab Based toolbox.
# ** SATA is a post-processing toolbox after tDCS montages have been simulated in COMETS or ROAST
# to download the GUI version of SATA plese visit https://doi.org/10.21979/N9/DMWPZK



## Installation

The complete installation guide for SATA software package is availaible in the reference manual
---------------------------
--------------------

############# Features
# Input Features
- [1] Takes montages from COMETS or ROAST (Please cite the respective references)

# Output Features
- [1] Current density in each cortical Lobe - Amount of stimulation received in each cortical area of the brain
- [2] Overlap - If there are multiple cortical routes that process the information (e.g., Dorsal and venntral routes in Language, Vision, etc) in the brain, SATA helps to decide the montage that is most appropriate so that user can stimulate one route thereby minimally stimulating the other or can also chose the montage that stimulates both routes.

#### Overall use of SATA

- [1] Solves the ambiguities in montage selection
- [2] Aids selection of Appropriate tDCS Montage

********* Please cite the papers if you are using SATA

[1] Bhattacharjee, S., Kashyap, R., Rapp, B., Oishi, K., Desmond, J., & Chen, S. (2019). Simulation Analyses of tDCS Montages for the Investigation of Dorsal and Ventral Pathways. Scientific Reports (in press) 

[2] Lancaster, J. L., Rainey, L. H., Summerlin, J. L., Freitas, C. S., Fox, P. T., Evans, A. C., � Mazziotta, J.  
C. (1997). Automated labeling of the human brain: A preliminary report on the development and evaluation of a forward-transform method. Human Brain Mapping, 5(4), 238�242.  

[3] Lancaster, J. L., Woldorff, M. G., Parsons, L. M., Liotti, M., Freitas, C. S., Rainey, L., Fox, P. T. (2000). Automated Talairach atlas labels for functional brain mapping. Human Brain Mapping, 10(3), 120� 131.
  
[4] Oostenveld, R., Fries, P., Maris, E., & Schoffelen, J.-M. (2011). FieldTrip: Open Source Software for  
Advanced Analysis of MEG, EEG, and Invasive Electrophysiological Data. Computational  
Intelligence & Neuroscience, 1�9. https://doi.org/10.1155/2011/156869  

[5] SPM - Statistical Parametric Mapping. (n.d.). Retrieved July 5, 2019, from  
https://www.fil.ion.ucl.ac.uk/spm/ 

* If COMETS was used to generate inputs for SATA
[6] Lee, C., Jung, Y.-J., Lee, S. J., & Im, C.-H. (2017). COMETS2: An advanced MATLAB toolbox for the  
numerical analysis of electric fields generated by transcranial direct current stimulation. Journal of 
Neuroscience Methods, 277, 56�62.

* If ROAST was used to generate inputs for SATA
[7] Huang, Y., Datta, A., Bikson, M., & Parra, L. C. (2019). Realistic vOlumetric-Approach to Simulate Transcranial Electric Stimulation � ROAST � a fully automated open-source pipeline. Journal of Neural Engineering, 2019  
 

