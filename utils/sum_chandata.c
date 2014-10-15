/* Oct 11 2014 (Saturday afternoon)   				       
 * This utility takes binary data recorded by our		       
 * Measurement Computing PCI-DAS4020/12 (along with Comedi drivers)    
 * and sums the waveform recorded on each channel to produce a single  
 * waveform that can be used as input for a bispectral analysis program
 *
 * Author: Hammertime
 */

#define _GNU_SOURCE

#include <regex.h>
#include <stdio.h>
#include "sum_chandata.h"



int main(int argc, char **argv){

  //data we're taking in
  struct parsed_options o;

  uint16_t *dater;
  uint16_t sum;
  int biz = 0;
  int reading = 1;
  int i = 0;
  int j = 0;

  FILE *infile, *ofile;
  
  char **chan_fname;
  FILE **chanf;

  //yank whatever we got from cmd line
  init_parsed_options(&o);
  parse_options(&o, argc, argv);
  print_options(&o);

  dater = malloc(o.n_chan * o.sampsize);

  //open files
  if (strcmp(o.fname,"std input stream") != 0 ){
    printf("Opening input file %s...\n",o.fname);
    infile = fopen(o.fname,"rb");
    if (infile == NULL) {
      fprintf(stderr,"Failed to open %s! Laterz...\n",o.fname);
      return(EXIT_FAILURE);
    }
  } else{
    printf("Sorry, input from stdin isn't supported yet.\n");
    return(EXIT_FAILURE);
  }

  if(strcmp(o.outdir,"./") != 0 ){
    //    printf("Output directory:\t%s\n",o.outdir);
    //snprintf(o.outfname,128,"%s/%s",o.outdir,o.outfname);
  }

  if( o.split_files ){
    chan_fname = malloc(sizeof(char *) * o.n_chan);
    chanf = malloc(sizeof(FILE *)* o.n_chan);
    
    for( int i = 0; i < o.n_chan; i++){
      chan_fname[i] = malloc(128);
      //snprintf(chan_fname[i],128,"%s/%s.ch%02i",o.outdir,o.fname,i);
      snprintf(chan_fname[i],128,"%s.ch%02i",o.fname,i);
      
      printf("Opening %s...\n",chan_fname[i]);
      chanf[i] = fopen(chan_fname[i],"wb");
      if( chanf[i] == NULL ) {
	fprintf(stderr,"Failed to open %s! Laterz...\n",chan_fname[i]);
	return(EXIT_FAILURE);
      }
    }
  }

  if( !o.diag ){
    printf("Opening output file %s...\n",o.outfname);
    ofile = fopen(o.outfname,"wb");
    if (ofile == NULL) {
      fprintf(stderr,"Failed to open %s! Laterz...\n",o.outfname);
      return(EXIT_FAILURE);
    }
  }

  //now that files are open, lets read in so many chunks at a time
  while(reading){
    biz = fread(dater,o.sampsize,o.n_chan,infile);


    if( biz != o.n_chan ){
      if (biz != 0 ) printf("Only got %i samples on last read! Expecting %i (there are %i channels, after all...)\n",biz,o.n_chan,o.n_chan);
      printf("Read %i samples each from %i channels\n",i,o.n_chan);
      reading = 0;
    }
    
    for( j = 0; j < o.n_chan; j++ ){
      sum += dater[j];

      if( o.diag ){
	if( i == 10 ){
	  printf("Diag finished. Pleased with the results?\n");
	  return(EXIT_SUCCESS);
	}
	if( o.diag_hex ){
	  printf("For i = %i\t:\tdater[%i] = %04X\tsum[%i] = %04X\n",i,j,dater[j],j,sum);
	} else {
	  printf("For i = %i\t:\tdater[%i] = %04u\tsum[%i] = %04u\n",i,j,dater[j],j,sum);
	}
      }
      
      if( o.split_files ){ fwrite(&dater[j],o.sampsize,1,chanf[j]); }
    }
    //    sum *= o.scl_factor;

    //Since our digitizer digitizes with 12-bit resolution (4096 discrete levels) and calls 0V 2048, subtract (n_chan - 1)*2048 from sum
    sum -= 2048 * (o.n_chan - 1);

    if( o.diag ) {
      printf("\n");
    } else {
      //now write it to the outfile
      fwrite(&sum,sizeof(sum),1,ofile);
    }

    i++;
    sum = 0;
  }

  fclose(infile);
  
  if( !o.diag && ofile != NULL ) fclose(ofile);

  if( o.split_files ){
    for( int i = 0; i < o.n_chan; i++){
      if( chanf[i] != NULL ) {
	fclose(chanf[i]);
      }
    }
  }
  
  return(0);

}

void init_parsed_options(struct parsed_options *options){

  snprintf(options->fname,128,"%s",DEF_INFILE);
  snprintf(options->outfname,128,"%s",DEF_OUTFILE);
  snprintf(options->outdir,128,"%s",DEF_OUTDIR);
  options->n_chan = DEF_NCHAN;
  options->scl_factor = 1.0/DEF_NCHAN;
  options->sampsize = DEF_SAMPSIZE;
  
  options->verbose = 0;
  options->diag = 0;
  options->diag_hex = 0;
}

int parse_options(struct parsed_options *options, int argc, char *argv[]){

  int c;

  while (-1 != (c = getopt(argc, argv, "f:o:O:n:S:s:Pvdxh"))) {
    switch (c) {
    case 'f':
      snprintf(options->fname,128,"%s",optarg);
      break;
    case 'o':
      snprintf(options->outfname,128,"%s",optarg);
      break;
    case 'O':
      snprintf(options->outdir,128,"%s",optarg);
      break;
    case 'n':
      options->n_chan = strtoul(optarg, NULL, 0);
      break;
    case 'S':
      options->sampsize = strtoul(optarg, NULL, 0);
    case 's':
      options->scl_factor = strtod(optarg, NULL);
      break;
    case 'P':
      options->split_files = 1;
      break;
    case 'v':
      options->verbose = 1;
      break;
    case 'd':
      options->diag = 1;
      printf("Running in diagnostic mode\n");
      break;
    case 'x':
      options->diag_hex = 1;
      break;
    case 'h':
    default:
      printf("sum_chandata options:\n");
      printf("\t-f <file>\tInput Filename\t[%s]\n",DEF_INFILE);
      printf("\t-o <file>\tOutput File\t[%s]\n", DEF_OUTFILE);
      printf("\t-O <dir>\tOutput Dir\t[%s]\n", DEF_OUTDIR);
      printf("\t-n <#>\t\t# Channels [%i]\n",DEF_NCHAN);
      printf("\t-S <#>\t\tSample size in bytes [%i]\n",DEF_SAMPSIZE);
      printf("\t-s <#>\t\tScale factor [1/N_CHAN]\n");      
      printf("\n");
      printf("\t-P\t\tSplit files into separate channel files, with suffix \"ch0N\"\n");
      printf("\n");
      printf("\t-v\t\tBe verbose\n");
      printf("\t-d\t\tDiagnostic mode\n");
      printf("\t-x\t\tOutput diagnostic data in hex format\n");
      printf("\n");
      exit(1);
    }
  }

  return argc;

}

void print_options(struct parsed_options *options){
  printf("Selected options:\n");
  printf("*****************\n");
  printf("Number of channels:\t%i\n",options->n_chan);
  printf("Sample size in bytes:\t%i\n",options->sampsize);
  printf("Scale factor:\t\t%f\n",options->scl_factor);
  if( options->split_files ){
    printf("SPLIT FILE MODE\n");
  }
}
