#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <iomanip>

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

  ofstream output;
  output.open("spice_data.cir");

  output<<setprecision(10)<<"Vcc 1 0 "<<y[7]<<endl;
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

  output.close();





  return 0;
}
