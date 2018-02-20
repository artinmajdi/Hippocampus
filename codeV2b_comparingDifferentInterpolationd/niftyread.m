% Read nifty files 
% Eventually write out dicom
% Manoj Saranathan 6/12/16
% For now, read parts of nifty header we need like datatype and boffset

Directory = '../data/KevinMRIImages/';
    nameT1  = ['posterior_left_',subsection,'_T1_v10.nii'];
    nameT2  = ['posterior_left_',subsection,'_T1_T2_v10.nii'];
    nameWMN = ['posterior_left_',subsection,'_T1_wmn_v10.nii'];
        
fid = fopen([Directory,nameT1],'rb')
fseek(fid,0,'eof');
info.Filesize = ftell(fid);
fseek(fid,0,'bof');
info.SizeofHdr=fread(fid,1,'int');
info.DataType=fread(fid, 10, 'uint8=>char')';
info.DbName=fread(fid, 18, 'uint8=>char')';
info.Extents=fread(fid,1,'int');
info.SessionError=fread(fid,1,'uint16');
info.Regular=fread(fid, 1, 'uint8=>char')';

info.DimInfo=fread(fid, 1, 'uint8=>char')';
swaptemp=fread(fid, 1, 'uint16')';
info.Dimensions=fread(fid,7,'uint16')';
%infinfo.headerbswap=bswap;
info.IntentP1=fread(fid,1,'float');
info.IntentP2=fread(fid,1,'float');
info.IntentP3=fread(fid,1,'float');
info.IntentCode=fread(fid,1,'uint16');
info.DataType=fread(fid,1,'uint16');
info.Bitpix=fread(fid,1,'uint16');
info.SliceStart=fread(fid,1,'uint16');
temp=fread(fid,1,'float');
info.PixelDimensions=fread(fid,7,'float');

info.VoxOffset=fread(fid,1,'float');    


ddims = info.Dimensions;
boffset = info.VoxOffset
datatype = info.DataType

switch datatype
    case 2
        dtype = 'uint8';
    case 4
        dtype = 'int16';
    case 8
        dtype = 'int32';
    case 16
        dtype = 'float';
    case 64
        dtype = 'double';
    case 132
        dtype = 'int16';
    case 768
        dtype = 'uint32';
    otherwise
        error('Unsupported datatype');
end

% Rewind to start of data and read
fseek(fid, boffset,'bof');

for jj = 1:ddims(3)

    imdata(:,:,jj) = fread(fid,[ddims(1) ddims(2)],dtype);
end

% Display middle most slice 
figure(2); imagesc(imdata(:,:,ceil(ddims(3)/2)+1));

