rm(list = ls())

.libPaths('C:/Users/vbeliaev/Documents/r_packages')
library(ggplot2)
library(data.table)
library(stringr) 
library(gridExtra)

################### SCRIPT CONTAINS ###################

# 1. Data explained 
# 2. Plots 
# 3. Summary tables

################### DATA EXPLAINED ###################

# loading data 
tab = read.csv('Data_6masks.csv')

tab = as.data.table(tab)

# There are 6 masks from 1 to 6 
# 1 - chiasm, 2 - LGN, 3 - Nerve, 4 - tract, 5 - retina, 6 - V1 
tab$Mask = factor(tab$Mask, labels = c('Optic Chiasm', 'LGN', 'Optic Nerve', 
                                       'Optic tract', 'Retina', 'V1'))

# reordering the masks from Retina to V1 - brain anterior-posterior 
tab$Mask = factor(tab$Mask, levels = c('Retina', 'Optic Nerve', 
                                       'Optic Chiasm', 'Optic tract', 
                                       'LGN','V1'))

# Congig = configurations
# 1 - F9 and F10, 2 - Oz and Cz 
tab$Config = factor(tab$Config, labels = c('F9 and F10', 'Oz and Cz'))

# Other columns: 
# Efield - field (V/m) per voxel 
# Priority - 1 or 2 - 1 is main targets: V1 and retina, 2 - other targets  

################### PLOTS ###################

# Weronika plot colors   

orange1 = '#FBB479' 
gray1 = '#808080'
blue1 = '#6AC2F8'
black1 = '#000000'

#### ALL MASKS F9 and F10 - 0.2 mA #### 

tab_plot = tab[Config == 'F9 and F10']
tab_plot$Efield_01mA = tab_plot$Efield/10 
tab_plot$Efield_02mA = tab_plot$Efield_01mA * 2 
tab_plot$Efield_03mA = tab_plot$Efield_01mA * 3 

mult = 1
size_text1 = 15
size_text2 = 20

# plot whisker plot 
g2 = ggplot(tab_plot, aes(x=Mask, y=Efield_02mA)) +
  geom_boxplot(alpha = 0.9, color = black1, fill = orange1) + 
  #geom_boxplot() +
  xlab('Regions') + 
  ylab('E-field V/m') + 
  ggtitle('Visual system: F9 and F10, 0.2 mA') + 
  theme_bw()  + 
  theme(axis.title=element_text(size=size_text1*mult, face = "bold")) + 
  theme(axis.text=element_text(size=size_text1*mult)) +
  theme(text = element_text(size=size_text1*mult), axis.text.x = element_text(size=size_text1*mult), 
        axis.text.y = element_text(size=size_text1*mult)) + 
  theme(plot.title = element_text(size=size_text2*mult)) + 
  theme(plot.title = element_text(face = "bold")) + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + 
  scale_x_discrete(labels = function(x) str_wrap(x, width = 6))
g2

#### ALL MASKS Oz and Cz - 1 mA #### 

tab_plot = tab[Config == 'Oz and Cz']
tab_plot$Efield_15mA = tab_plot$Efield #*1.5 

# plot whisker plot 
g1 = ggplot(tab_plot, aes(x=Mask, y=Efield_15mA)) +
  geom_boxplot(alpha = 0.9, color = black1, fill = orange1) + 
  #geom_boxplot() +
  xlab('Regions') + 
  ylab('E-field V/m') + 
  ggtitle('Visual system: Oz and Cz, 1 mA') + 
  theme_bw()  + 
  theme(axis.title=element_text(size=size_text1*mult, face = "bold")) + 
  theme(axis.text=element_text(size=size_text1*mult)) +
  theme(text = element_text(size=size_text1*mult), axis.text.x = element_text(size=size_text1*mult), 
        axis.text.y = element_text(size=size_text1*mult)) + 
  theme(plot.title = element_text(size=size_text2*mult)) + 
  theme(plot.title = element_text(face = "bold")) + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + 
  scale_x_discrete(labels = function(x) str_wrap(x, width = 6))
g1

#### RETINA comparison MEDIUM stim #### 

tab_plot = tab[Mask == 'Retina']

tab_plot1 = tab_plot[Config == 'Oz and Cz']
tab_plot1$Efield_plot = tab_plot1$Efield #* 1.5
tab_plot2 = tab_plot[Config == 'F9 and F10']
tab_plot2$Efield_plot = (tab_plot2$Efield/10)*2 

tab_plot = rbind(tab_plot1, tab_plot2)

mult = 1
size_text1 = 15
size_text2 = 18

