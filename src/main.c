#include <stdint.h>
#include <stdio.h>

extern void initialise_monitor_handles(void);

void wait_ms(uint32_t time){
    for(int i = 0; i < time; i++){
        for(int j = 0; j < 1600; j++);
    }
}

int main(void){

    initialise_monitor_handles();

    printf("Heyy There\n");
    wait_ms(1000);
    printf("Heyy There\n");
    wait_ms(1000);
    printf("Heyy There\n");
    wait_ms(1000);

    for(;;);
}
