CC = gcc
CFLAGS = -std=gnu99 -pipe -Wall -O2
LDFLAGS = -pipe -Wall -Wno-unused-result -L/opt/local/lib
LDLIBS = -lm -lquadmath

SOURCES = quadprecision_mike.c
OBJECTS = $(SOURCES:.c=.o)
EXECS = quadprecision_mike

all: $(SOURCES) $(EXECS)

sum_chandata: quadprecision_mike.o
	$(CC) -o $@ $(LDFLAGS) $^ $(LDLIBS)

.c.o:
	$(CC) -o $@ $(CFLAGS) -c $<

clean:
	rm *.o $(EXECS)
