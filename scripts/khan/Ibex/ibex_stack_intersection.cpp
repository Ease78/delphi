#include "ibex.h"
#include <iostream>
#include <fstream>

using namespace std;
using namespace ibex;

int main()
{

  int N = 2;
  float tmax_lb[N], tmax_ub[N], tmin_lb[N], tmin_ub[N];


  vector<IntervalVector> s;
  int num = 0;
  while(num < N)
  {

    tmax_lb[num] = 2.0 + num;
    tmax_ub[num] = tmax_lb[num] + 2;

    tmin_lb[num] = 2.0 + num;
    tmin_ub[num] = tmin_lb[num] + 2;

    double _box[2][2] = {{tmax_lb[num], tmax_ub[num]}, {tmin_lb[num], tmin_ub[num]}};
    IntervalVector box(2, _box);
    
    Set s3(box);

    //s.push_back(s3);
    s.push_back(box);

    num++;
  }

  double _x[2][2] = {{0, 0.4}, {0.1, 0.3}};
  IntervalVector x(2, _x);
  cout  << x << endl;
  Set s1(x);
  //cout << s1 << endl;

  double _y[2][2] = {{0.3, 0.5}, {0.2, 0.4}};
  IntervalVector y(2, _y);
  cout  << y << endl;
  Set s2(y);
  //cout << s2 << endl;

  double _z[2][2] = {{1, 1.5}, {1.2, 1.4}};
  IntervalVector z(2, _z);

  y &= x;
  cout  << y << endl;
  //cout << y.intersects(x) << endl;
  //cout << z.intersects(x) << endl;
  
  //Interval y(0.3, 0.5);
  //Set s2(y);
  //cout << s2 << endl;

  s2 &= s1;
  //cout << s2 << endl;
  
  //Set set(IntervalVector(2, Interval(0,1)));
  //cout << set << endl;

  return 0;
}