info = instrhwinfo('serial');
available_ports = info.AvailableSerialPorts

row = 8;
column = 22;

%s = serial(available_ports(1));
s = serial('/dev/tty.usbserial-A900UD1B');
set(s, 'BaudRate',230400)
set(s, 'InputBufferSize', 50000);
fopen(s);

failindice = [];

image = uint16(zeros(column, row));
sumimage = zeros(column, row);

while (s.BytesAvailable <= 0) 
    fwrite(s, [255], 'uint8');
    pause(0.01);
end

calibrationFrame = 10;
offsetImage = zeros(column, row);
for i=1:calibrationFrame
   fwrite(s, [255], 'uint8');
   offsetImage = offsetImage + fread(s, [column, row], 'uint16'); 
end
offsetImage = offsetImage ./ calibrationFrame;

for i = 1:600
   fwrite(s, [255], 'uint8');
   rawimage = fread(s, [column, row], 'uint16'); 
   image = min(2047, max(0, rawimage - offsetImage));
   %image = image .^ 0.333 .* 20;
   image = image .^ 0.5 .* 5;
   %sumimage = sumimage + image;
   %failindice = intersect(failindice, find(image<500));
   %surf(1:14, 1:8, image);
   imshow(uint8(image));
   drawnow
end

%sumimage = sumimage ./ 600;
%hist(sumimage(:), 0:10:10000);


%ind2sub(size(image), failindice)

fclose(s);
delete(s);