NB. JFits/run.ijs

require 'viewmat' 
require 'web/gethttp'
load '~user/projects/JFits/init.ijs'

NB. Get image ready for display by parsing, scaling and sampling
displayFits =: 4 : 0 NB. maxSize displayFits fitsdata
    'hdrLines imarray' =. splitFitsData y
    'minmax' =. 0.5 0.95
     scaled =. minmax scaleT2D"_ _1 imarray NB. up to 3 planes
    'r b' =. 0 _1 { scaled
     if. 3>#scaled do. g =. <.-:r+b else. g =. 1{scaled end.
     fimage=. b+256*g+256*r
     maxdim =. >./$fimage
     sfimage=. (maxdim % maxdim <. x) sample2D fimage
)

'rgb' viewmat 1000 displayFits fread jpath'~user/projects/JFits/fitsSamples/NGC4500.fits'
'rgb' viewmat 1000 displayFits fread jpath'~user/projects/JFits/fitsSamples/FOCx38i0101t_c0f.fits'
NB. 'rgb' viewmat 1000 displayFits gethttp 'https://fits.gsfc.nasa.gov/samples/WFPC2u5780205r_c0fx.fits'
'rgb' viewmat 1500 displayFits fread jpath'~user/projects/JFits/fitsSamples/color_hst_07469_06_wfpc2_f785lp_f555w_wf_sci.fits'
'rgb' viewmat 1500 displayFits fread jpath'~user/projects/JFits/fitsSamples/color_hst_07436_09_wfpc2_f555w_f439w_f218w_pc_sci.fits'
'rgb' viewmat 1500 displayFits fread jpath'~user/projects/JFits/fitsSamples/j8ff04011_drz.fits'

NB. displayImg =: 4 : 0 NB. maxSize displayFits image array
NB.     'minmax' =. 0.5 0.95
NB.      scaled =. minmax scaleT2D"_ _1 y NB. up to 3 planes
NB.     'r b' =. 0 _1 { scaled
NB.      if. 3>#scaled do. g =. <.-:r+b else. g =. 1{scaled end.
NB.      fimage=. b+256*g+256*r
NB.      maxdim =. >./$fimage
NB.      sfimage=. (maxdim % maxdim <. x) sample2D fimage
NB. )

NB. 'h img' =. splitFitsData fread jpath'~user/projects/JFits/fitsSamples/j8ff04011_drz.fits'
NB.
NB. 'rgb' viewmat 1000 displayImg 2  1136 1163 $ ,0 1{img

