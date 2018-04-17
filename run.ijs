NB. JFits/run.ijs

load '~user\projects\JFits\init.ijs'

displayFits =: 4 : 0 NB. maxSize displayFits file path or http URL
	if. (*/'http://'=7{.y) +. */'https://'=8{.y
	do.	fdata =: gethttp y
	else. fdata =: fread y
	end.
     'minmax' =. 0.5 0.95
     'hdrLines imarray' =: splitFitsData fdata  NB. globals
	NB. Scale each plane separately
    	r =.  minmax scaleT2D 0{imarray
	select. 3<.{.$imarray   NB. use up to 3 planes
	  case. 3 do.
		g =. minmax scaleT2D 1{imarray
		b =. minmax scaleT2D 2{imarray
	  case. 2 do.
		b =. minmax scaleT2D 1{imarray
		g =. -: r+b   NB. average of red and blue
	  case. 1 do.
		'g b'=. r;r
	end.
	fimage=: (r*2^16) + (g*2^8) + b  NB. global
	maxdim =. >./$fimage
	sfimage=: (maxdim % maxdim <. x) sample2D fimage
	view_image sfimage
)
1000 displayFits 'd:\fits\NGC4500.fits'
NB. 2000 displayFits 'd:\fits\orionhst05085.fits'
NB. 2000 displayFits 'https://fits.gsfc.nasa.gov/samples/WFPC2u5780205r_c0fx.fits'
NB.1000 displayFits 'https://fits.gsfc.nasa.gov/samples/WFPC2ASSNu5780205bx.fits'
NB. 2000 displayFits 'd:\fits\orimos-9.fits'
NB. 1000 displayFits 'd:\fits\h_jupiter_255_070217b_drz_sci.fits'
NB. 2000 displayFits 'd:\fits\h_m82_b_s05_drz_sci.fits'

