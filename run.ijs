NB. JFits/run.ijs

require 'viewmat web/gethttp'
load '~user/projects/JFits/init.ijs'

NB. Get image ready for display by parsing, scaling and sampling
displayFits =: 4 : 0 NB. maxSize displayFits fitsdata 
    imarray =. splitFitsData y
     scaled =. 0.5 0.95 scaleT2D"_ _1 imarray NB. up to 3 planes
    'r b' =. 0 _1 { scaled
     if. 3>#scaled do. g =. <.-:r+b else. g =. 1{scaled end.
     fimage=. b+256*g+256*r
     maxdim =. >./$fimage
     sfimage=. (maxdim % maxdim <. x) sample2D fimage
)

'rgb' viewmat 1000 displayFits fread jpath'~user/projects/JFits/fitsSamples/NGC4500.fits'
'rgb' viewmat 1000 displayFits fread jpath'~user/projects/JFits/fitsSamples/FOCx38i0101t_c0f.fits'
'rgb' viewmat 1500 displayFits fread jpath'~user/projects/JFits/fitsSamples/color_hst_07436_09_wfpc2_f555w_f439w_f218w_pc_sci.fits'
'rgb' viewmat 1500 displayFits fread jpath'~user/projects/JFits/fitsSamples/j8ff04011_drz.fits'
