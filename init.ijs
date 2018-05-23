NB. JFits/init.ijs

NB. The Header data is in 80 byte rows.  8 bytes of label, possibly followed by '='
getHdrVal =: 4 : '{.0". 9}. ({.I.(8{."1 x)-:"1 ]8{.y){x'NB. Pad label, find 1st, make rest numeric

splitFitsData =: 3 : 0 NB. y is raw fits file contents
    	data80=. (((#y)%80), 80) $ y
	endPos =. {.I. (8{."1 data80)-:"1 ]8{.'END'
	numHdrBlocks =. >:<.endPos%36        NB. File organized in 2880 byte blocks
	hdata  =. (>:endPos) {. data80
	rdata  =. (numHdrBlocks*36*80) }. y  NB. raw Image data follows hdr blocks
	fields =. ;: 'BITPIX NAXIS NAXIS1 NAXIS2 NAXIS3'
     (fields) =. hdata&getHdrVal&.> fields
	if. NAXIS=0 do.  NB. Only works if next frame is an image extension
	   xtenPos =. {.I. (8{."1 data80)-:"1 ]8{.'XTENSION'
	   endPos =. {.I. (8{."1 xtenPos}.data80)-:"1 ]8{.'END'
	   hdata =. (>:endPos){. xtenPos}.data80
	   numHdrBlocks =. >:<.(xtenPos+endPos)%36
	   rdata =. (numHdrBlocks*36*80) }. y
     	   (fields) =. hdata&getHdrVal&.> fields
	end.
	shape =. ((NAXIS3>.1),NAXIS2,NAXIS1)  NB. 3D even if only 2D data
	select. BITPIX
	  case.   8 do. adata =. shape $ endian a. i. endian rdata
	  case.  16 do. adata =. shape $ endian _1 ic endian rdata
	  case.  32 do. adata =. shape $ endian _2 ic endian rdata
	  case. _32 do. adata =. shape $ endian _1 fc endian rdata
	  case. _64 do. adata =. shape $ endian _2 fc endian rdata
	  case. do. 'Invalid BITPIX' assert 0
	end.
	hdata;adata
)

scaleT2D =: 4 : 0  NB. (minCut, maxCut) scaleT2D 2Ddata
	ry =. ,y     NB. easier raveled
	nanPos =. 128!:5 ry   
	numData =. (I. -. nanPos) { ry 
	srtData =. /:~ numData
     'minWanted maxWanted' =: (<.x*#srtData){srtData
	ry =. minWanted (I. nanPos) } ry  NB. replace NAN's
	ry =. minWanted (I. (ry<minWanted)) } ry
	ry =. maxWanted (I. (ry>maxWanted)) } ry
	ry =. ry - minWanted NB. makes minWanted at 0
	scale =. 255% maxWanted-minWanted
	|.($y) $ <. ry*scale  NB. Transposed 2D array
)

sample2D =: 4 : 0  NB. samplefreq sample2D image
	'a0 a1' =. $y
	(<.(x*i.>.a0%x)) { (<.(x*i.>.a1%x)){"1 y
)