# plot whisker plot 
g1 = ggplot(tab_plot, aes(x=Config, y=Efield_plot)) +
  geom_boxplot(alpha = 0.6, color = black1, fill = orange1) + 
  #geom_boxplot() +
  xlab('Electrodes') + 
  ylab('E-field V/m') + 
  ggtitle('Retina: F9 and F10 0.2 mA, Oz and Cz 1 mA') + 
  theme_bw()  + 
  theme(axis.title=element_text(size=size_text1*mult, face = "bold")) + 
  theme(axis.text=element_text(size=size_text1*mult)) +
  theme(text = element_text(size=size_text1*mult), axis.text.x = element_text(size=size_text1*mult), 
        axis.text.y = element_text(size=size_text1*mult)) + 
  theme(plot.title = element_text(size=size_text2*mult)) + 
  theme(plot.title = element_text(face = "bold")) + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + 
  scale_x_discrete(labels = function(x) str_wrap(x, width = 12))
g1

#### RETINA comparison LARGE stim #### 

tab_plot = tab[Mask == 'Retina']

tab_plot1 = tab_plot[Config == 'Oz and Cz']
tab_plot1$Efield_plot = tab_plot1$Efield* 1.5
tab_plot2 = tab_plot[Config == 'F9 and F10']
tab_plot2$Efield_plot = (tab_plot2$Efield/10)*3 

tab_plot = rbind(tab_plot1, tab_plot2)

# plot whisker plot 
g1 = ggplot(tab_plot, aes(x=Config, y=Efield_plot)) +
  geom_boxplot(alpha = 0.6, color = black1, fill = blue1) + 
  #geom_boxplot() +
  xlab('Electrodes') + 
  ylab('E-field V/m') + 
  ggtitle('Retina: F9 and F10 0.3 mA, Oz and Cz 1.5 mA') + 
  theme_bw()  + 
  theme(axis.title=element_text(size=size_text1*mult, face = "bold")) + 
  theme(axis.text=element_text(size=size_text1*mult)) +
  theme(text = element_text(size=size_text1*mult), axis.text.x = element_text(size=size_text1*mult), 
        axis.text.y = element_text(size=size_text1*mult)) + 
  theme(plot.title = element_text(size=size_text2*mult)) + 
  theme(plot.title = element_text(face = "bold")) + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + 
  scale_x_discrete(labels = function(x) str_wrap(x, width = 12))
g1

#### NERVE comparison MEDIUM stim #### 

tab_plot = tab[Mask == 'Optic Nerve']

tab_plot1 = tab_plot[Config == 'Oz and Cz']
tab_plot1$Efield_plot = tab_plot1$Efield #* 1.5
tab_plot2 = tab_plot[Config == 'F9 and F10']
tab_plot2$Efield_plot = (tab_plot2$Efield/10)*2 

tab_plot = rbind(tab_plot1, tab_plot2)

# plot whisker plot 
g1 = ggplot(tab_plot, aes(x=Config, y=Efield_plot)) +
  geom_boxplot(alpha = 0.6, color = black1, fill = orange1) + 
  #geom_boxplot() +
  xlab('Electrodes') + 
  ylab('E-field V/m') + 
  ggtitle('Nerve: F9 and F10 0.2 mA, Oz and Cz 1 mA') + 
  theme_bw()  + 
  theme(axis.title=element_text(size=size_text1*mult, face = "bold")) + 
  theme(axis.text=element_text(size=size_text1*mult)) +
  theme(text = element_text(size=size_text1*mult), axis.text.x = element_text(size=size_text1*mult), 
        axis.text.y = element_text(size=size_text1*mult)) + 
  theme(plot.title = element_text(size=size_text2*mult)) + 
  theme(plot.title = element_text(face = "bold")) + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + 
  scale_x_discrete(labels = function(x) str_wrap(x, width = 12))
g1

#### NERVE comparison LARGE stim #### 

tab_plot = tab[Mask == 'Optic Nerve']

tab_plot1 = tab_plot[Config == 'Oz and Cz']
tab_plot1$Efield_plot = tab_plot1$Efield* 1.5
tab_plot2 = tab_plot[Config == 'F9 and F10']
tab_plot2$Efield_plot = (tab_plot2$Efield/10)*3 

tab_plot = rbind(tab_plot1, tab_plot2)

# plot whisker plot 
g1 = ggplot(tab_plot, aes(x=Config, y=Efield_plot)) +
  geom_boxplot(alpha = 0.6, color = black1, fill = blue1) + 
  #geom_boxplot() +
  xlab('Electrodes') + 
  ylab('E-field V/m') + 
  ggtitle('Nerve: F9 and F10 0.3 mA, Oz and Cz 1.5 mA') + 
  theme_bw()  + 
  theme(axis.title=element_text(size=size_text1*mult, face = "bold")) + 
  theme(axis.text=element_text(size=size_text1*mult)) +
  theme(text = element_text(size=size_text1*mult), axis.text.x = element_text(size=size_text1*mult), 
        axis.text.y = element_text(size=size_text1*mult)) + 
  theme(plot.title = element_text(size=size_text2*mult)) + 
  theme(plot.title = element_text(face = "bold")) + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + 
  scale_x_discrete(labels = function(x) str_wrap(x, width = 12))
