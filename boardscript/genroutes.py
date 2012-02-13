from config import * 

def layout_vias():
    for col in range(COL):
            x = SENSOR_ORIGINX + 25 + col * 100
            y = SENSOR_ORIGINY + 25 + col * 50
            print "VIA 'LED_SENSOR_C%d' auto round (%d %d)" % (col+1, x, y)

def layout_temp_vias():
    for col in range(12,COL):
            x = SENSOR_ORIGINX + 25 + col * 100
            y = SENSOR_ORIGINY + 25 + col * 50 + 200
            print "VIA 'LED_SENSOR_C%d' auto round (%d %d)" % (col+1, x, y)


def route_rows():
    print 'CHANGE WIDTH 16'
    print 'CHANGE LAYER 16'
    for row in range(ROW):
            x = SENSOR_ORIGINX
            y = SENSOR_ORIGINY + row * VSPACE
            print "ROUTE (%d %d) (%d %d)" % (x-35, y, x+HSPACE*(COL-1)-35, y)
            print "ROUTE (%d %d) (%d %d)" % (x-35, y+50, x+HSPACE*(COL-1)-35, y+50)

def route_columnns():
    print 'CHANGE WIDTH 20'
    print 'CHANGE LAYER 1'
    for col in range(COL):
            x = SENSOR_ORIGINX + col * HSPACE
            y = SENSOR_ORIGINY
            print "ROUTE (%d %d) (%d %d)" % (x+20, y+10, x+22, y+VSPACE*(ROW-1)+50)

    

if __name__ == '__main__':
    print 'grid mil'
    print 'grid 5'
    print 'CHANGE DRILL 16'
#     route_columnns()
#     route_rows()
#     layout_vias()
    layout_temp_vias()
