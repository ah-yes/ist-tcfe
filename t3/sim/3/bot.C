#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <iomanip>
#include <sstream>
#include <limits>

std::fstream& GotoLine(std::fstream& file, unsigned int num){
    file.seekg(std::ios::beg);
    for(int i=0; i < num - 1; ++i){
        file.ignore(std::numeric_limits<std::streamsize>::max(),'\n');
    }
    return file;
}

using namespace std;

int main(){

  ifstream file;
  file.open("data.txt");

double a;
string s;
vector<string> v;

  while(getline(file,s)){
    v.push_back(s);
  }

vector<double> y;
size_t size;

for(auto x : v){
  for(int i=0; i<x.size(); i++){


y.push_back(stod(x.substr(i), &size));
i+=size;
}
}
//-------------------------SEGUNDO FICHEIRO----------------------
fstream file_1;
file_1.open("boundary.log");

string line;

GotoLine(file_1,24);
int i=1;
while(i<4){
file_1>>line;
i++;
}

double c,b;
b=stod(line.substr(0),&size);

while(i<10){
file_1>>line;
i++;
}

c=stod(line.substr(0),&size);

  ofstream output;
  output.open("spice_data.cir");

  output<<setprecision(10)<<"Vcc 1 0 "<<0<<endl;
  output<<"GB 6 3 (2,5) "<<y[9]<<"m"<<endl;
  output<<"Vd 7 4 0"<<endl;
  output<<"HD 5 8 Vd "<<y[10]<<"k"<<endl;
  output<<"R1 2 1 "<<y[0]<<"k"<<endl;
  output<<"R2 2 3 "<<y[1]<<"k"<<endl;
  output<<"R3 2 5 "<<y[2]<<"k"<<endl;
  output<<"R4 0 5 "<<y[3]<<"k"<<endl;
  output<<"R5 6 5 "<<y[4]<<"k"<<endl;
  output<<"R6 0 7 "<<y[5]<<"k"<<endl;
  output<<"R7 4 8 "<<y[6]<<"k"<<endl;
  output<<"C 6 8 "<<y[8]<<"u"<<endl;

  output<<".op\n.ic V(6)="<<b<<" v(8)="<<c<<"\n.end\n";

  output.close();





  return 0;
}
