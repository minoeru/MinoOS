extern void io_hlt(void);

void HariMain(void)
{
  
  int i;
  char *p;


  for (i = 0xa0000; i <= 0xaffff; i++){
    p = i; //p = (char *)i;とすれば警告が消える
    *p = i & 0x0f;
  }

  for(;;){
    io_hlt();
  }

}