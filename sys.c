#include <stdlib.h>

int main(){
	system("lscpu | grep ID ; lscpu | grep name ; lscpu | grep Fam ; lscpu | grep Ar ; top -bn1 | grep 'Cpu(s)' ; lscpu | grep ID >> resultado.txt ; lscpu | grep name >> resultado.txt ; lscpu | grep Fam >> resultado.txt ; lscpu | grep Ar >> resultado.txt ; top -bn1 | grep 'Cpu(s)' >> resultado.txt");
}
