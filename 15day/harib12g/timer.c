#include "bootpack.h"

#define PIT_CTRL    0x0043
#define PIT_CNT0    0x0040

struct TIMERCTL timerctl;

#define TIMER_FLAGS_ALLOC   1 //確保した状態
#define TIMER_FLAGS_USING   2 //タイマ作動中

void init_pit(void){
    int i;
    struct TIMER *t;
    io_out8(PIT_CTRL, 0x34);
    io_out8(PIT_CNT0, 0x9c);
    io_out8(PIT_CNT0, 0x2e);
    timerctl.count = 0;
    for (i = 0; i < MAX_TIMER; i++){
        timerctl.timers0[i].flags = 0; //未使用
    }
    t = timer_alloc(); //一つもらってくる
    t->timeout = 0xffffffff;
    t->flags = TIMER_FLAGS_USING;
    t->next = 0; //一番後ろ
    timerctl.t0 = t; //先頭
    timerctl.next = 0xffffffff; //番兵の時刻
    return;
}

struct TIMER *timer_alloc(void){
    int i;
    for (i = 0; i < MAX_TIMER; i++){
        if (timerctl.timers0[i].flags == 0){
            timerctl.timers0[i].flags = TIMER_FLAGS_ALLOC;
            return &timerctl.timers0[i];
        }
    }
    return 0; //見つからなかった
}

void timer_free(struct TIMER *timer){
    timer->flags = 0; //未使用
    return;
}

void timer_init(struct TIMER *timer, struct FIFO32 *fifo, unsigned char data){
    timer->fifo = fifo;
    timer->data = data;
    return;
}

void timer_settime(struct TIMER *timer, unsigned int timeout){
    int e;
    struct TIMER *t, *s;
    timer->timeout = timeout + timerctl.count;
    timer->flags = TIMER_FLAGS_USING;
    e = io_load_eflags();
    io_cli();
    t = timerctl.t0;
    if (timer->timeout <= t->timeout){ //先頭に入れる場合
        timerctl.t0 = timer;
        timer->next = t;
        timerctl.next = timer->timeout;
        io_store_eflags(e);
        return;
    }
    for (;;) {
		s = t;
		t = t->next;
		if (timer->timeout <= t->timeout) {
			s->next = timer;
			timer->next = t;
			io_store_eflags(e);
			return;
		}
	}
}

void inthandler20(int *esp){
    struct TIMER *timer;
    char ts = 0;
    io_out8(PIC0_OCW2, 0x60); //IRQ-00の受付完了をPICに通知
    timerctl.count++;
    if (timerctl.next > timerctl.count) return;
    timer = timerctl.t0; //先頭の番地を代入
    for (;;) {
		if (timer->timeout > timerctl.count) break;
		timer->flags = TIMER_FLAGS_ALLOC;
        if (timer != mt_timer) fifo32_put(timer->fifo, timer->data);
        else ts = 1;
		timer = timer->next; //次のタイマ-番地を記入
	}
	timerctl.t0 = timer;
	timerctl.next = timer->timeout;
    if (ts != 0) mt_taskswitch();
    return;
}