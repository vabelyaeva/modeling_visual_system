
# This script was used to collect masked fields 
# and to save it for Matlab
# The results are stored in 'efields_masked'

import numpy as np
import s4l_v1 as s4l
import os 
import scipy.io

os.chdir('E:/Temp_VB/efields_masked')

ents=s4l.model.AllEntities()
sims_res = s4l.document.AllAlgorithms

# Masked fields numbers: 
alg_numbers = [40, 42, 46, 48, 50, 52, 61, 63, 67, 69, 71, 73]

for i_num in alg_numbers: 

	sim = sims_res[i_num]
	sim_output = sim.Outputs[0]

	field = sim_output.Data.Field(0)
	#len(field)

	field2 = field[~np.isnan(field)]
	#len(field2)
	#np.size(field)

	# add name 
	name_mat = sim_output.Description

	scipy.io.savemat(name_mat, {'data': field2})
