function w=calculate_cortical_coords_from_RFs(RFs)
%Takes RF coordinates as input, and generates coordinates that correspond
%to location on cortex, using formulas described in Poort & Roelfsema 2009.
r=sqrt(RFs(1)^2+RFs(2)^2);
polarAngle=atan(RFs(2)/RFs(1))
z=r*exp(complex(0,polarAngle))
k=15;
a=0.7;
w=k*log(z+a)-k*log(a)

