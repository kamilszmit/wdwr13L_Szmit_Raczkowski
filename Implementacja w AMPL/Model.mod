#plik modelu


#Deklaracje zbiorow zawartych w pliku danych
set FABRYKI;
set MAGAZYNY;
set KLIENCI;
set Praw;

#Deklaracje parametrow zawartych w pliku danych
#scenariusze kosztu dostaw FABRYKA->MAGAZYN
param e1 {FABRYKI,MAGAZYNY};
param e2 {FABRYKI,MAGAZYNY};
param e3 {FABRYKI,MAGAZYNY};
#scenariusze kosztu dostaw MAGAZYN->KLIENT
param t1 {MAGAZYNY,KLIENCI};
param t2 {MAGAZYNY,KLIENCI};
param t3 {MAGAZYNY,KLIENCI};
#scenariusze kosztu dostaw FABRYKA->KLIENT
param w1 {FABRYKI,KLIENCI};
param w2 {FABRYKI,KLIENCI};
param w3 {FABRYKI,KLIENCI};
#miesieczne mozliwosci produkcyjne fabryk
param a {FABRYKI};
#miesieczne zapotrzebowania klientow
param b {KLIENCI};
#miesieczna ilosc obslugiwanego towaru przez magazyny
param s {m in MAGAZYNY};
#parametry pomocnicze
param N;
param P {y in Praw};
param wk;
param wr;


#zmienne okreœlaj¹ce, ilosc towaru dla konkretnego polaczenia
var x {FABRYKI,MAGAZYNY} >= 0;
var z {MAGAZYNY,KLIENCI} >= 0;
var r {FABRYKI,KLIENCI} >= 0;

#zmienne okreslajace calkowite koszty dla konkretnych scenariuszy
var f1;
var f2;
var f3;
#zmienne okreslajace calkowity koszt i ryzyko
var f;
var g;

#Zmienne pomocnicze do obliczania sredniej roznicy Giniego
var f12p >= 0;
var f12n >= 0;
var f23p >= 0;
var f23n >= 0;
var f13p >= 0;
var f13n >= 0;




#ograniczenie na miesieczne mozliwosci produkcyjne magazynow
s.t. zp {k in FABRYKI}: (sum {m in MAGAZYNY} x[k,m]) + (sum {i in KLIENCI} r[k,i]) <=  a[k];
#ograniczenie na miesieczne zapotrzebowania klientow
s.t. zk {i in KLIENCI}: (sum {k in FABRYKI} r[k,i]) + (sum {m in MAGAZYNY} z[m,i]) =  b[i];
#ograniczenie na miesieczna ilosc obslugiwanego towaru w magazynie
s.t. pm {m in MAGAZYNY}: (sum {k in FABRYKI} x[k,m]) <= s[m];
#ograniczenie na ilosc wplywajacego i wyplywajacego towaru z magazynu 
s.t. mag {m in MAGAZYNY}: (sum {k in FABRYKI} x[k,m]) = (sum {i in KLIENCI} z[m,i]);
#ograniczenia na przesylanie towarow gdy koszt jest rowny 0
s.t. xN {k in FABRYKI, m in MAGAZYNY}: x[k,m] <= N * e1[k,m];
s.t. zN {m in MAGAZYNY, i in KLIENCI}: z[m,i] <= N* t1[m,i];
s.t. rN {k in FABRYKI, i in KLIENCI}: r[k,i] <= N * w1[k,i];

#ograniczenia na calkowite koszty dla konkretnych scenariuszy
s.t. ogrtof1: f1 = (sum{k in FABRYKI, m in MAGAZYNY} x[k,m]*e1[k,m]) + (sum {m in MAGAZYNY, i in KLIENCI} z[m,i] * t1[m,i]) + (sum {k in FABRYKI, i in KLIENCI} r[k,i]*w1[k,i]);
s.t. ogrtof2: f2 = (sum{k in FABRYKI, m in MAGAZYNY} x[k,m]*e2[k,m]) + (sum {m in MAGAZYNY, i in KLIENCI} z[m,i] * t2[m,i]) + (sum {k in FABRYKI, i in KLIENCI} r[k,i] * w2[k,i]);
s.t. ogrtof3: f3 = (sum{k in FABRYKI, m in MAGAZYNY} x[k,m]*e3[k,m]) + (sum {m in MAGAZYNY, i in KLIENCI} z[m,i] * t3[m,i]) + (sum {k in FABRYKI, i in KLIENCI} r[k,i] * w3[k,i]);
#srednia kosztu po wszystkich scenariuszach
s.t. sumaf: f= 0.2 * f1 + 0.2 * f2 + 0.6 * f3;
#srednia giniego
s.t. cf12: f1 - f2  = f12p - f12n;
s.t. cf23: f2 - f3  = f23p - f23n;
s.t. cf13: f1 - f3  = f13p - f13n;
#œrednia giniego wzor ogolny
s.t. sumag: g= 2 * ((f12p + f12n) * 0.2 * 0.2 + (f23p + f23n) * 0.2 * 0.6 + (f13p + f13n) * 0.2 * 0.6);


#funkcja celu
minimize h: wk * f + wr * g;


end;

