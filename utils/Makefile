CC = gcc
CFLAGS = -std=gnu99 -pipe -Wall -O2
LDFLAGS = -pipe -Wall -Wno-unused-result -L/opt/local/lib
LDLIBS = -lm

SOURCES = sum_chandata.c
OBJECTS = $(SOURCES:.c=.o)
EXECS = sum_chandata

all: $(SOURCES) $(EXECS)

sum_chandata: sum_chandata.o
	$(CC) -o $@ $(LDFLAGS) $^ $(LDLIBS)

.c.o:
	$(CC) -o $@ $(CFLAGS) -c $<

clean:
	rm *.o $(EXECS)
