function visualize


nrow = 8;
ncolumn = 22;
calibrationFrame = 30;
offsetImage = zeros(ncolumn, nrow);
running = true;


    function synchronizeSerial
        disp('Synchronizing...')
        while (ser.BytesAvailable <= 0)
            pollSerial();
            pause(0.001);
        end
    end

    function pollSerial
        fwrite(ser, [255], 'uint8');
    end

    function img = readImage
        pollSerial();
        img = fread(ser, [ncolumn, nrow], 'uint16');
    end

    function calibrate
        disp('Calibrating...')
        offsetImage = zeros(ncolumn, nrow);
        for ci=1:calibrationFrame
            offsetImage = offsetImage + readImage();
        end
        offsetImage = offsetImage ./ calibrationFrame;
    end

    function pimg = processImage(img)
        pimg = min(2047, max(0, img - offsetImage));
        pimg = uint8(pimg .^ 0.5 .* 5);
        pimg = imrotate(pimg, 90);
    end

    function onKeyPress(source, eventData)
        if eventData.Character == 'q'
            running = false;
        end
    end

ser = openSerial();
synchronizeSerial();
calibrate();

%failindice = [];
%sumimage = zeros(ncolumn, nrow);

ih = figure;
set(ih, 'WindowKeyPressFcn', @onKeyPress)
frameCnt = 0;

disp('Running...')
figure(ih);
tic
try
    while true
        if ~running
            break;
        end
        rawimg = readImage();
        image = processImage(rawimg);
        imshow(image);
        %figure(ih), surf(1:nrow, 1:ncolumn, image);
        drawnow
        frameCnt = frameCnt + 1;
        %sumimage = sumimage + image;
        %failindice = intersect(failindice, find(image<500));
    end
catch err
    closeSerial(ser);
    rethrow(err);
end

disp(sprintf('Framerate: %.1f', frameCnt / toc()));

%sumimage = sumimage ./ runFrame;

%ind2sub(size(image), failindice)
closeSerial(ser);

end

function s = openSerial
info = instrhwinfo('serial');
available_ports = info.AvailableSerialPorts
%s = serial(available_ports(1));
s = serial('/dev/tty.usbserial-A900UD1B');
set(s, 'BaudRate',230400)
set(s, 'InputBufferSize', 50000);
fopen(s);
end

function closeSerial(s) 
fclose(s);
delete(s);
end

