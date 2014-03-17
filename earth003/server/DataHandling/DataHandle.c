/* Data file(.eq file) handling software */
/*  by Kenichi Kurimoto                  */

#include <stdio.h>
#include <stdlib.h>
#define FNAME "ftptest"
#define DATASIZE 14

void ShowBit(signed char c)
{
    int i;

    for ( i = 7; i >= 0; i--) /* i ビット目を表示する */
        printf("%d", (c >> i) & 0X01);
}

int calc_accel(char c1, char c2)
{
  int result;

  /*  printf("c1 =");
  ShowBit(c1);
  printf("   c2=");
  ShowBit(c2);
  printf("   c1 shift 8 = %d", ((int)c1)<<8); */
  //  result =(int)( (((int) c1) << 8) |( (unsigned int)c2)) ;
  result =(int)( (((int) c1) << 8)  + ( (unsigned int)c2)) ;
  //   printf("   intermediate = %d", result);
  
  return(result);

}

int bcd2int(char c)
{
  int result;
  result = 0;
  //fprintf(stderr," - %d =",(int)c);
  if(((int)c & 0x80)!=0){
    result += 80;
  }
  if(((int)c & 0x40)!=0){
    result +=40;
  }
  if(((int)c & 0x20)!=0){
    result +=20;
  }
  if(((int)c & 0x10)!=0){
    result +=10;
  }
  if(((int)c & 0x8)!=0){
    result +=8;
  }
  if(((int)c & 0x4)!=0){
    result +=4;
  }
  if(((int)c & 0x2)!=0){
    result +=2;
  }
  if(((int)c & 0x1)!=0){
    result +=1;
  }
  return(result);
}



int main(void)
{
  //  FILE *fp;
  char *fname = FNAME;
  unsigned char buf[DATASIZE];
  size_t size;
  int accel_x, accel_y, accel_z;

  fprintf(stderr, "start translating\n");
  while((size = fread(buf, sizeof(unsigned char),DATASIZE,stdin))==DATASIZE){
    accel_x = calc_accel(buf[0], buf[1]);
    accel_y = calc_accel(buf[2], buf[3]);
    accel_z = calc_accel(buf[4], buf[5]);
 
    printf("x=%d, y=%d, z=%d, '%d %d/%d , %d:%d:%d %d%d    \n ", 
	   accel_x, accel_y, accel_z, bcd2int(buf[6]),bcd2int(buf[7]),bcd2int(buf[8]),
	   bcd2int(buf[9]),bcd2int(buf[10]),bcd2int(buf[11]),bcd2int(buf[12]), bcd2int(buf[13]));
  }
}
