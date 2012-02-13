info = instrhwinfo('serial');
available_ports = info.AvailableSerialPorts

row = 8;
column = 22;

%s = serial(available_ports(1));
s = serial('/dev/tty.usbserial-A900UD1B');
set(s, 'BaudRate',230400)
fopen(s);

failindice = [];

image = uint16(ones(row, column));
sumimage = ones(row, column);
for i = 1:600
   while (fread(s, 1, 'uchar') ~= 255)
     ;
   end
%    for j = 1:8
%       image(j, :) = uint16(fread(s, [1,14], 'uint16'));
%       imshow(image);
%       drawnow;
%    end
   image = fread(s, [row, column], 'uint16'); 
   sumimage = sumimage + image;
   failindice = intersect(failindice, find(image<500));
   %surf(1:14, 1:8, image);
   imshow(uint16(image));
   drawnow
end

sumimage = sumimage ./ 600;
%hist(sumimage(:), 0:10:10000);


ind2sub(size(image), failindice)

fclose(s);
delete(s);