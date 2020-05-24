

SOS_scaled=zeros(size(SOS));

for i = 1:size(SOS,1)
    scale = ( SOS(i,4)+SOS(i,5)+SOS(i,6) )/( SOS(i,1)+SOS(i,2)+SOS(i,3) );
    SOS_scaled(i,1) = scale * SOS(i,1);
    SOS_scaled(i,2) = scale * SOS(i,2);
    SOS_scaled(i,3) = scale * SOS(i,3);
    SOS_scaled(i,4) = SOS(i,4);
    SOS_scaled(i,5) = SOS(i,5);
    SOS_scaled(i,6) = SOS(i,6);
end

q=14;
SOS_scaled = round(bitsll(SOS_scaled,q));