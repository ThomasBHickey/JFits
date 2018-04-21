NB. JFits/run.ijs
require 'viewmat' 
require 'web/gethttp'
load '~user/projects/JFits/init.ijs'

displayFits =: 4 : 0 NB. maxSize displayFits file path or http URL
	if. ('http://'-:7{.y) +. 'https://'-:8{.y
	do.	fdata =. gethttp y
	else. fdata =. fread y
	end.
     'minmax' =. 0.5 0.95
     'hdrLines imarray' =. splitFitsData fdata  NB. globals
      scaled =. minmax scaleT2D"_ _1 imarray NB. up to 3 planes
	'r b' =. 0 _1 { scaled
	if. 3>#scaled do. g =. <.-:r+b else. g =. 1{scaled end.
	fimage=. b+256*g+256*r
	maxdim =. >./$fimage
	sfimage=. (maxdim % maxdim <. x) sample2D fimage
)

'rgb' viewmat 1000 displayFits jpath'~user/projects/JFits/fitsSamples/NGC4500.fits'
'rgb' viewmat 1000 displayFits jpath'~user/projects/JFits/fitsSamples/FOCx38i0101t_c0f.fits'
NB. 'rgb' viewmat 1000 displayFits 'https://fits.gsfc.nasa.gov/samples/WFPC2u5780205r_c0fx.fits'