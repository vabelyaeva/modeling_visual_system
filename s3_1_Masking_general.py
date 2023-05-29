
# This script was used to collect masks 
# in 2 configurations: (1) Cz and Oz, 
# (2) F9 and F10

# Masks collected: V1, retina and other visual system

# Connceted script: 3_2_Masking_library 
# Run it before this script 

import numpy as np
import s4l_v1 as s4l

ents=s4l.model.AllEntities()
sims_res = s4l.document.AllAlgorithms

# inside grey matter etc
brain_fold=ents['Brain']
brain_ents = [a.Name for a in brain_fold.Entities] 

# main targets and GM 
Retina_mask = ['Eye Retina_Choroid_Sclera']
V1_mask = ['Weronika_V1_v4'] 
GM_mask = ['Brain Gray Matter']

# additional masks - visual system 
Optic_nerve_mask = ['Cranial Nerve II - Optic']
Optic_chiasm_mask = ['Optic Chiasm']
Optic_tract_mask = ['Optic Tract']
Optic_lgn_mask = ['Posterior_thalamus']

# enter number of the field in the list 
sim = sims_res[33] 
print(sim.Name) # to verify the number above

#sens=ents['Sensore_round F10 v 1'] # sensore for F9 F10 configuration 
sens=ents['Sensore_Block_Oz'] # sensore for Oz Cz configuration 

# Mask fields - main and additional targets: 

#Norm_Masking(brain_ents, sim, sens, 'Brain_F9_F10_ret0.3mm_mask')
#Norm_Masking(Retina_mask, sim, sens, 'Retina_F9_F10_ret0.3mm_mask')
#Norm_Masking(V1_mask, sim, sens, 'V1_F9_F10_ret0.3mm_mask')
#Norm_Masking(GM_mask, sim, sens, 'GM_F9_F10_ret0.3mm_mask')
#Norm_Masking(Optic_nerve_mask, sim, sens, 'OpNerve_F9_F10_ret0.3mm_mask')
#Norm_Masking(Optic_chiasm_mask, sim, sens, 'OpChiasm_F9_F10_ret0.3mm_mask')
#Norm_Masking(Optic_tract_mask, sim, sens, 'OpTract_F9_F10_ret0.3mm_mask')
#Norm_Masking(Optic_lgn_mask, sim, sens, 'OpLGN_F9_F10_ret0.3mm_mask')

#Norm_Masking(brain_ents, sim, sens, 'Brain_Oz_Cz_ret0.3mm_mask')
#Norm_Masking(Retina_mask, sim, sens, 'Retina_Oz_Cz_ret0.3mm_mask')
#Norm_Masking(V1_mask, sim, sens, 'V1_Oz_Cz_ret0.3mm_mask')
#Norm_Masking(GM_mask, sim, sens, 'GM_Oz_Cz_ret0.3mm_mask')
#Norm_Masking(Optic_nerve_mask, sim, sens, 'OpNerve_Oz_Cz_ret0.3mm_mask')
#Norm_Masking(Optic_chiasm_mask, sim, sens, 'OpChiasm_Oz_Cz_ret0.3mm_mask')
#Norm_Masking(Optic_tract_mask, sim, sens, 'OpTract_Oz_Cz_ret0.3mm_mask')
Norm_Masking(Optic_lgn_mask, sim, sens, 'OpLGN_Oz_Cz_ret0.3mm_mask')
