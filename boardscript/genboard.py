# ADD LED@Aura LL1 R-90 (-6.4 -4.9) 
# NET R11 (-6.4 -4.9) (-6.4 -5.0)
# NET GND (-6.4 -4.5) (-6.4 -4.4)

# ADD SENSOR@Aura SS1 (-7.0 -4.9)

from config import *

def layout_leds():
    for ledrow in range(ROW):
        for ledcol in range(COL):
            ledname = 'LED_%d_%d' % (ledrow+1, ledcol+1)
            x = LED_ORIGINX + ledcol * HSPACE
            y = LED_ORIGINY + ledrow * VSPACE
            print 'MOVE %s (%d %d)' % (ledname, x, y)
            print "VIA 'LED_ROW_%d' auto round (%d %d)" % (ledrow+1, x-35, y)
                

def layout_sensors():
    for sensorrow in range(ROW):
        for sensorcol in range(COL):
            sensorname = 'SENSOR_%d_%d' % (sensorrow+1, sensorcol+1)
            x = SENSOR_ORIGINX + sensorcol * HSPACE
            y = SENSOR_ORIGINY + sensorrow * VSPACE
            print 'MOVE %s (%d %d)' % (sensorname, x, y)
            print "VIA 'SENSOR_ROW_%d' auto round (%d %d)" % (sensorrow+1, x-35, y)

if __name__ == '__main__':
    print 'grid mil'
    print 'grid 5'
    print 'CHANGE DRILL 16'
    layout_leds()
    layout_sensors()
