
# This script was used to: 
# 1. Normalize the field 
# 2. Mask the field 

# Connceted script: 3_1_Masking_general  
# Run it after this script 

import s4l_v1 as s4l
import numpy as np
import XPostProcessor as xp
import XPostProcessorUI as xpui
import XCoreModeling as xc
import os
import time
#import scipy.io as sio
#from scipy.optimize import minimize, minimize_scalar
from XCore import *
from XCoreUI import *
import matplotlib.pyplot as plt

class Norm_Masking:
	
	def __init__(self,List_Ents_Names,sim, sens, new_name):

	
		## Calculate flux
		overall_field=sim['Overall Field']
		J_field=overall_field.Outputs['J(x,y,z,f0)'] #GetPort('J(x,y,z,f0)')
		mf = s4l.analysis.core.FieldMaskingFilter()
		mf.SetInputConnection(J_field)
		mf.SetAllMaterials(True)
		mf.UseNaN=0
		mf.ReplacementValue=0+0j
		ids = [info.ID for info in mf.VoxeledMaterials()() if "Background" in info.Name]
		mf.SetMaterial(ids[0], False)
		
		mf.UpdateAttributes()
		mf.Update(0)
		newfield=mf.GetOutputPort(0)
		
		## create moodel and convert to surface grid
		model2grid = s4l.analysis.core.ModelToGridFilter()
		model2grid.Entity=sens
		model2grid.MaximumEdgeLength=1 #mm

		## evaluate flux
		flux_eval = s4l.analysis.core.FieldFluxEvaluator()
		flux_eval.SetInputConnection(0,newfield)
		flux_eval.SetInputConnection(1,model2grid.GetOutputPort(0))
		flux_eval.Update(0)
		flux=flux_eval.GetOutput(1).GetComponent(0)
		flux=np.abs(flux[0].real)
		
		##########
		## Masking 
		self.Entities=[]
		for ent in List_Ents_Names:
			self.Entities.append(ents[ent])

		#sensor=sim['Overall Field']
		sensor=sim['Overall Field']
		sensore=sensor.Outputs['EM E(x,y,z,f0)']
		sensore.Update()
		
		mf = s4l.analysis.core.FieldMaskingFilter()
		mf.SetInputConnection(sensore) #changed vb 
		mf.SetAllMaterials(False)
		mf.SetEntities(self.Entities,)
		#mf.ReplacementValue = 0
		mf.UpdateAttributes()
		mf.Update(0)
		newfield=mf.GetOutputPort(0)

		
		name = new_name #'Brain ' + sim.Name 
		em=sensore.Data
		newdata=s4l.analysis.core.ComplexFloatFieldData()
		newdata.Allocate(em.NumberOfSnapshots, em.NumberOfTuples, em.NumberOfComponents)
		newdata.Grid=em.Grid
		newdata.NumberOfSnapshots=em.NumberOfSnapshots
		newdata.Quantity=em.Quantity
		newdata.SnapshotQuantity=em.SnapshotQuantity
		newdata.Snapshots=em.Snapshots
		newdata.ValueLocation=em.ValueLocation
		newdata.SetField(0,np.complex64(newfield.Data.Field(0)*1e-3/flux)) # 

		newdata.Quantity.Name=name

		source4 = xp.TrivialProducer(); source4.SetDataObject(newdata)
		source4.Description='Configuration_' + new_name #sim.Name #self.metric.metric+'_'+str(a1)+'_'+str(a2) 

		slice_field_viewer_e_field = s4l.analysis.viewers.SliceFieldViewer()
		slice_field_viewer_e_field.Name=name
		slice_field_viewer_e_field.SetInputConnection(source4.GetOutputPort(0))
		slice_field_viewer_e_field.Plane = s4l.analysis.viewers.SliceFieldViewer.ePlane.kXY
		slice_field_viewer_e_field.Slice = 112
		slice_field_viewer_e_field.DecibelScale = False
		slice_field_viewer_e_field.ScalarRange = (0,10)
		slice_field_viewer_e_field.Smooth = True
		slice_field_viewer_e_field.Update(0)
		s4l.analysis.RegisterAlgorithm(slice_field_viewer_e_field)	

	