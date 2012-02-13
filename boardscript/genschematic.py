# ADD LED@Aura LL1 R-90 (-6.4 -4.9) 
# NET R11 (-6.4 -4.9) (-6.4 -5.0)
# NET GND (-6.4 -4.5) (-6.4 -4.4)

# ADD SENSOR@Aura SS1 (-7.0 -4.9)


LED_ORIGINX = 0.0
LED_ORIGINY = 0.0

SENSOR_ORIGINX = 15.0
SENSOR_ORIGINY = 0.0

HSPACE = 0.4
VSPACE = 0.2

HLED = 0.2
VLED = 0.5

HSENSOR = 0.1
VSENSOR = 0.6

ROW = 16
COL = 24

def print_leds():
    y = LED_ORIGINY
    for ledrow in range(ROW):
        x = LED_ORIGINX
        for ledcol in range(COL):
            print 'ADD LED@Aura LED_%d_%d R-90 (%f %f)' % (ledrow+1, ledcol+1, x, y)
            print 'NET LED_ROW_%d (%f %f) (%f %f)' % (ledrow+1, x, y+VLED, x, y+VLED+0.1)
            print 'NET LED_SENSOR_C%d (%f %f) (%f %f)' % (ledcol + 1, x, y, x, y-0.1)
            print ''
            x = x + HLED + HSPACE
        y = y - (VLED + VSPACE + 0.2)

def print_sensors():
    y = SENSOR_ORIGINY
    for sensorrow in range(ROW):
        x = SENSOR_ORIGINX
        for sensorcol in range(COL):
            print 'ADD SENSOROSRAM*@Aura SENSOR_%d_%d (%f %f)' % (sensorrow+1, sensorcol+1, x, y)
            print 'NET SENSOR_ROW_%d (%f %f) (%f %f)' % (sensorrow+1, x+0.1, y+0.3, x+0.1, y+0.4)
            print 'NET LED_SENSOR_C%d (%f %f) (%f %f)' % (sensorcol+1, x+0.1, y-0.3, x+0.1, y-0.4)
            print ''
            x = x + HSENSOR + HSPACE
        y = y - (VSENSOR + VSPACE + 0.2)

if __name__ == '__main__':
    print_leds()
    print_sensors()
