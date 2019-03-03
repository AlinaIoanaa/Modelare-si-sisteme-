clc ;
close all ;
clear all ;

% Variabilele cunoscute
ro = 1000 ;
g = 9.8 ;

A1 = 0.06 ;
A2 = 0.06 ;
A4 = 0.06 ;
A3 = 0.06 ;

At = 0.1273 ;

a1 = 1.31 * ( 10 ^ ( -4 ) ) ;
a2 = 1.51 * ( 10 ^ ( -4 ) ) ;
a3 = 9.27 * ( 10 ^ ( -5 ) ) ;
a4 = 8.82 * ( 10 ^ ( -5 ) ) ;
ac = 4.307 * ( 10 ^ ( -6 ) ) ;

Q1tilda = 3.26 ;
Q2tilda = 4 ;

kp = 0.5 * ( 10 ^ ( -4 ) ) ;

gamma1 = 0.25 ;
gamma2 = 0.5 ;

% Intrare
t=linspace( 0, 40, 100 ) ;

u1in = 1 * double( ( t >= 0 ) .* ( t <= 10 ) ) ; 
u2in = 0 .* t ;


% Valori initiale 1
h1 = 0 ; 
h2 = 0 ; 
h3 = 0 ; 
h4 = 0 ;
h  = 0 ;

% schema simulink
load_system( 'schema_simulink' ) ;
set_param( 'schema_simulink', 'StopTime', num2str( t( end ) ) ) ;
sim( 'schema_simulink' ) ;

figure ;
grid on ;
hold on ;
plot( h2_h3out.Time, h2_h3out.Data ) ; 


% Valori initiale 2
h1 = 2 * kp ; 
h2 = 3 * kp ; 
h3 = 4 * kp ; 
h4 = 5 * kp ;
h  = 6 * kp ;

% schema simulink
set_param( 'schema_simulink', 'StopTime', num2str( t( end ) ) ) ;
sim( 'schema_simulink' ) ;

hold on ;
plot( h2_h3out.Time, h2_h3out.Data ) ; 


% Valori initiale 3
h1 = 10 * kp ; 
h2 = 5 * kp ; 
h3 = 7 * kp ; 
h4 = 5 * kp ;
h  = 12 * kp ;

% schema simulink
set_param( 'schema_simulink', 'StopTime', num2str( t( end ) ) ) ;
sim( 'schema_simulink' ) ;

hold on ;
plot( h2_h3out.Time, h2_h3out.Data ) ;
title( 'Comparatii intre grafice cu aceleasi intrari si valori initiale diferite' ) ;
legend( 'time 1', 'data 1', 'time 2', 'data 2', 'time 3', 'data 3' ) ;

% time 1, data 1 -> iesirile asociate primului set de valori initiale
% time 2, data 2 -> iesirile asociate celui de-al doilea set de valori initiale
% time 3, data 3 -> iesirile asociate celui de-al treilea set de valori initiale


% Valori initiale 
h1 = 0 ; 
h2 = 0 ; 
h3 = 0 ; 
h4 = 0 ;
h  = 0 ;

% h1 = 10 * kp ; 
% h2 = 5 * kp ; 
% h3 = 7 * kp ; 
% h4 = 5 * kp ;
% h  = 12 * kp ;

% Intrari( ustar )
T = 50 ;
t = linspace( 0, T, 1e4 ) ;
ustar = [ 0 0.5 1 2 2.3 2.4 2.7 3 3.5 4 ] ;
%ustar = linspace( 1, 5, 10 ) ;
%ustar = 0.5 : 0.5 : 5 ;

for i = 1 : length( ustar )
    u1in = timeseries( 0 .* double( t >= 0 ) .', t ) ;
    u2in = timeseries( ustar( i ) .* double( t >= 0 ) .', t ) ;
    
    load_system( 'schema_simulink' ) ;
    set_param( 'schema_simulink', 'StopTime', num2str( t( end ) ) ) ;
    sim( 'schema_simulink' ) ;
  
    ystar( i, 1 ) = h2_h3out.Data( end, 1 ) ;
    % datele de iesire ale lui h2
    ystar( i, 2 ) = h2_h3out.Data( end, 2 ) ;
    % datele de iesire ale lui h3
end

% Caracteristica statica
figure ;
grid on ;
hold on ;
plot( ustar, ystar( :, 1 ), 'm' ) ;
hold on
plot( ustar, ystar( :, 2 ), 'y' ) ;
legend( 'h2', 'h3' ) ;
title( 'Caracteristica statica' ) ;


% Polyfit
p1 = polyfit( h2_h3out.Time, h2_h3out.Data( :, 1 ), 10 ) ;
p2 = polyfit( h2_h3out.Time, h2_h3out.Data( : , 2 ), 10 ) ;

y1 = polyval( p1, h2_h3out.Time ) ;
y2 = polyval( p2, h2_h3out.Time ) ;

% plotare
figure ;
plot( h2_h3out.Time, y1 ) ;
hold on
plot( h2_h3out.Time, y2 ) ;
hold off
title( 'Polyfit' ) ;
legend( 'h2', 'h3' ) ;
%p( :, 1 ) = polyfit( time , ystar( :, 1 ), length( ustar ) - 2 ) ;
%p( :, 2 ) = polyfit( time , ystar( :, 2 ), length( ustar ) - 2 ) ;