g1

#### V1 and RETINA comparison #### 

tab_plot = tab[Priority == 1]

tab_plot1 = tab_plot[Config == 'Oz and Cz']
tab_plot1$Efield_plot = tab_plot1$Efield #* 1.5

tab_plot2 = tab_plot[Config == 'F9 and F10']
tab_plot2$Efield_plot = (tab_plot2$Efield/10)*2 

# plot whisker plot 
g1 = ggplot(tab_plot2, aes(x=Mask, y=Efield_plot)) +
  geom_boxplot(alpha = 0.9, color = black1, fill = orange1) + 
  #geom_boxplot() +
  xlab('Regions') + 
  ylab('E-field V/m') + 
  ggtitle('F9 and F10 0.2 mA') + 
  theme_bw()  + 
  theme(axis.title=element_text(size=size_text1*mult, face = "bold")) + 
  theme(axis.text=element_text(size=size_text1*mult)) +
  theme(text = element_text(size=size_text1*mult), axis.text.x = element_text(size=size_text1*mult), 
        axis.text.y = element_text(size=size_text1*mult)) + 
  theme(plot.title = element_text(size=size_text2*mult)) + 
  theme(plot.title = element_text(face = "bold")) + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + 
  scale_x_discrete(labels = function(x) str_wrap(x, width = 12))
g1

# plot whisker plot 
g2 = ggplot(tab_plot1, aes(x=Mask, y=Efield_plot)) +
  geom_boxplot(alpha = 0.9, color = black1, fill = blue1) + 
  #geom_boxplot() +
  xlab('Regions') + 
  ylab('E-field V/m') + 
  ggtitle('Oz and Cz 1 mA') + 
  theme_bw()  + 
  theme(axis.title=element_text(size=size_text1*mult, face = "bold")) + 
  theme(axis.text=element_text(size=size_text1*mult)) +
  theme(text = element_text(size=size_text1*mult), axis.text.x = element_text(size=size_text1*mult), 
        axis.text.y = element_text(size=size_text1*mult)) + 
  theme(plot.title = element_text(size=size_text2*mult)) + 
  theme(plot.title = element_text(face = "bold")) + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + 
  scale_x_discrete(labels = function(x) str_wrap(x, width = 12))
g2

grid.arrange(g1, g2, nrow = 1, ncol=2, widths=c(1,1))


################### SUMMARY TABLES  ###################

tab_sum = tab

tab_sum1 = tab_sum[Config == 'Oz and Cz']
tab_sum1$Efield_plot075 = tab_sum1$Efield* 0.75
tab_sum1$Efield_plot1 = tab_sum1$Efield*1
tab_sum1$Efield_plot15 = tab_sum1$Efield*1.5

tab_sum1_red = tab_sum1[,.(mean(Efield_plot075), sd(Efield_plot075),
                           mean(Efield_plot1), sd(Efield_plot1), 
                           mean(Efield_plot15), sd(Efield_plot15)), by = Mask]

tab_sum1_red2 = round(tab_sum1_red[,V1:V6],2)
tab_sum1_red2$Mask = tab_sum1_red$Mask

tab_sum1_red3 = as.data.table(tab_sum1_red$Mask)
tab_sum1_red3$Efield_075 = paste0(tab_sum1_red2$V1, '+-', tab_sum1_red2$V2)
tab_sum1_red3$Efield_1 = paste0(tab_sum1_red2$V3, '+-', tab_sum1_red2$V4)
tab_sum1_red3$Efield_15 = paste0(tab_sum1_red2$V5, '+-', tab_sum1_red2$V6)

write.csv(tab_sum1_red3, 'Oz_Cz_results.csv')

tab_sum2 = tab_sum[Config == 'F9 and F10']
tab_sum2$Efield_plot01 = tab_sum2$Efield* 0.1
tab_sum2$Efield_plot02 = tab_sum2$Efield*0.2
tab_sum2$Efield_plot03 = tab_sum2$Efield*0.3

tab_sum2_red = tab_sum2[,.(mean(Efield_plot01), sd(Efield_plot01),
                           mean(Efield_plot02), sd(Efield_plot02), 
                           mean(Efield_plot03), sd(Efield_plot03)), by = Mask]

tab_sum2_red2 = round(tab_sum2_red[,V1:V6],2)
tab_sum2_red2$Mask = tab_sum2_red$Mask

tab_sum2_red3 = as.data.table(tab_sum2_red$Mask)
tab_sum2_red3$Efield_01 = paste0(tab_sum2_red2$V1, '+-', tab_sum2_red2$V2)
tab_sum2_red3$Efield_02 = paste0(tab_sum2_red2$V3, '+-', tab_sum2_red2$V4)
tab_sum2_red3$Efield_03 = paste0(tab_sum2_red2$V5, '+-', tab_sum2_red2$V6)

write.csv(tab_sum2_red3, 'F9_F10_results.csv')
