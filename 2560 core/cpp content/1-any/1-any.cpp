
/*
* 1-any.cpp
* Created: 2024-10-27 00:10:33
* Author: OverCV
*/

#include <avr/io.h>
#include <avr/iom2560.h>

class LED
{
private:
    /* data */
public:
    LED() {
        DDRB |= (1 << DDB7);
    }
};

int main(void) {
    /* Replace with yourw initialization code */
    while(1) {
        /* Replace with your loop code */
        // cout << "Hello World!" << endl;
    }
    return 0;
}
