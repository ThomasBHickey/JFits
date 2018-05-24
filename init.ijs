NB. JFits/init.ijs

NB. The Header data is in 80 byte rows.  8 bytes of label, possibly followed by '='
getHdrVal =: 4 : '{.0". 9}. ({.I.(8{."1 x)-:"1 ]8{.y){x'NB. Pad label, find 1st, make rest numeric

convData =: 4 : 0  NB. BITPIX convData rdata
	select. x
	  case.   8 do. cdata =. endian a. i. endian y
	  case.  16 do. cdata =. endian _1 ic endian y
	  case.  32 do. cdata =. endian _2 ic endian y
	  case. _32 do. cdata =. endian _1 fc endian y
	  case. _64 do. cdata =. endian _2 fc endian y
	  case. do. 'Unsupported BITPIX' assert 0
	end.
  cdata
)

findImg =: 3 : 0 NB. return 3D image
	endPos =. {.I. (8{."1 y)-:"1 ]8{.'END'
	numHdrBlocks =. >:<.endPos%36        NB. File organized in 2880 byte blocks
	hdata  =. (>:endPos) {. y
	fields =. ;: 'BITPIX NAXIS NAXIS1 NAXIS2 NAXIS3'
     (fields) =. hdata&getHdrVal&.> fields
	smoutput 'NAXIS:';NAXIS;'NAXIS 123:';NAXIS1;NAXIS2;NAXIS3
	if. NAXIS<2 do. return. end.
	shape =. ((NAXIS3>.1),NAXIS2,NAXIS1)  NB. 3D even if only 2D data
	rdata =. ,(numHdrBlocks*36)}. y
	adata =. shape $ BITPIX convData rdata
)

splitFitsData2 =: 3 :0 NB. pass in raw FITS file contents
  data80=. (((#y)%80), 80) $ y
  cumImg =. $0
  for_frstart. 0, I. (8{."1 data80)-:"1 ]8{.'XTENSION' do.
	fi =. findImg frstart }. data80
	if. (0<+/$fi) do.  NB. got something back
	  if. 0=$cumImg do.
		cumImg =. fi
	  elseif. ($0{fi) -: $0{cumImg do.
	   cumImg =. cumImg, fi
	  end.
	end.
  end.
  cumImg
)

NB. splitFitsData =: 3 : 0 NB. y is raw fits file contents
NB.     	data80=. (((#y)%80), 80) $ y
NB. 	endPos =. {.I. (8{."1 data80)-:"1 ]8{.'END'
NB. 	numHdrBlocks =. >:<.endPos%36        NB. File organized in 2880 byte blocks
NB. 	hdata  =. (>:endPos) {. data80
NB. 	rdata  =. (numHdrBlocks*36*80) }. y  NB. raw Image data follows hdr blocks
NB. 	fields =. ;: 'BITPIX NAXIS NAXIS1 NAXIS2 NAXIS3'
NB.      (fields) =. hdata&getHdrVal&.> fields
NB. 	if. NAXIS=0 do.  NB. Try for image extensions
NB. 	   xps =. I. (8{."1 data80)-:"1 ]8{.'XTENSION'
NB. 	   lastShape =. _1 _1
NB. 	   cdata =. $0
NB. 	   planes =. i.0
NB. 	   for_xp. xps do.
NB. 	   	endPos =. {.I. (8{."1 xp}.data80)-:"1 ]8{.'END'
NB. 	   	hdata =. (>:endPos){. xp}.data80
NB. 	      NB. smoutput 'xp hdata';xp;60{.hdata
NB. 	   	numHdrBlocks =. >:<.(xp+endPos)%36
NB. 	   	rdata =. (numHdrBlocks*36*80) }. y
NB.      	   	(fields) =. hdata&getHdrVal&.> fields
NB. 		assert 'Unable to handle extension: -.NAXIS=2' assert NAXIS=2
NB. 		shape =. NAXIS2,NAXIS1
NB. 		if. (shape -: lastShape) +. lastShape-:_1 _1 do.
NB. 			lastShape =. shape
NB. 			adata =. shape $ BITPIX convData rdata
NB. 			cdata =. cdata,<adata
NB. 		end.
NB. 	   end.
NB. 	hdata;<>cdata
NB. 	return.
NB. 	end.
NB. 	shape =. ((NAXIS3>.1),NAXIS2,NAXIS1)  NB. 3D even if only 2D data
NB. 	adata =. shape $ BITPIX convData rdata
NB. 	hdata;<adata
NB. )

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
