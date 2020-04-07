#include "bootpack.h"

int strcmp(char *p1, char *p2);
int strncmp(char *p1, char *p2, int n);

void console_task(struct SHEET *sheet, unsigned int memtotal){
  struct TIMER *timer;
  struct TASK *task = task_now();
  int i, fifobuf[128], cursor_x = 16, cursor_y = 28, cursor_c = -1;
  char s[30], cmdline[30], *p;
  struct MEMMAN *memman = (struct MEMMAN *) MEMMAN_ADDR;
  int x,y;
  struct FILEINFO *finfo = (struct FILEINFO *) (ADR_DISKIMG + 0x002600);
  int *fat = (int *) memman_alloc_4k(memman, 4 * 2880);
  struct SEGMENT_DESCRIPTOR *gdt = (struct SEGMENT_DESCRIPTOR *) ADR_GDT;

  fifo32_init(&task->fifo, 128, fifobuf, task);
  timer = timer_alloc();
  timer_init(timer, &task->fifo, 1);
  timer_settime(timer, 50);
  file_readfat(fat, (unsigned char *) (ADR_DISKIMG + 0x000200));

  putfonts8_asc_sht(sheet, 8, 28, COL8_FFFFFF, COL8_000000, ">", 1);

  for (;;){
    io_cli();
    if (fifo32_status(&task->fifo) == 0){
      task_sleep(task);
      io_sti();//io_stiだと重くなる->stihlt->sleepを使ってからはstiで良くなった
    }
    else {
      i = fifo32_get(&task->fifo);
      io_sti();
      if (i <= 1){ //カーソル用タイマ
        if (i != 0){
          timer_init(timer, &task->fifo, 0);
          if (cursor_c >= 0) cursor_c = COL8_FFFFFF;
        }
        else{
          timer_init(timer, &task->fifo, 1);
          if (cursor_c >= 0) cursor_c = COL8_000000;
        }
        timer_settime(timer, 50);
      }
      if (i == 2) cursor_c = COL8_FFFFFF; //カーソルon
      if (i == 3) { //カーソルoff
        boxfill8(sheet->buf, sheet->bxsize, COL8_000000, cursor_x, cursor_y, cursor_x + 7, cursor_y + 15);
				cursor_c = -1;
      }
      if (256 <= i && i <= 511){
        if (i == 8 + 256){
          if (cursor_x > 16){
            putfonts8_asc_sht(sheet, cursor_x, cursor_y, COL8_FFFFFF, COL8_000000, " ", 1);
						cursor_x -= 8;
          }
        }
        else if (i == 10 + 256){ 
          //Enter
          putfonts8_asc_sht(sheet, cursor_x, cursor_y, COL8_FFFFFF, COL8_000000, " ", 1);
          cmdline[cursor_x / 8 - 2] = 0;
          cursor_y = cons_newline(cursor_y, sheet);
          //コマンド実行
          if (strcmp(cmdline, "mem") == 0){
            sprintf(s, "total   %dMB", memtotal / (1024 * 1024));
						putfonts8_asc_sht(sheet, 8, cursor_y, COL8_FFFFFF, COL8_000000, s, 30);
						cursor_y = cons_newline(cursor_y, sheet);
						sprintf(s, "free %dKB", memman_total(memman) / 1024);
						putfonts8_asc_sht(sheet, 8, cursor_y, COL8_FFFFFF, COL8_000000, s, 30);
						cursor_y = cons_newline(cursor_y, sheet);
						cursor_y = cons_newline(cursor_y, sheet);
          }
          else if (strcmp(cmdline, "clear") == 0){
            for (y = 28; y < 28 + 128; y++){
              for (x = 8; x < 8 + 240; x++){
                sheet->buf[x + y * sheet->bxsize] = COL8_000000;
              }
            }
            sheet_refresh(sheet, 8, 28, 8 + 240, 28 + 128);
						cursor_y = 28;
          }
          else if (strcmp(cmdline, "ls") == 0) {
						for (x = 0; x < 224; x++) {
							if (finfo[x].name[0] == 0x00) break;
							if (finfo[x].name[0] != 0xe5) {
								if ((finfo[x].type & 0x18) == 0) {
									sprintf(s, "filename.ext   %d", finfo[x].size);
									for (y = 0; y < 8; y++) {
										s[y] = finfo[x].name[y];
									}
									s[9]  = finfo[x].ext[0];
									s[10] = finfo[x].ext[1];
									s[11] = finfo[x].ext[2];
									putfonts8_asc_sht(sheet, 8, cursor_y, COL8_FFFFFF, COL8_000000, s, 30);
									cursor_y = cons_newline(cursor_y, sheet);
								}
							}
						}
						cursor_y = cons_newline(cursor_y, sheet);
					}
          else if (strncmp(cmdline,"cat ", 4) == 0){
            for (y = 0; y < 11; y++){
              s[y] = ' ';
            }
            y = 0;
            for (x = 4; y < 11 && cmdline[x] != 0; x++){
              if (cmdline[x] == '.' && y <= 8) y = 8;
              else{
                s[y] = cmdline[x];
                if ('a' <= s[y] && s[y] <= 'z') s[y] -= 0x20;
                y++;
              }
            }
            //ファイル探索
            for (x = 0; x < 224; ){
              if (finfo[x].name[0] == 0x00) break;
              if ((finfo[x].type & 0x18) == 0){
                for (y = 0; y < 11; y++){
                  if (finfo[x].name[y] != s[y]) goto type_next_file;
                }
                break; //発見
              }
            type_next_file:
              x++;
            }
            if (x < 224 && finfo[x].name[0] != 0x00){ //ファイル発見
              p = (char *) memman_alloc_4k(memman, finfo[x].size);
							file_loadfile(finfo[x].clustno, finfo[x].size, p, fat, (char *) (ADR_DISKIMG + 0x003e00));
              cursor_x = 8;
              for (y = 0; y < finfo[x].size; y++){
                s[0] = p[y];
                s[1] = 0;
                if (s[0] == 0x09){ //Tab
                  for (;;){
                    putfonts8_asc_sht(sheet, cursor_x, cursor_y, COL8_FFFFFF, COL8_000000, " ", 1);
										cursor_x += 8;
										if (cursor_x == 8 + 240){
											cursor_x = 8;
											cursor_y = cons_newline(cursor_y, sheet);
										}
										if (((cursor_x - 8) & 0x1f) == 0) break;	//32で割り切れたらbreak
                  }
                }
                else if(s[0] == 0x0a){ //改行
                  cursor_x = 8;
                  cursor_y == cons_newline(cursor_y, sheet);
                }
                else if(s[0] == 0x0d){ //復帰
                  //何もしない
                }
                else{ //通常文字
                  putfonts8_asc_sht(sheet, cursor_x, cursor_y, COL8_FFFFFF, COL8_000000, s, 1);
                  cursor_x += 8;
                  if (cursor_x == 8 + 240) { //改行
                    cursor_x = 8;
                    cursor_y = cons_newline(cursor_y, sheet);
                  }
                }
              }
              memman_free_4k(memman, (int) p, finfo[x].size);
            }
            else{ //ファイル未発見
              putfonts8_asc_sht(sheet, 8, cursor_y, COL8_FFFFFF, COL8_000000, "No such file or directory", 25);
							cursor_y = cons_newline(cursor_y, sheet);
            }
            cursor_y = cons_newline(cursor_y, sheet);
          }
          else if (strcmp(cmdline,"hlt") == 0){
            for (y = 0; y < 11; y++){
              s[y] = ' ';
            }
            s[0] = 'H';
						s[1] = 'L';
						s[2] = 'T';
						s[8] = 'H';
						s[9] = 'R';
						s[10] = 'B';
            for (x = 0; x < 224; ){
              if (finfo[x].name == 0x00) break;
              if ((finfo[x].type & 0x18) == 0){
                for (y = 0; y < 11; y++){
                  if (finfo[x].name[y] != s[y]) goto hlt_next_file;
                }
                break;
              }
              hlt_next_file:
              x++;
            }
            if (x < 224 && finfo[x].name[0] != 0x00){
              p = (char *) memman_alloc_4k(memman, finfo[x].size);
              file_loadfile(finfo[x].clustno, finfo[x].size, p, fat, (char *) (ADR_DISKIMG + 0x003e00));
              set_segmdesc(gdt + 1003, finfo[x].size - 1, (int) p, AR_CODE32_ER);
              farjmp(0, 1003 * 8);
              memman_free_4k(memman, (int) p, finfo[x].size);
            }
            else{
              putfonts8_asc_sht(sheet, 8, cursor_y, COL8_FFFFFF, COL8_000000, "File not found.", 15);
							cursor_y = cons_newline(cursor_y, sheet);
            }
            cursor_y = cons_newline(cursor_y, sheet);
          }
          else if (cmdline[0] != 0){ //コマンドでも空白でもない
            putfonts8_asc_sht(sheet, 8, cursor_y, COL8_FFFFFF, COL8_000000, "command not found", 20);
						cursor_y = cons_newline(cursor_y, sheet);
						cursor_y = cons_newline(cursor_y, sheet);
          }
          putfonts8_asc_sht(sheet, 8, cursor_y, COL8_FFFFFF, COL8_000000, ">", 1);
					cursor_x = 16;
        }
        else{
          if (cursor_x < 240) {
            s[0] = i - 256;
						s[1] = 0;
            cmdline[cursor_x / 8 - 2] = i - 256;
						putfonts8_asc_sht(sheet, cursor_x, cursor_y, COL8_FFFFFF, COL8_000000, s, 1);
						cursor_x += 8;
					}
        }
      }
      //カーソル再表示
      if (cursor_c >= 0) boxfill8(sheet->buf, sheet->bxsize, cursor_c, cursor_x, cursor_y, cursor_x + 7, cursor_y + 15);
      sheet_refresh(sheet, cursor_x, cursor_y, cursor_x + 8, cursor_y + 16);
    }
  }
}

int cons_newline(int cursor_y, struct SHEET *sheet){
	int x, y;
	if (cursor_y < 28 + 112) cursor_y += 16; // 次の行へ
	else {
		for (y = 28; y < 28 + 112; y++) {
			for (x = 8; x < 8 + 240; x++) {
				sheet->buf[x + y * sheet->bxsize] = sheet->buf[x + (y + 16) * sheet->bxsize];
			}
		}
		for (y = 28 + 112; y < 28 + 128; y++) {
			for (x = 8; x < 8 + 240; x++) {
				sheet->buf[x + y * sheet->bxsize] = COL8_000000;
			}
		}
		sheet_refresh(sheet, 8, 28, 8 + 240, 28 + 128);
	}
	return cursor_y;
}

int strcmp(char *p1, char *p2){
  for(; *p1 == *p2; p1++, p2++){
    if(*p1 == '\0') return 0;
  }
  return 1;
}

int strncmp(char *p1, char *p2, int n){
  for(; *p1 == *p2; p1++, p2++){
    if(*p1 == '\0' || !--n) return 0;
  }
  return *p1 - *p2;
}