#include <fstream>
using namespace std;

int main(){
	ofstream out;
	out.open("output1.txt");
	out<<"hello\nworld\nand\nhello\nkitty\n";
	out.close();
	out.open("output2.txt");
	out<<"hello\nworld\nand\nhello\nkitty\n";
	out.close();
	out.open("output3.txt");
	out<<"hello\nworld\nand\nhello\nkitty";
	out.close();
	out.open("output4.txt");
	out<<"hello\nworld\nand\nhello\nkitty";
	out.close();
}
