function OrganIm = OrganExtractor(Fullim,FullSeg,organInd)

    OrganIm = Fullim*0;
    OrganIm(FullSeg == organInd) = Fullim(FullSeg == organInd);

end