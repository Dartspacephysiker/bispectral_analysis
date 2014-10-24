/* Oct 11 2014 (Saturday afternoon)   
 * This utility takes binary data recorded by our
 * Measurement Computing PCI-DAS4020/12 (along with Comedi drivers)
 * and sums the waveform recorded on each channel to produce a single
 * waveform that can be used as input for a bispectral analysis program
 *
 * 
 * 
 * 
 */

#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include <math.h>
#include <unistd.h>
#include <sys/types.h>
#include <errno.h>
#include <inttypes.h>

#define DEF_INFILE "std input stream"
#define DEF_OUTFILE "sum_chandata.data"
#define DEF_OUTDIR "./"
#define DEF_NCHAN 4
#define DEF_SAMPSIZE 2

struct parsed_options {
  
  char fname[128];
  char outfname[128];
  char outdir[128];
  
  int n_chan;
  int sampsize;
  float scl_factor;
  
  int verbose;
  int diag;
  int diag_hex;
  int split_files;
};

void init_parsed_options(struct parsed_options *);
int parse_options(struct parsed_options *, int, char **);
void print_options(struct parsed_options *);
