// メモリ関係

#include "bootpack.h"

#define EFLAGS_AC_BIT		0x00040000
#define CR0_CACHE_DISABLE	0x60000000

unsigned int memtest(unsigned int start, unsigned int end){
  char flg486 = 0;
  unsigned int eflg, cr0, i;

  //386か486以降なのか確認
  eflg = io_load_eflags();
  eflg |= EFLAGS_AC_BIT; //AC - bit = 1
  io_store_eflags(eflg);
  eflg = io_load_eflags();
  if ((eflg & EFLAGS_AC_BIT) != 0) flg486 = 1; //386ではAC=1にしても自動で0に戻ってします。
  eflg &= ~EFLAGS_AC_BIT; //AC - bit = 0
  io_store_eflags(eflg);

  if (flg486 != 0){
    cr0 = load_cr0();
    cr0 |= CR0_CACHE_DISABLE; //キャッシュ禁止
    store_cr0(cr0);
  }

  i = memtest_sub(start,end);

  if (flg486 != 0){
    cr0 = load_cr0();
    cr0 &= ~CR0_CACHE_DISABLE; //キャッシュ許可
    store_cr0(cr0);
  }

  return i;
}

void memman_init(struct MEMMAN *man){
  man->frees = 0;     //空き情報の個数
  man->maxfrees = 0;  //状況観察用:freesの最大値
  man->lostsize = 0;  //開放に失敗した合計サイズ
  man->losts = 0;     //開放に失敗した回数
  return;
}

unsigned int memman_total(struct MEMMAN *man){ //空きサイズの合計を報告
  unsigned int i, t = 0;
  for (i = 0; i < man->frees; i++){
    t += man->free[i].size;
  }
  return t;
}

unsigned int memman_alloc(struct MEMMAN *man, unsigned int size){ //確保
  unsigned int i,a;
  for (i = 0; i < man->frees; i++){
    if (man->free[i].size >= size){ //充分の広さの空きを発見
      a = man->free[i].addr;
      man->free[i].addr += size;
      man->free[i].size -= size;
      if (man->free[i].size == 0){
        man->frees--;
        for (; i < man->frees; i++){
          man->free[i] = man->free[i + 1]; //構造体の代入
        }
      }
      return a;
    }
  }
  return 0;
}

int memman_free(struct MEMMAN *man, unsigned int addr, unsigned int size){ //解放
  int i,j;
  for (i = 0; i < man->frees; i++){
    if (man->free[i].addr > addr) break;
  }
  if (i > 0){
    if (man->free[i - 1].addr + man->free[i - 1].size == addr){
      man->free[i - 1].size += size;
      if (i < man->frees){
        if (addr + size == man->free[i].addr){
          man->free[i - 1].size += man->free[i].size;
          man->frees--;
          for (; i < man->frees; i++){
            man->free[i] = man->free[i + 1];
          }
        }
      }
      return 0;
    }
  }
  if (i < man->frees){
    if (addr + size == man->free[i].addr){
      man->free[i].addr = addr;
      man->free[i].size += size;
      return 0;
    }
  }
  if (man->frees < MEMMAN_FREES){
    for (j = man->frees; j > i; j--){
      man->free[j] = man->free[j - 1];
    }
    man->frees++;
    if (man->maxfrees < man->frees) man->maxfrees = man->frees;
    man->free[i].addr = addr;
    man->free[i].size = size;
    return 0;
  }
  man->losts++;
  man->lostsize += size;
  return -1;
}

unsigned int memman_alloc_4k(struct MEMMAN *man, unsigned int size){
    unsigned int a;
    size = (size + 0xfff) & 0xfffff000;
    a = memman_alloc(man, size);
    return a;
}

int memman_free_4k(struct MEMMAN *man, unsigned int addr, unsigned int size){
    int i;
    size = (size + 0xfff) & 0xfffff000;
    i = memman_free(man, addr, size);
    return i;
}