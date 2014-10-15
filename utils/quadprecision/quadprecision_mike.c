#include <stdio.h>
#include <quadmath.h>

int main( int argc, char **argv ){

  __float128 sine36;
  __float128 sine72;
  __float128 prod;
  __float128 inv;
  __float128 sqd_inv;

  __float128 better_pi = 3.14159265358979323846264338327950288419716939937510Q;

  sine36 = sinq(36.0*M_PIq/180.0);
  sine72 = sinq(72.0*M_PIq/180.0);
  prod = sine36 * sine72;
  inv = 1.0 / ( prod );
  sqd_inv = powq( inv, 2 );

  printf("M_PIq:\t\t\t%.50Qg\n",M_PIq);
  printf("Sine(36):\t\t%.50Qg\n",sine36);
  printf("Sine(72):\t\t%.50Qg\n",sine72);
  printf("Product:\t\t%.50Qg\n",prod);
  printf("Inverse:\t\t%.50Qg\n",inv);
  printf("Squared inverse:\t%.50Qg\n",sqd_inv);



  sine36 = sinq(36.0*better_pi/180.0);
  sine72 = sinq(72.0*better_pi/180.0);
  prod = sine36 * sine72;
  inv = 1.0 / ( prod );
  sqd_inv = powq( inv, 2 );

  printf("better_pi:\t\t%.50Qg\n",better_pi);
  printf("Sine(36):\t\t%.50Qg\n",sine36);
  printf("Sine(72):\t\t%.50Qg\n",sine72);
  printf("Product:\t\t%.50Qg\n",prod);


  /* printf("Sine(36):\t%.36q\n",sine36); */
  /* printf("Sine(72):\t%.36q\n",sine72); */
  /* printf("Squared result:\t%.36q\n",sqd_res); */

  exit(0);
}
